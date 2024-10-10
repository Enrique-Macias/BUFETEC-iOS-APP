import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @AppStorage(AppTheme.UD_KEY_APP_THEME) private var appTheme = AppTheme.system
    
    var body: some View {
        Form {
            Section(header: Text("Apariencia")) {
                ForEach(AppTheme.allCases) { theme in
                    ThemeButton(theme: theme, isSelected: appTheme == theme) {
                        appTheme = theme
                    }
                }
                
                Text("Tema actual: \(currentThemeText)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            Section(header: Text("Información")) {
                NavigationLink(destination: Text("Acerca de la app")) {
                    Label("Acerca de la app", systemImage: "info.circle")
                }
            }
        }
        .navigationTitle("Configuración")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("btBackground"))
    }
    
    private var currentThemeText: String {
        switch appTheme {
        case .light:
            return "Claro"
        case .dark:
            return "Oscuro"
        case .system:
            return colorScheme == .dark ? "Sistema (Oscuro)" : "Sistema (Claro)"
        }
    }
}

struct ThemeButton: View {
    let theme: AppTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: theme.icon)
                    .foregroundColor(isSelected ? .accentColor : .primary)
                
                Text(theme.displayName)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}
