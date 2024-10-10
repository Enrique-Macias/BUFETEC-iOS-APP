import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case light = "Claro"
    case dark = "Oscuro"
    case system = "Sistema"
    
    var id: Self { self }
}

class AppState: ObservableObject {
    @Published var isShowingSplash = true
    @Published var logoPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 50)
}

@main
struct BufetecApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authModel = AuthModel()
    @StateObject private var appState = AppState()
    @StateObject private var appointmentViewModel = AppointmentViewModel()
    @AppStorage("appTheme") private var appTheme = AppTheme.system
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authModel)
                .environmentObject(appState)
                .environmentObject(appointmentViewModel)
                .preferredColorScheme(colorScheme)
        }
    }
    
    private var colorScheme: ColorScheme? {
        switch appTheme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
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
}
