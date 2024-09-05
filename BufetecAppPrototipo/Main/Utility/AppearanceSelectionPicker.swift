import SwiftUI

struct AppearanceSelectionPicker: View {
    @Environment(AppearanceManager.self) var appearanceManager: AppearanceManager
    
    var body: some View {
        List {
            ForEach(Appearance.allCases, id: \.self) { appearance in
                Button(action: {
                    appearanceManager.selectedAppearance = appearance
                }) {
                    HStack {
                        Text(appearance.rawValue)
                        Spacer()
                        if appearance == appearanceManager.selectedAppearance {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .foregroundColor(.primary)
            }
        }
        .onChange(of: appearanceManager.selectedAppearance) {
            appearanceManager.applyAppearanceStyle(appearanceManager.selectedAppearance)
        }
        .onAppear {
            appearanceManager.setInitialSelectedAppearance()
        }
    }
}

