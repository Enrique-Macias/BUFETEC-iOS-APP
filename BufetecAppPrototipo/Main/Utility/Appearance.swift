import SwiftUI

enum Appearance: String, CaseIterable, Identifiable {
    case light = "Claro"
    case dark = "Oscuro"
    case system = "Sistema"
    
    var id: String { UUID().uuidString }
    
    var localizedName: LocalizedStringKey {
        LocalizedStringKey(rawValue)
    }
}
