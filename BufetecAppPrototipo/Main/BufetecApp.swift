import SwiftUI

class SplashScreenState: ObservableObject {
    @Published var isFinished = false
    @Published var logoPosition: CGPoint = .zero
}

@main
struct BufetecApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authModel = AuthModel()
    @StateObject private var splashScreenState = SplashScreenState()
    @State var appearanceManager = AppearanceManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authModel)
                .environmentObject(splashScreenState)
                .environment(appearanceManager)
                .onAppear {
                    appearanceManager.initAppearanceStyle()
                }
        }
    }
}

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @EnvironmentObject var splashScreenState: SplashScreenState
    
    var body: some View {
        ZStack {
            Group {
                if hasSeenOnboarding {
                    AuthenticationView()
                } else {
                    OnboardingView()
                }
            }
            
            if !splashScreenState.isFinished && hasSeenOnboarding {
                SplashScreenView()
                    .transition(.opacity)
            }
        }
        .animation(.easeIn(duration: 0.3), value: splashScreenState.isFinished)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthModel())
        .environmentObject(SplashScreenState())
        .environment(AppearanceManager())
}
