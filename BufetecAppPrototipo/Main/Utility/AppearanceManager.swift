import SwiftUI
import ObservableUserDefault

@Observable class AppearanceManager {
    
    @ObservableUserDefault(.init(key: "userInterfaceStyle", store: .standard))
    @ObservationIgnored
    var userInterfaceStyle: Int?
    
    
    var selectedAppearance: Appearance = .system
    
    func initAppearanceStyle() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                switch userInterfaceStyle {
                case 0:
                    window.overrideUserInterfaceStyle = .unspecified
                case 1:
                    window.overrideUserInterfaceStyle = .light
                case 2:
                    window.overrideUserInterfaceStyle = .dark
                default:
                    window.overrideUserInterfaceStyle = .unspecified
                }
            }
        }
    }
    
    func applyAppearanceStyle(_ selectedAppearance: Appearance) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                switch selectedAppearance {
                case .system:
                    userInterfaceStyle = 0
                    window.overrideUserInterfaceStyle = .unspecified
                case .light:
                    userInterfaceStyle = 1
                    window.overrideUserInterfaceStyle = .light
                case .dark:
                    userInterfaceStyle = 2
                    window.overrideUserInterfaceStyle = .dark
                }
            }
        }
    }
    
    func setInitialSelectedAppearance() {
        switch userInterfaceStyle {
        case 0:
            selectedAppearance = .system
        case 1:
            selectedAppearance = .light
        case 2:
            selectedAppearance = .dark
        default:
            selectedAppearance = .system
        }
    }
}
