import SwiftUI

class AppearanceManager: ObservableObject {
    @AppStorage("userInterfaceStyle") var userInterfaceStyle: Int?
    
    @Published var selectedAppearance: Appearance = .System
    
    func initAppearanceStyle() {
        
        // Deprecated in iOS 15.0
        // UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified;
        
        // Method 1
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
        
        //        let scenes = UIApplication.shared.connectedScenes
        //        let windowScene = scenes.first as? UIWindowScene
        //
        //        windowScene?.windows.forEach { window in
        //            switch userInterfaceStyle {
        //                case 0:
        //                    window.overrideUserInterfaceStyle = .unspecified
        //                case 1:
        //                    window.overrideUserInterfaceStyle = .light
        //                case 2:
        //                    window.overrideUserInterfaceStyle = .dark
        //                default:
        //                    window.overrideUserInterfaceStyle = .unspecified
        //            }
        //        }
        
        // Method 2
        //        var appliedStyle: UIUserInterfaceStyle = .unspecified;
        //
        //        switch userInterfaceStyle {
        //            case 0:
        //                appliedStyle = .unspecified
        //            case 1:
        //                appliedStyle = .light
        //            case 2:
        //                appliedStyle = .dark
        //            default:
        //                appliedStyle = .unspecified
        //        }
        //
        //
        //        UIApplication
        //            .shared
        //            .connectedScenes
        //            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
        //            .first{ $0.isKeyWindow }?.window?.overrideUserInterfaceStyle = appliedStyle
    }
    
    func applyAppearanceStyle(_ selectedAppearance: Appearance) {
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                switch selectedAppearance {
                case .System:
                    userInterfaceStyle = 0
                    window.overrideUserInterfaceStyle = .unspecified
                case .Light:
                    userInterfaceStyle = 1
                    window.overrideUserInterfaceStyle = .light
                case .Dark:
                    userInterfaceStyle = 2
                    window.overrideUserInterfaceStyle = .dark
                }
            }
        }
    }
    
    func setInitialSelectedAppearance() {
        switch userInterfaceStyle {
        case 0:
            selectedAppearance = .System
        case 1:
            selectedAppearance = .Light
        case 2:
            selectedAppearance = .Dark
        default:
            selectedAppearance = .System
        }
    }
}
