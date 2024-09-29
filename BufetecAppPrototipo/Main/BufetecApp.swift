import SwiftUI

@main
struct BufetecApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authModel = AuthModel()
    @State var appearanceManager = AppearanceManager()
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authModel)
                .environment(appearanceManager)
                .onAppear {
                    appearanceManager.initAppearanceStyle()
                }
        }
    }
}

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    var body: some View {
        if hasSeenOnboarding {
            AuthenticationView()
        } else {
            WelcomeScreenView()
        }
    }
}
