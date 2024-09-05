//
//  RegisterView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/5/24.
//

import SwiftUI

struct RegisterView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var day: String = ""
    @State private var month: String = ""
    @State private var year: String = ""
    
    @State private var isDocumentValidationViewPresented = false  // Estado para controlar la navegación

    let logoImageName = "BT-icon" // Your logo asset name

    var body: some View {
        NavigationView {
            ZStack {
                // Background color depending on the system mode
                Color(UIColor.systemBackground)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    // Back button and logo
                    HStack {
                        Button(action: {
                            // Acción para volver atrás
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Iniciar Sesión")
                                    .foregroundColor(Color("btBlue"))
                            }
                        }
                        Spacer()
                        Image(logoImageName)
                            .resizable()
                            .frame(width: 62, height: 29)
                    }
                    .padding()

                    Spacer()

                    // Main title
                    Text("Registro")
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                        .foregroundColor(Color("btBlue"))
                        .padding(.bottom, 22)

                    // Name Field
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(Color("btBlue"))
                        TextField("Donathan Smith", text: $name)
                            .padding()
                            .foregroundColor(Color("btBlue"))
                            .frame(width: 280, height: 20)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("btBlue"), lineWidth: 1.5)
                    )
                    .padding(.horizontal)

                    // Birthdate Fields
                    Text("Fecha de Nacimiento")
                        .foregroundColor(Color("btBlue"))
                        .fontWeight(.light)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(.leading, 28)

                    HStack(spacing: 16) {
                        TextField("Día", text: $day)
                            .padding()
                            .frame(height: 43)
                            .background(Color.clear)
                            .frame(width: 100, height: 43)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("btBlue"), lineWidth: 1.5)
                            )

                        TextField("Mes", text: $month)
                            .padding()
                            .frame(height: 43)
                            .background(Color.clear)
                            .frame(width: 100, height: 43)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("btBlue"), lineWidth: 1.5)
                            )

                        TextField("Año", text: $year)
                            .padding()
                            .frame(height: 43)
                            .background(Color.clear)
                            .frame(width: 100, height: 43)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("btBlue"), lineWidth: 1.5)
                            )
                    }
                    .padding(.horizontal)

                    // Email Field
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(Color("btBlue"))
                        TextField("donathansmth@gmail.com", text: $email)
                            .keyboardType(.emailAddress)
                            .padding()
                            .foregroundColor(.primary)
                            .frame(width: 280, height: 20)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("btBlue"), lineWidth: 1.5)
                    )
                    .padding(.horizontal)

                    // Phone Field
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(Color("btBlue"))
                        TextField("Teléfono", text: $phone)
                            .keyboardType(.phonePad)
                            .padding()
                            .foregroundColor(.primary)
                            .frame(width: 280, height: 20)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("btBlue"), lineWidth: 1.5)
                    )
                    .padding(.horizontal)

                    // Password Field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(Color("btBlue"))
                        SecureField("Contraseña", text: $password)
                            .padding()
                            .foregroundColor(.primary)
                            .frame(width: 280, height: 20)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("btBlue"), lineWidth: 1.5)
                    )
                    .padding(.horizontal)

                    // Confirm Password Field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(Color("btBlue"))
                        SecureField("Confirmar contraseña", text: $confirmPassword)
                            .padding()
                            .foregroundColor(.primary)
                            .frame(width: 280, height: 20)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("btBlue"), lineWidth: 1.5)
                    )
                    .padding(.horizontal)

                    Spacer()

                    // Register Button with NavigationLink to DocumentValidationView
                    NavigationLink(destination: DocumentValidationView(), isActive: $isDocumentValidationViewPresented) {
                        EmptyView()
                    }

                    Button(action: {
                        // Simulate registration logic here
                        // If registration is successful, navigate to DocumentValidationView
                        isDocumentValidationViewPresented = true
                    }) {
                        Text("Registrarse")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                            .frame(maxWidth: 340, maxHeight: 55)
                            .background(Color("btBlue"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RegisterView()
                .preferredColorScheme(.light)
            RegisterView()
                .preferredColorScheme(.dark)
        }
    }
}


#Preview {
    RegisterView()
}
