import SwiftUI

@main 
struct BufetecApp: App {
    
    @StateObject var appearanceManager = AppearanceManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appearanceManager)
                .onAppear {
                    appearanceManager.initAppearanceStyle()
                }
        }
    }
}
