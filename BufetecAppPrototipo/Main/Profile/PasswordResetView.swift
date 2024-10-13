import SwiftUI

struct PasswordResetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authModel: AuthModel
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color("btBackground")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "lock.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.accentColor)
                        .padding(.top, 40)
                    
                    Text("Restablecer Contraseña")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Se enviará un enlace de restablecimiento de contraseña a su correo electrónico registrado.")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text(authModel.userData.email)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    
                    Button(action: sendResetEmail) {
                        HStack {
//                            if isLoading {
//                                ProgressView()
//                                    .progressViewStyle(CircularProgressViewStyle(tint: colorScheme == .light ? Color.white : Color.black))
//                            } else {
                                Text("Enviar Enlace de Restablecimiento")
//                            }
                        }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                        .background(colorScheme == .light ? Color.black : Color.white)
                        .cornerRadius(16)
                    }
                    .disabled(isLoading)
                }
                .padding()
            }
        }
        .navigationTitle("Restablecer Contraseña")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK"))
//                  {
//                if alertTitle == "Éxito" {
//                    dismiss()
//                }
//            }
            )
        }
    }
    
    private func sendResetEmail() {
        isLoading = true
        Task {
            do {
                try await authModel.sendPasswordResetEmail(to: authModel.userData.email)
                await MainActor.run {
                    alertTitle = "Éxito"
                    alertMessage = "Se ha enviado un correo electrónico de restablecimiento de contraseña a su dirección. Por favor, revise su bandeja de entrada y siga las instrucciones para restablecer su contraseña."
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
    NavigationView {
        PasswordResetView()
            .environmentObject(AuthModel())
    }
}
