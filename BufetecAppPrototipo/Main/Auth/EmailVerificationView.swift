import SwiftUI
import FirebaseAuth

struct EmailVerificationView: View {
    @EnvironmentObject var authModel: AuthModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Verify Your Email")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("We've sent a verification email to \(authModel.userData.email). Please check your inbox and click the verification link.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                Task {
                    await authModel.refreshEmailVerificationStatus()
                }
            }) {
                Text("I've Verified My Email")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Button(action: {
                Task {
                    await authModel.resendVerificationEmail()
                }
            }) {
                Text("Resend Verification Email")
                    .foregroundColor(.blue)
                    .underline()
            }
            
            if case .error(let errorMessage) = authModel.authState {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .padding()
    }
}

#Preview {
    EmailVerificationView()
        .environmentObject(AuthModel())
}
