import SwiftUI

struct AuthenticationView: View {
    @Environment(AppearanceManager.self) var appearanceManager: AppearanceManager
    @EnvironmentObject var authModel: AuthModel
    @EnvironmentObject var appState: AppState
    @State private var isShowingSignUp = false
    
    var body: some View {
        ZStack {
            VStack {
                switch authModel.authState {
                case .signedOut, .signingIn:
                    if isShowingSignUp {
                        SignUpView(isShowingSignUp: $isShowingSignUp)
                    } else {
                        LoginView(isShowingSignUp: $isShowingSignUp)
                    }
                case .needsAdditionalInfo:
                    AdditionalInfoView()
                case .authenticating:
                    ProgressView("Completando perfil...")
                case .authenticated:
                    CustomTabView()
                case .needsEmailVerification:
                    EmailVerificationView()
                }
            }
            .disabled(authModel.isLoading)
            
            if authModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
            }
        }
        .onAppear {
            authModel.checkUserSession()
        }
    }
}
