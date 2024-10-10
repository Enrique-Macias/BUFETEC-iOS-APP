import SwiftUI

@main
struct BufetecApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authModel = AuthModel()
    @StateObject private var appState = AppState()
    @StateObject private var appointmentViewModel = AppointmentViewModel()
    @AppStorage(AppTheme.UD_KEY_APP_THEME) private var appTheme = AppTheme.system
    @Environment(\.colorScheme) private var deviceColorScheme
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authModel)
                .environmentObject(appState)
                .environmentObject(appointmentViewModel)
                .preferredColorScheme(appTheme.getScheme())
        }
    }
}

class AppState: ObservableObject {
    @Published var isShowingSplash = true
    @Published var logoPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 50)
}
