import SwiftUI

enum Appearance: LocalizedStringKey, CaseIterable, Identifiable {
    case Light
    case Dark
    case System
    
    var id: String { UUID().uuidString }
}
