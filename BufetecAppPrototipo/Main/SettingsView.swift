import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            AppearanceSelectionPicker()
                .navigationBarTitle(Text("Settings"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    dismiss()
                }) {
                    Text("Done").bold()
                })
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppearanceManager())
}
