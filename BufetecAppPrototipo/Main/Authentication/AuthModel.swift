import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import os

struct UserData: Codable {
    var uid: String = ""
    var nombre: String = ""
    var genero: String = ""
    var celular: String = ""
    var email: String = ""
    var fechaDeNacimiento: String = ""
    var tipo: String = "cliente" // Default to "cliente", can be "abogado" or "admin"
}

class AuthModel: ObservableObject {
    enum AuthState {
        case signedOut
        case signingIn
        case needsAdditionalInfo
        case authenticating
        case authenticated
        case needsEmailVerification
    }
    
    @Published var authState: AuthState = .signedOut
    @Published var userData = UserData()
    @Published var isLoading = false
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "AuthModel")
    private let baseURL = "http://localhost:3000"
    
    init() {
        checkUserSession()
    }
    
    func checkUserSession() {
        logger.info("Checking user session")
        if let user = Auth.auth().currentUser {
            userData.uid = user.uid
            if !user.isEmailVerified {
                authState = .needsEmailVerification
            } else {
                authState = .authenticated
                Task {
                    try? await fetchUserInfo()
                }
            }
        } else {
            authState = .signedOut
        }
    }
    
    @MainActor
    func signUp(password: String) async throws {
        logger.info("Starting sign up process")
        authState = .signingIn
        isLoading = true
        defer { isLoading = false }
        
        guard ["abogado", "cliente", "admin"].contains(userData.tipo) else {
            throw NSError(domain: "ValidationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid user type"])
        }
        
        let authResult = try await Auth.auth().createUser(withEmail: userData.email, password: password)
        userData.uid = authResult.user.uid
        try await createUserInfo()
        try await initiateEmailVerification()
        authState = .needsEmailVerification
        logger.info("Sign up successful, email verification needed")
    }
    
    @MainActor
    func login(email: String, password: String) async throws {
        logger.info("Starting login process")
        authState = .signingIn
        isLoading = true
        defer { isLoading = false }
        
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        userData.uid = authResult.user.uid
        if !authResult.user.isEmailVerified {
            authState = .needsEmailVerification
        } else {
            try await fetchUserInfo()
            authState = .authenticated
        }
        logger.info("Login successful")
    }
    
    @MainActor
    func signInWithGoogle() async throws {
        logger.info("Starting Google Sign-In process")
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(domain: "ConfigurationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get Google client ID"])
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            throw NSError(domain: "PresentationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get root view controller"])
        }
        
        authState = .signingIn
        isLoading = true
        defer { isLoading = false }
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        guard let idToken = result.user.idToken?.tokenString else {
            throw NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get ID token from Google"])
        }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)
        let authResult = try await Auth.auth().signIn(with: credential)
        
        userData.uid = authResult.user.uid
        userData.email = result.user.profile?.email ?? ""
        userData.nombre = result.user.profile?.name ?? ""
        userData.tipo = "cliente" // Default type
        
        // Attempt to fetch existing user data
        let userDataExists = try await fetchUserInfo()
        
        if userDataExists {
            if userData.celular.isEmpty || userData.genero.isEmpty || userData.fechaDeNacimiento.isEmpty {
                authState = .needsAdditionalInfo
                logger.info("Google Sign-In successful, requesting additional info for existing user")
            } else {
                authState = .authenticated
                logger.info("Google Sign-In successful, existing user profile complete")
            }
        } else {
            try await createUserInfo()
            authState = .needsAdditionalInfo
            logger.info("Google Sign-In successful, new user, requesting additional info")
        }
    }
    
    @MainActor
    func completeUserProfile(celular: String, genero: String, fechaDeNacimiento: String) async throws {
        logger.info("Completing user profile")
        authState = .authenticating
        isLoading = true
        defer { isLoading = false }
        
        try await updateUserInfo(fields: [
            "celular": celular,
            "genero": genero,
            "fechaDeNacimiento": fechaDeNacimiento
        ])
        
        authState = .authenticated
        logger.info("User profile completed successfully")
    }
    
    @MainActor
    func logout() async throws {
        logger.info("Logging out")
        try Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
        authState = .signedOut
        userData = UserData()
        logger.info("Logout successful")
    }
    
    private func createUserInfo() async throws {
        logger.info("Creating user info on server")
        guard let url = URL(string: "\(baseURL)/createUser") else {
            throw NSError(domain: "URLError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(userData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw NSError(domain: "ServerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server responded with an error when creating user info: \(String(data: data, encoding: .utf8) ?? "Unknown error")"])
        }
        
        logger.info("User info created successfully")
    }
    
    func updateUserInfo(fields: [String: Any]) async throws {
        logger.info("Updating user info")
        guard let url = URL(string: "\(baseURL)/updateUser") else {
            throw NSError(domain: "URLError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var updateData = fields
        updateData["uid"] = userData.uid
        
        let jsonData = try JSONSerialization.data(withJSONObject: updateData)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw NSError(domain: "ServerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server responded with an error when updating user info: \(String(data: data, encoding: .utf8) ?? "Unknown error")"])
        }
        
        let updatedUser = try JSONDecoder().decode(UserData.self, from: data)
        DispatchQueue.main.async {
            self.userData = updatedUser
        }
        
        logger.info("User info updated successfully")
    }
    
    private func initiateEmailVerification() async throws {
        logger.info("Initiating email verification")
        try await Auth.auth().currentUser?.sendEmailVerification()
        logger.info("Email verification initiated successfully")
    }
    
    @MainActor
    func refreshEmailVerificationStatus() async throws {
        guard let user = Auth.auth().currentUser else {
            authState = .signedOut
            return
        }
        
        try await user.reload()
        if user.isEmailVerified {
            authState = .authenticated
            try await fetchUserInfo()
        } else {
            authState = .needsEmailVerification
        }
    }
    
    @MainActor
    func resendVerificationEmail() async throws {
        guard let user = Auth.auth().currentUser else {
            authState = .signedOut
            return
        }
        
        try await user.sendEmailVerification()
        logger.info("Verification email resent successfully")
    }
    
    @MainActor
    func fetchUserInfo() async throws -> Bool {
        logger.info("Fetching user info from server")
        guard let url = URL(string: "\(baseURL)/getUser?uid=\(userData.uid)") else {
            throw NSError(domain: "URLError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "ServerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            let fetchedUserData = try JSONDecoder().decode(UserData.self, from: data)
            self.userData = fetchedUserData
            logger.info("User info fetched successfully")
            return true
        case 404:
            // User not found, treat as new user
            logger.info("User not found on server, treating as new user")
            return false
        default:
            throw NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server responded with an error when fetching user info: \(String(data: data, encoding: .utf8) ?? "Unknown error")"])
        }
    }
}

// MARK: - Convenience methods for updating user info
extension AuthModel {
    func updateUserName(newName: String) async throws {
        try await updateUserInfo(fields: ["nombre": newName])
    }
    
    func updateUserPhone(newPhone: String) async throws {
        try await updateUserInfo(fields: ["celular": newPhone])
    }
    
    func updateUserProfile(name: String? = nil, phone: String? = nil, gender: String? = nil) async throws {
        var fields: [String: Any] = [:]
        if let name = name { fields["nombre"] = name }
        if let phone = phone { fields["celular"] = phone }
        if let gender = gender { fields["genero"] = gender }
        
        try await updateUserInfo(fields: fields)
    }
}
