import SwiftUI
import FirebaseAuth

struct EmailVerificationView: View {
    @Environment(AppearanceManager.self) var appearanceManager: AppearanceManager
    @EnvironmentObject var authModel: AuthModel
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Verify Your Email")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("We've sent a verification email to \(authModel.userData.email). Please check your inbox and click the verification link.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: refreshEmailVerificationStatus) {
                Text("I've Verified My Email")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Button(action: resendVerificationEmail) {
                Text("Resend Verification Email")
                    .foregroundColor(.blue)
                    .underline()
            }
            
            Button(action: signOut) {
                Text("Cerrar Sesión")
                    .foregroundColor(.blue)
                    .underline()
            }

        }
        .padding()
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
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
    
    private func refreshEmailVerificationStatus() {
        Task {
            do {
                try await authModel.refreshEmailVerificationStatus()
                // If successful, the AuthModel will update its state
                // and the app should navigate to the appropriate view
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to refresh status: \(error.localizedDescription)"
                    showErrorAlert = true
                }
            }
        }
    }
    
    private func resendVerificationEmail() {
        Task {
            do {
                try await authModel.resendVerificationEmail()
                await MainActor.run {
                    errorMessage = "Verification email sent successfully."
                    showErrorAlert = true
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to resend email: \(error.localizedDescription)"
                    showErrorAlert = true
                }
            }
        }
    }
    
    private func signOut() {
        Task {
            do {
                try await authModel.logout()
            } catch {
                errorMessage = "Failed to sign out: \(error.localizedDescription)"
                showErrorAlert = true
            }
        }
    }

}

#Preview {
    EmailVerificationView()
        .environment(AppearanceManager())
        .environmentObject(AuthModel())
}
