//import SwiftUI
//
//struct LoginView: View {
//    @EnvironmentObject var authModel: AuthModel
//    @Binding var isShowingSignUp: Bool
//    @State private var email = ""
//    @State private var password = ""
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Iniciar sesión")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//            
//            VStack(spacing: 15) {
//                TextField("Email", text: $email)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .textInputAutocapitalization(.never)
//                    .autocorrectionDisabled(true)
//                    .keyboardType(.emailAddress)
//                
//                SecureField("Password", text: $password)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .textInputAutocapitalization(.never)
//            }
//            .padding(.horizontal)
//            
//            Button(action: {
//                Task {
//                    await authModel.login(email: email, password: password)
//                }
//            }) {
//                Text("Sign In")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
//            .padding(.horizontal)
//            .disabled(email.isEmpty || password.isEmpty)
//            
//            Button(action: {
//                isShowingSignUp = true
//            }) {
//                Text("¿No tienes una cuenta? Regístrate")
//                    .foregroundColor(.blue)
//                    .underline()
//            }
//            .padding(.top, 10)
//            
//            Text("OR")
//                .fontWeight(.bold)
//                .foregroundColor(.gray)
//                .padding()
//            
//            Button(action: {
//                Task {
//                    await authModel.signInWithGoogle()
//                }
//            }) {
//                HStack {
//                    Image(systemName: "g.circle.fill")
//                        .foregroundColor(.black)
//                    Text("Continuar con Google")
//                }
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.white)
//                .foregroundColor(.black)
//                .cornerRadius(8)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.gray, lineWidth: 1)
//                )
//            }
//            .padding(.horizontal)
//            
//            if case .error(let errorMessage) = authModel.authState {
//                Text(errorMessage)
//                    .foregroundColor(.red)
//                    .multilineTextAlignment(.center)
//                    .padding()
//            }
//        }
//        .padding()
//        .disabled(authModel.isLoading)
//        .overlay(
//            Group {
//                if authModel.isLoading {
//                    ProgressView()
//                        .scaleEffect(1.5)
//                        .padding()
//                        .background(Color.white.opacity(0.8))
//                        .cornerRadius(10)
//                }
//            }
//        )
//    }
//}
//
//#Preview {
//    LoginView(isShowingSignUp: .constant(false))
//        .environmentObject(AuthModel())
//}
