import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("appTheme") private var appTheme = AppTheme.system
    
    var body: some View {
        Form {
            Section(header: Text("Apariencia")) {
                Picker("Tema de la aplicación", selection: $appTheme) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(theme.rawValue).tag(theme)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
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
}

#Preview {
    NavigationView {
        SettingsView()
    }
}
