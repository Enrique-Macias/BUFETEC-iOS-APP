import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authModel: AuthModel
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.tintColor]
    }
    
    var body: some View {
        VStack {
            // Imagen de usuario y nombre
            VStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.accentColor)
                    .padding(.top, 10)
                
                Text(authModel.userData.nombre)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.accentColor)
                
                // Botón para editar perfil con NavigationLink
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
            
            Spacer()
            
            // Lista de opciones
            VStack(spacing: 20) {
                Divider()
                    .background(Color.accentColor)
                
                NavigationLink(destination: SettingsView()) {
                    ProfileOption(iconName: "gearshape.fill", title: "Configuración", showChevron: true) {
                        // Navegar a la vista de Configuración
                    }
                }
                
                ProfileOption(iconName: "doc.text.fill", title: "Mis casos", showChevron: true) {
                    // Navegar a la vista de Mis Casos
                }
                
                ProfileOption(iconName: "lock.fill", title: "Cambiar Contraseña", showChevron: true) {
                    // Navegar a la vista de Cambiar Contraseña
                }
                
                Divider()
                    .background(Color.accentColor)
                
                
                ProfileOption(iconName: "questionmark.circle.fill", title: "Ayuda y soporte", showChevron: false) {
                    // Navegar a la vista de Ayuda y Soporte
                }
                
                // Cerrar Sesión button
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
                    .background(Color.white)
                    .cornerRadius(15)
                }
            }
            .padding(.horizontal, 20)
            
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
                // Handle successful logout (e.g., navigate to login view)
            } catch {
                errorMessage = "Failed to sign out: \(error.localizedDescription)"
                showErrorAlert = true
            }
        }
    }
}


// Componente para opciones del perfil
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
        .background(colorScheme == .light ? Color.white : Color.clear)  // Fondo blanco
        .cornerRadius(15)  // Borde redondeado
        //        .shadow(color: Color.black.opacity(0.07), radius: 10, x: 0, y: 5) // Sombra
    }
}

#Preview {
    ProfileView()
        .environment(AppearanceManager())
        .environmentObject(AuthModel())
}
