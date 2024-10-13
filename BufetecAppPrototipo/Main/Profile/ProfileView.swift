import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authModel: AuthModel
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.tintColor]
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.accentColor)
                    .padding(.top, 10)
                
                VStack(spacing: 5) {
                    Text(authModel.userData.nombre)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.accentColor)
                    
                    Text(authModel.userData.tipo.capitalized)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.secondary)
                }
                
                NavigationLink(destination: EditProfileView()) {
                    Text("Editar Perfil")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 40)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
            
//            Spacer()
            
            VStack(spacing: 20) {
//                Divider()
//                    .background(Color.accentColor)
                
                NavigationLink(destination: SettingsView()) {
                    ProfileOption(iconName: "gearshape.fill", title: "Configuración", showChevron: true) {
                    }
                }
                
                if (authModel.userData.tipo == "abogado") {
                    ProfileOption(iconName: "calendar.badge.clock", title: "Mi horario", showChevron: true) {
                    }
                }
                
                NavigationLink(destination: PasswordResetView()) {
                    ProfileOption(iconName: "lock.fill", title: "Restablecer Contraseña", showChevron: true) {
                    }
                }
                
                Divider()
                    .background(Color.accentColor)
                
//                ProfileOption(iconName: "questionmark.circle.fill", title: "Ayuda y soporte", showChevron: false) {
//                }
                
                Button(action: signOut) {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.left.fill")
                            .foregroundColor(.accentColor)
                            .frame(width: 30)
                        
                        Text("Cerrar Sesión")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.accentColor)
                        
                        Spacer()
                    }
                    .padding()
                    .padding(.vertical, 5)
                    .background(colorScheme == .light ? Color.white : Color.clear)
                    .cornerRadius(15)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            
            Spacer()
            Spacer()
        }
        .navigationTitle("Mi Perfil")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("btBackground"))
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func signOut() {
        Task {
            do {
                try await authModel.logout()
            } catch {
                errorMessage = "Failed to sign out: \(error.localizedDescription)"
                showErrorAlert = true
            }
        }
    }
}


struct ProfileOption: View {
    @Environment(\.colorScheme) var colorScheme
    let iconName: String
    let title: String
    let showChevron: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.accentColor)
                .frame(width: 30)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.accentColor)
            
            Spacer()
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .padding(.vertical, 5)
        .background(colorScheme == .light ? Color.white : Color.clear)
        .cornerRadius(15)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthModel())
}
