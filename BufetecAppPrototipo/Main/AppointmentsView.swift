import SwiftUI

struct AppointmentsView: View {
    var body: some View {
        Text("Citas")
    }
}

#Preview {
    AppointmentsView()
        .environmentObject(AppearanceManager())
}
