import SwiftUI

@main
struct BufetecApp: App {
    @State var appearanceManager = AppearanceManager()

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(appearanceManager)
                .onAppear {
                    appearanceManager.initAppearanceStyle()
                }
        }
    }
}
