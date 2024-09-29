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
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .padding(.top, 22)
                        
                        VStack(spacing: 15) {
                            inputField(icon: "person", placeholder: "Nombre", text: $authModel.userData.nombre)
                            inputField(icon: "phone", placeholder: "Celular", text: $authModel.userData.celular)
                                .keyboardType(.phonePad)
                            inputField(icon: "envelope", placeholder: "Email", text: $authModel.userData.email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                            inputField(icon: "lock", placeholder: "Contraseña", text: $password, isSecure: true)
                            inputField(icon: "lock", placeholder: "Confirmar Contraseña", text: $confirmPassword, isSecure: true)
                            
                            Picker("Género", selection: $gender) {
                                Text("Genero").tag(nil as String?)
                                Text("Male").tag("male" as String?)
                                Text("Female").tag("female" as String?)
                                Text("Other").tag("other" as String?)
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                            HStack {
                                Text("Fecha de nacimiento")
                                Spacer()
                                DatePicker("", selection: $birthDate, displayedComponents: [.date])
                                    .labelsHidden()
                            }
                        }
                        .padding(.horizontal)
                        
                        Button(action: signUp) {
                            Text("Registrarse")
                                .fontWeight(.bold)
                                .font(.system(size: 18))
                                .frame(maxWidth: .infinity)
                                .frame(height: 55)
                                .background(isSignUpDisabled ? Color.gray : (colorScheme == .light ? Color.black : Color.white))
                                .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                                .cornerRadius(8)
                        }
                        .disabled(isSignUpDisabled || authModel.isLoading)
                        .padding(.horizontal)
                        
                        Button(action: signInWithGoogle) {
                            HStack {
                                Image(systemName: "g.circle.fill")
                                    .foregroundColor(.black)
                                Text("Continuar con Google")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        }
                        .disabled(authModel.isLoading)
                        .padding(.horizontal)
                        
                        
                        Button(action: {
                            isShowingSignUp = false
                        }) {
                            Text("¿Ya tienes una cuenta? Inicia sesión")
                                .foregroundColor(Color.accentColor)
                                .underline()
                        }
                        .padding(.top, 10)
                        
                    }
                    .padding()
                }
                .disabled(authModel.isLoading)
                .overlay(
                    Group {
                        if authModel.isLoading {
                            ProgressView()
                                .scaleEffect(1.5)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                        }
                    }
                )
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func inputField(icon: String, placeholder: String, text: Binding<String>, isSecure: Bool = false) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.primary)
                .frame(width: 20)
            Group {
                if isSecure {
                    SecureField(placeholder, text: text)
                } else {
                    TextField(placeholder, text: text)
                }
            }
            .padding()
            .foregroundStyle(.primary)
            .frame(height: 25)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
        )
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

#Preview {
    SignUpView(isShowingSignUp: .constant(true))
        .environment(AppearanceManager())
        .environmentObject(AuthModel())
}
