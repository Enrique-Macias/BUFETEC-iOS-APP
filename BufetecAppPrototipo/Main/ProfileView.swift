//
//  ProfileView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/11/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // Imagen de usuario y nombre
                VStack(spacing: 10) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color("btBlue"))
                    
                    Text("Bruno García")
                        .font(CustomFonts.PoppinsBold(size: 16))
                        .foregroundColor(Color("btBlue"))
                    
                    Button(action: {
                        // Acción para editar el perfil
                    }) {
                        Text("Editar Perfil")
                            .font(CustomFonts.PoppinsSemiBold(size: 14))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 40)
                            .background(Color("btBlue"))
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                }
                
                Spacer()
                
                // Lista de opciones
                VStack(spacing: 20) {
                    Divider()
                        .background(Color("btBlue"))
                    
                    ProfileOption(iconName: "gearshape.fill", title: "Configuración", showChevron: true) {
                        // Navegar a la vista de Configuración
                    }
                    
                    ProfileOption(iconName: "doc.text.fill", title: "Mis casos", showChevron: true) {
                        // Navegar a la vista de Mis Casos
                    }
                    
                    ProfileOption(iconName: "lock.fill", title: "Cambiar Contraseña", showChevron: true) {
                        // Navegar a la vista de Cambiar Contraseña
                    }
                    
                    Divider()
                        .background(Color("btBlue"))
                    
                    ProfileOption(iconName: "questionmark.circle.fill", title: "Ayuda y soporte", showChevron: false) {
                        // Navegar a la vista de Ayuda y Soporte
                    }
                    
                    ProfileOption(iconName: "arrowshape.turn.up.left.fill", title: "Cerrar Sesión", showChevron: false) {
                        // Acción para cerrar sesión
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline) // Esto mantiene el título centrado
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Mi Perfil")
                        .font(CustomFonts.PoppinsBold(size: 20))
                        .foregroundColor(Color("btBlue"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("btIcon") // Asegúrate de tener tu imagen de icono
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundStyle(Color("btBlue"))
                        .frame(width: 27, height: 27)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
}

// Componente para opciones del perfil
struct ProfileOption: View {
    let iconName: String
    let title: String
    let showChevron: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(Color("btBlue"))
                    .frame(width: 30)
                
                Text(title)
                    .font(CustomFonts.PoppinsMedium(size: 16))
                    .foregroundColor(Color("btBlue"))
                
                Spacer()
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemGray6))  // Fondo claro
            .cornerRadius(15)  // Borde redondeado
        }
    }
}

#Preview {
    ProfileView()
        .environment(AppearanceManager())
}
