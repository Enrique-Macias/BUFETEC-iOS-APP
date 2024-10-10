import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case light = "Claro"
    case dark = "Oscuro"
    case system = "Sistema"
    
    var id: Self { self }
    
    var icon: String {
        switch self {
        case .light: return "sun.max.fill"
        case .dark: return "moon.stars.fill"
        case .system: return "iphone"
        }
    }
    
    var displayName: String {
        self.rawValue
    }
    
    var shortName: String {
        switch self {
        case .light: return "Claro"
        case .dark: return "Oscuro"
        case .system: return "Auto"
        }
    }
    
    func getScheme() -> ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
    
    static let UD_KEY_APP_THEME = "appTheme"
}
