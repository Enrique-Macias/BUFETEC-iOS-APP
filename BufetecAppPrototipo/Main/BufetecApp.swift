import SwiftUI

class AppState: ObservableObject {
    @Published var isShowingSplash = true
    @Published var logoPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 50)
}

@main
struct BufetecApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authModel = AuthModel()
    @StateObject private var appState = AppState()
    @State var appearanceManager = AppearanceManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authModel)
                .environmentObject(appState)
                .environment(appearanceManager)
                .onAppear {
                    appearanceManager.initAppearanceStyle()
                }
        }
    }
}

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
        .environment(AppearanceManager())
}
