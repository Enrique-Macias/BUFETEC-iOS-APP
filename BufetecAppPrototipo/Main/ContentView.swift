import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Group {
                if hasSeenOnboarding {
                    AuthenticationView()
                } else {
                    OnboardingView()
                }
            }
            .opacity(appState.isShowingSplash ? 0 : 1)
            .animation(.easeIn(duration: 0.3), value: appState.isShowingSplash)
            
            if appState.isShowingSplash {
                SplashScreenView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthModel())
        .environmentObject(AppState())
}
