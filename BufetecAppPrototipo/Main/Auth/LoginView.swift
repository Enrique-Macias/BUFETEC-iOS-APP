import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct LoginView: View {
    @EnvironmentObject var authModel: AuthModel
    @Environment(AppearanceManager.self) var appearanceManager: AppearanceManager
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isShowingSignUp: Bool
    
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showLogin = false
    @State private var showContent = false
    @FocusState private var focusedField: Field?
    
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    enum Field: Hashable {
        case email, password
    }
    
    // Constants
    private let logoAnimationDelay: Double = 1.5
    private let logoAnimationDuration: Double = 0.4
    private let contentAnimationDuration: Double = 0.2
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView
                
                VStack {
                    logoView
                    
                    if showLogin {
                        loginContent
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
            }
            .disabled(authModel.isLoading)
            .overlay(loadingOverlay)
        }
        .onAppear(perform: setupAnimations)
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
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
            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.width * (showLogin ? 0.3 : 0.5))
            .padding(.top, showLogin ? 70 : -30)
            .foregroundStyle(.primary)
            .animation(.spring(duration: logoAnimationDuration), value: showLogin)
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
            Spacer()
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
            text: $email,
            field: .email
        )
        .focused($focusedField, equals: .email)
        .opacity(showContent ? 1 : 0)
        .animation(.easeIn(duration: contentAnimationDuration), value: showContent)
    }
    
    private var passwordField: some View {
        PasswordField(
            password: $password,
            showPassword: $showPassword,
            field: .password
        )
        .focused($focusedField, equals: .password)
        .padding(.top, 10)
        .opacity(showContent ? 1 : 0)
        .animation(.easeIn(duration: contentAnimationDuration), value: showContent)
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
        .opacity(showContent ? 1 : 0)
        .animation(.easeIn(duration: contentAnimationDuration), value: showContent)
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
            // Implement password recovery functionality
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
        .padding(.bottom, 40)
        .opacity(showContent ? 1 : 0)
        .animation(.easeIn(duration: contentAnimationDuration), value: showContent)
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
    
    private func setupAnimations() {
        DispatchQueue.main.asyncAfter(deadline: .now() + logoAnimationDelay) {
            withAnimation(.spring(duration: logoAnimationDuration)) {
                showLogin = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + logoAnimationDuration) {
                withAnimation(.easeIn(duration: contentAnimationDuration)) {
                    showContent = true
                }
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

struct InputField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    let field: LoginView.Field
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(.gray).kerning(0))
                .font(.custom("Manrope-Bold", size: 16))
                .kerning(0.8)
                .fontWeight(.bold)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
                .multilineTextAlignment(.leading)
        }
        .padding(18)
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 60, alignment: .leading)
        .background(colorScheme == .dark ? Color.clear : Color.white)
        .cornerRadius(16)
        .foregroundStyle(.primary)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
        )
    }
}

struct PasswordField: View {
    @Binding var password: String
    @Binding var showPassword: Bool
    let field: LoginView.Field
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            Image(systemName: "lock")
            Group {
                if showPassword {
                    TextField("", text: $password, prompt: Text("Contraseña").foregroundStyle(.gray).kerning(0))
                } else {
                    SecureField("", text: $password, prompt: Text("Contraseña").foregroundStyle(.gray).kerning(0))
                }
            }
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .kerning(0.8)
            .font(.custom("Manrope-Medium", size: 16))
            .multilineTextAlignment(.leading)
            
            Spacer()
            
            Button(action: { showPassword.toggle() }) {
                Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.primary)
                    .opacity(0.5)
            }
            .padding(.trailing, 6)
        }
        .padding(18)
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 60, alignment: .leading)
        .background(colorScheme == .dark ? Color.clear : Color.white)
        .cornerRadius(16)
        .foregroundStyle(.primary)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
        )
    }
}

#Preview {
    LoginView(isShowingSignUp: .constant(false))
        .environment(AppearanceManager())
        .environmentObject(AuthModel())
}
