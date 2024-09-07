import SwiftUI

@main
struct BufetecApp: App {
    @State var appearanceManager = AppearanceManager()
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                LoginView()
                    .environment(appearanceManager)
                    .onAppear {
                        appearanceManager.initAppearanceStyle()
                    }
            } else {
                OnboardingView()
            }
        }
    }
}
