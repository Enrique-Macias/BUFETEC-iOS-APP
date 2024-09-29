import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import os

struct UserData: Codable {
    var firebaseUID: String = ""
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
        case error(String)
    }
    
    @Published var authState: AuthState = .signedOut
    @Published var userData = UserData()
    @Published var isLoading = false
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "AuthModel")
    private let baseURL = "http://localhost:3000" // Update this with your actual base URL
    
    init() {
        checkUserSession()
    }
    
    func checkUserSession() {
        logger.info("Checking user session")
        if let user = Auth.auth().currentUser {
            userData.firebaseUID = user.uid
            if !user.isEmailVerified {
                authState = .needsEmailVerification
            } else {
                authState = .authenticated
                Task {
                    await fetchUserInfo()
                }
            }
        } else {
            authState = .signedOut
        }
    }
    
    @MainActor
    func signUp(password: String) async {
        logger.info("Starting sign up process")
        authState = .signingIn
        isLoading = true
        do {
            guard ["abogado", "cliente", "admin"].contains(userData.tipo) else {
                throw NSError(domain: "ValidationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid user type"])
            }
            
            let authResult = try await Auth.auth().createUser(withEmail: userData.email, password: password)
            userData.firebaseUID = authResult.user.uid
            try await createUserInfo()
            try await initiateEmailVerification()
            authState = .needsEmailVerification
            logger.info("Sign up successful, email verification needed")
        } catch {
            logger.error("Sign up failed: \(error.localizedDescription)")
            authState = .error(error.localizedDescription)
        }
        isLoading = false
    }
    
    @MainActor
    func login(email: String, password: String) async {
        logger.info("Starting login process")
        authState = .signingIn
        isLoading = true
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            userData.firebaseUID = authResult.user.uid
            if !authResult.user.isEmailVerified {
                authState = .needsEmailVerification
            } else {
                await fetchUserInfo()
                authState = .authenticated
            }
            logger.info("Login successful")
        } catch {
            logger.error("Login failed: \(error.localizedDescription)")
            authState = .error(error.localizedDescription)
        }
        isLoading = false
    }
    
    @MainActor
    func signInWithGoogle() async {
        logger.info("Starting Google Sign-In process")
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            authState = .error("Failed to get Google client ID")
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            authState = .error("Failed to get root view controller")
            return
        }
        
        do {
            authState = .signingIn
            isLoading = true
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            guard let idToken = result.user.idToken?.tokenString else {
                throw NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get ID token from Google"])
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)
            let authResult = try await Auth.auth().signIn(with: credential)
            
            userData.firebaseUID = authResult.user.uid
            userData.email = result.user.profile?.email ?? ""
            userData.nombre = result.user.profile?.name ?? ""
            userData.tipo = "cliente" // Default type
            
            // Attempt to fetch existing user data
            let userDataExists = await fetchUserInfo()
            
            if userDataExists {
                if userData.celular.isEmpty || userData.genero.isEmpty || userData.fechaDeNacimiento.isEmpty {
                    authState = .needsAdditionalInfo
                    logger.info("Google Sign-In successful, requesting additional info for existing user")
                } else {
                    authState = .authenticated
                    logger.info("Google Sign-In successful, existing user profile complete")
                }
            } else {
                authState = .needsAdditionalInfo
                logger.info("Google Sign-In successful, new user, requesting additional info")
            }
        } catch {
            logger.error("Google Sign-In failed: \(error.localizedDescription)")
            authState = .error(error.localizedDescription)
        }
        isLoading = false
    }
    
    @MainActor
    func completeUserProfile(celular: String, genero: String, fechaDeNacimiento: String) async {
        logger.info("Completing user profile")
        authState = .authenticating
        isLoading = true
        do {
            userData.celular = celular
            userData.genero = genero
            userData.fechaDeNacimiento = fechaDeNacimiento
            
            // Check if user already exists in our database
            let userExists = await fetchUserInfo()
            
            if userExists {
                // Update existing user
                try await updateUserInfo(newData: [
                    "celular": celular,
                    "genero": genero,
                    "fechaDeNacimiento": fechaDeNacimiento
                ])
            } else {
                // Create new user
                try await createUserInfo()
            }
            
            await fetchUserInfo() // Fetch updated user info
            authState = .authenticated
            logger.info("User profile completed successfully")
        } catch {
            logger.error("Failed to complete user profile: \(error.localizedDescription)")
            authState = .error(error.localizedDescription)
        }
        isLoading = false
    }
    
    @MainActor
    func logout() async {
        logger.info("Logging out")
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            authState = .signedOut
            userData = UserData()
            logger.info("Logout successful")
        } catch {
            logger.error("Logout failed: \(error.localizedDescription)")
            authState = .error(error.localizedDescription)
        }
    }
    
    private func createUserInfo() async throws {
        logger.info("Creating user info on server")
        guard let url = URL(string: "\(baseURL)/crearUsuario") else {
            throw NSError(domain: "URLError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(try await Auth.auth().currentUser!.getIDToken())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let userDict: [String: Any] = [
            "user": [
                "firebaseUID": userData.firebaseUID,
                "nombre": userData.nombre,
                "email": userData.email,
                "tipo": userData.tipo,
                "genero": userData.genero,
                "celular": userData.celular,
                "fechaDeNacimiento": userData.fechaDeNacimiento
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: userDict, options: [])
        request.httpBody = jsonData
        
        print("Sending JSON for create: \(String(data: jsonData, encoding: .utf8) ?? "")")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            logger.error("Server responded with an error when creating user info")
            if let errorMessage = String(data: data, encoding: .utf8) {
                throw NSError(domain: "ServerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server error: \(errorMessage)"])
            } else {
                throw NSError(domain: "ServerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server responded with an error when creating user info"])
            }
        }
        
        // Parse the response
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let insertedId = json["insertedId"] as? String {
            logger.info("User info created successfully with ID: \(insertedId)")
        } else {
            throw NSError(domain: "ServerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server did not return expected response for user creation"])
        }
    }
    
    func updateUserInfo(newData: [String: Any]) async throws {
        logger.info("Updating user info")
        do {
            var updateData = newData
            updateData["firebaseUID"] = userData.firebaseUID
            try await editUserInfo(newData: updateData)
            await fetchUserInfo() // Fetch updated user info
            logger.info("User info updated successfully")
        } catch {
            logger.error("Failed to update user info: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func editUserInfo(newData: [String: Any]) async throws {
        logger.info("Editing user info on server")
        guard let url = URL(string: "\(baseURL)/editarUsuario") else {
            throw NSError(domain: "URLError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(try await Auth.auth().currentUser!.getIDToken())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONSerialization.data(withJSONObject: newData, options: [])
        request.httpBody = jsonData
        
        print("Sending JSON for edit: \(String(data: jsonData, encoding: .utf8) ?? "")")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "ServerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])
        }
        
        if httpResponse.statusCode == 404 {
            throw NSError(domain: "ServerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        
        if httpResponse.statusCode == 400 {
            throw NSError(domain: "ServerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Bad request: \(String(data: data, encoding: .utf8) ?? "Unknown error")"])
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            logger.error("Server responded with an error when editing user info")
            throw NSError(domain: "ServerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server responded with an error when editing user info: \(String(data: data, encoding: .utf8) ?? "Unknown error")"])
        }
        
        // Parse the response
        if let updatedUser = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            logger.info("User info edited successfully")
            updateUserDataFromResponse(updatedUser)
        } else {
            throw NSError(domain: "ServerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server did not return expected response for user edit"])
        }
    }
    
    private func updateUserDataFromResponse(_ response: [String: Any]) {
        DispatchQueue.main.async {
            if let nombre = response["nombre"] as? String {
                self.userData.nombre = nombre
            }
            if let celular = response["celular"] as? String {
                self.userData.celular = celular
            }
            if let email = response["email"] as? String {
                self.userData.email = email
            }
            if let genero = response["genero"] as? String {
                self.userData.genero = genero
            }
            if let fechaDeNacimiento = response["fechaDeNacimiento"] as? String {
                self.userData.fechaDeNacimiento = fechaDeNacimiento
            }
            if let tipo = response["tipo"] as? String {
                self.userData.tipo = tipo
            }
        }
    }
    
    private func initiateEmailVerification() async throws {
        logger.info("Initiating email verification")
        try await Auth.auth().currentUser?.sendEmailVerification()
        logger.info("Email verification initiated successfully")
    }
    
    @MainActor
    func refreshEmailVerificationStatus() async {
        guard let user = Auth.auth().currentUser else {
            authState = .signedOut
            return
        }
        
        do {
            try await user.reload()
            if user.isEmailVerified {
                authState = .authenticated
                await fetchUserInfo()
            } else {
                authState = .needsEmailVerification
            }
        } catch {
            logger.error("Failed to refresh email verification status: \(error.localizedDescription)")
            authState = .error("Failed to refresh email verification status. Please try again.")
        }
    }
    
    @MainActor
    func resendVerificationEmail() async {
        guard let user = Auth.auth().currentUser else {
            authState = .signedOut
            return
        }
        
        do {
            try await user.sendEmailVerification()
            logger.info("Verification email resent successfully")
        } catch {
            logger.error("Failed to resend verification email: \(error.localizedDescription)")
            authState = .error("Failed to resend verification email. Please try again later.")
        }
    }
    
    @MainActor
    func fetchUserInfo() async -> Bool {
        logger.info("Fetching user info from server")
        guard let url = URL(string: "\(baseURL)/getUsuario?uid=\(userData.firebaseUID)") else {
            authState = .error("Invalid URL")
            return false
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(try await Auth.auth().currentUser!.getIDToken())", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: "ServerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])
            }
            
            if httpResponse.statusCode == 404 {
                // User not found, treat as new user
                logger.info("User not found on server, treating as new user")
                return false
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw NSError(domain: "ServerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server responded with an error when fetching user info"])
            }
            
            let fetchedUserData = try JSONDecoder().decode(UserData.self, from: data)
            self.userData = fetchedUserData
            logger.info("User info fetched successfully")
            return true
        } catch {
            logger.error("Failed to fetch user info: \(error.localizedDescription)")
            if (error as NSError).domain == "ServerError" {
                authState = .error(error.localizedDescription)
            } else {
                // If it's not a server error, treat as new user
                logger.info("Treating as new user due to fetch error")
                return false
            }
        }
        return false
    }
}
