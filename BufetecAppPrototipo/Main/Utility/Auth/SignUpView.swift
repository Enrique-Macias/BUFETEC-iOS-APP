import SwiftUI

struct SignUpView: View {
    @Environment(AppearanceManager.self) var appearanceManager: AppearanceManager
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authModel: AuthModel
    @Binding var isShowingSignUp: Bool
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var birthDate = Date()
    @State private var gender: String?
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    private var isSignUpDisabled: Bool {
        authModel.userData.nombre.isEmpty ||
        authModel.userData.email.isEmpty ||
        authModel.userData.celular.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        password != confirmPassword ||
        gender == nil
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("btBackground")
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Registro")
                            .font(CustomFonts.MontserratBold(size: 25))
                            .foregroundStyle(.primary)
                        
                        VStack(spacing: 15) {
                            InputField(icon: "person", placeholder: "Nombre", text: $authModel.userData.nombre)
                            InputField(icon: "phone", placeholder: "Celular", text: $authModel.userData.celular)
                                .keyboardType(.phonePad)
                            InputField(icon: "envelope", placeholder: "Email", text: $authModel.userData.email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                            PasswordField(password: $password, showPassword: $showPassword, placeholder: "Contraseña")
                            PasswordField(password: $confirmPassword, showPassword: $showConfirmPassword, placeholder: "Confirmar Contraseña")
                            HStack {
                                genderPicker
                                birthdatePicker
                            }
                        }
                        .padding(.horizontal)
                        
                        signUpButton
                        googleSignInButton
                        loginPrompt
                    }
                    .padding()
                }
                .disabled(authModel.isLoading)
                .overlay(loadingOverlay)
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private var genderPicker: some View {
        Menu {
            Button("Male") { gender = "male" }
            Button("Female") { gender = "female" }
            Button("Other") { gender = "other" }
        } label: {
            HStack {
                Image(systemName: "person")
                Text(gender ?? "Género")
                Spacer()
                Image(systemName: "chevron.down")
            }
            .padding()
            .frame(width: .infinity, height: 60)
            .background(colorScheme == .dark ? Color.clear : Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
            )
        }
    }
    
    private var birthdatePicker: some View {
        HStack {
            Image(systemName: "calendar")
//            Text("Fecha de nacimiento")
            Spacer()
            DatePicker("", selection: $birthDate, displayedComponents: [.date])
                .labelsHidden()
        }
        .padding()
        .frame(width: .infinity, height: 60)
        .background(colorScheme == .dark ? Color.clear : Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
        )
    }
    
    private var signUpButton: some View {
        Button(action: signUp) {
            Text("Registrarse")
                .font(CustomFonts.MontserratBold(size: 16))
                .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                .background(isSignUpDisabled ? Color.gray : (colorScheme == .light ? Color.black : Color.white))
                .cornerRadius(16)
        }
        .disabled(isSignUpDisabled || authModel.isLoading)
    }
    
    private var googleSignInButton: some View {
        Button(action: signInWithGoogle) {
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
        .disabled(authModel.isLoading)
    }
    
    private var loginPrompt: some View {
        HStack {
            Text("¿Ya tienes una cuenta?")
                .font(CustomFonts.MontserratMedium(size: 14))
                .foregroundColor(.primary.opacity(0.5))
            
            Button(action: {
                isShowingSignUp = false
            }) {
                Text("Inicia sesión")
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
    
    private func signUp() {
        Task {
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                authModel.userData.fechaDeNacimiento = dateFormatter.string(from: birthDate)
                authModel.userData.genero = gender ?? ""
                try await authModel.signUp(password: password)
                // Handle successful sign up (e.g., navigate to email verification view)
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                }
            }
        }
    }
    
    private func signInWithGoogle() {
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
    let placeholder: String
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            Image(systemName: "lock")
            Group {
                if showPassword {
                    TextField("", text: $password, prompt: Text(placeholder).foregroundStyle(.gray).kerning(0))
                } else {
                    SecureField("", text: $password, prompt: Text(placeholder).foregroundStyle(.gray).kerning(0))
                }
            }
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .kerning(0.8)
            .font(.custom("Manrope-Bold", size: 16))
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

//#Preview {
//    SignUpView(isShowingSignUp: .constant(true))
//        .environment(AppearanceManager())
//        .environmentObject(AuthModel())
//}
