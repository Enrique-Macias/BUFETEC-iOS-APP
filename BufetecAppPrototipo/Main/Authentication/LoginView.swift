import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct LoginView: View {
    @EnvironmentObject var authModel: AuthModel
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isShowingSignUp: Bool
    
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showingPasswordReset = false

    @FocusState private var focusedField: Field?
    
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    enum Field: Hashable {
        case email, password
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundView
                
                VStack(spacing: 0) {
                    logoView
                        .position(appState.logoPosition)
                        .offset(y: 59)
                    loginContent
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .disabled(authModel.isLoading)
        .overlay(loadingOverlay)
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showingPasswordReset) {
            AnyEmailPasswordResetView(email: $email)
        }
    }
    
    private var backgroundView: some View {
        Color("btBackground")
            .edgesIgnoringSafeArea(.all)
    }
    
    private var logoView: some View {
        Image("LogoBufetec")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: UIScreen.main.bounds.width * 0.5)
    }
    
    private var loginContent: some View {
        VStack {
            Spacer()
            welcomeImage
            emailField
            passwordField
            loginButton
            googleSignInButton
            passwordRecoveryButton
            signUpPrompt
        }
    }
    
    
    private var welcomeImage: some View {
        Image("bye")
            .resizable()
            .scaledToFit()
            .frame(height: 150)
            .padding(.bottom, 40)
    }
    
    private var emailField: some View {
        InputField(
            icon: "envelope",
            placeholder: "Email",
            text: $email
        )
        .focused($focusedField, equals: .email)
    }
    
    private var passwordField: some View {
        PasswordField(
            password: $password,
            showPassword: $showPassword,
            placeholder: "Contraseña"
        )
        .focused($focusedField, equals: .password)
        .padding(.top, 10)
    }
    
    private var loginButton: some View {
        Button(action: performLogin) {
            Text("Iniciar Sesión")
                .font(CustomFonts.MontserratBold(size: 16))
                .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                .background(colorScheme == .light ? Color.black : Color.white)
                .cornerRadius(16)
        }
        .disabled(email.isEmpty || password.isEmpty)
        .padding(.vertical)
    }
    
    private var googleSignInButton: some View {
        Button(action: performGoogleSignIn) {
            HStack {
                Image(systemName: "g.circle.fill")
                Text("Continuar con Google")
                    .font(CustomFonts.MontserratBold(size: 16))
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
            .foregroundColor(colorScheme == .light ? Color.black : Color.white)
            .background(colorScheme == .light ? Color.white : Color.clear)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
            )
        }
        .padding(.horizontal)
    }
    
    private var passwordRecoveryButton: some View {
        Button(action: {
            showingPasswordReset = true
        }) {
            Text("Recuperar Contraseña")
                .foregroundColor(.primary)
                .font(CustomFonts.MontserratMedium(size: 14))
        }
        .padding(.top, 20)
    }
    
    private var signUpPrompt: some View {
        HStack {
            Text("No tienes una cuenta?")
                .font(CustomFonts.MontserratMedium(size: 14))
                .foregroundColor(.primary.opacity(0.5))
            
            Button(action: {
                isShowingSignUp = true
            }) {
                Text("Regístrate")
                    .font(CustomFonts.MontserratBold(size: 14))
                    .foregroundColor(.primary)
            }
        }
        .padding(.top, 2)
    }
    
    private var loadingOverlay: some View {
        Group {
            if authModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
            }
        }
    }
    
    private func performLogin() {
        Task {
            do {
                try await authModel.login(email: email, password: password)
                // Handle successful login (e.g., navigate to main app view)
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                }
            }
        }
    }
    
    private func performGoogleSignIn() {
        Task {
            do {
                try await authModel.signInWithGoogle()
                // Handle successful Google sign-in (e.g., navigate to main app view or additional info view)
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                }
            }
        }
    }
}

struct AnyEmailPasswordResetView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authModel: AuthModel
    @Binding var email: String
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("btBackground")
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        Image(systemName: "lock.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.primary)
                            .padding(.top, 40)
                        
                        Text("Restablecer Contraseña")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Ingrese su correo electrónico para recibir un enlace de restablecimiento de contraseña.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        InputField(icon: "envelope", placeholder: "Correo Electrónico", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        Button(action: sendResetEmail) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: colorScheme == .light ? Color.white : Color.black))
                                } else {
                                    Text("Enviar Enlace de Restablecimiento")
                                }
                            }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                            .background(colorScheme == .light ? Color.black : Color.white)
                            .cornerRadius(16)
                        }
                        .disabled(email.isEmpty || isLoading)
                        .opacity(email.isEmpty ? 0.6 : 1.0)
                    }
                    .padding()
                }
            }
            .navigationTitle("Restablecer Contraseña")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Cancelar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")) {
                if alertTitle == "Éxito" {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
    
    private func sendResetEmail() {
        isLoading = true
        Task {
            do {
                try await authModel.sendPasswordResetEmail(to: email)
                await MainActor.run {
                    alertTitle = "Éxito"
                    alertMessage = "Por favor, revise su bandeja de entrada y siga las instrucciones para restablecer su contraseña."
                    showAlert = true
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    alertTitle = "Error"
                    alertMessage = error.localizedDescription
                    showAlert = true
                    isLoading = false
                }
            }
        }
    }
}


#Preview {
    LoginView(isShowingSignUp: .constant(false))
        .environmentObject(AuthModel())
}
