import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("Modo de interfaz")) {
                AppearanceSelectionPicker()
            }
            .headerProminence(.increased)
        }
        .navigationBarTitle(Text("Opciones"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            dismiss()
        }) {
            Text("Done").bold()
        })
    }
}

#Preview {
    SettingsView()
        .environment(AppearanceManager())
}
