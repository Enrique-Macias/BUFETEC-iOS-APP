//
//  LoginView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/2/24.
//

import SwiftUI

struct LoginView: View {
    @State var username     = ""
    @State var password     = ""
    @State var showPassword = false
    @State var showLogin = false
    @State private var navigateToContentView = false
    
    var body: some View {
        ZStack {
            
            // Login View
            NavigationStack {
                VStack {
                    VStack {
                        Image("LogoBufetec")
                            .resizable()
                            .aspectRatio(contentMode: .fit) // Mantén el aspecto original del logo
                            .frame(width: screen.width * 0.5, height: screen.width * 0.5)
                            .padding(.all, 20) // Agrega un padding alrededor del logo dentro del frame
                            .background(Color.clear) // Asegura que no haya un fondo no deseado
                            .foregroundColor(.white)
                            .padding(.top, showLogin ? 100 : screen.height / 3)
                    }
                    
                    .edgesIgnoringSafeArea(.all)
                    .background(Color.clear)

                    
                    // User Textfield
                    ZStack {
                        TextField("Username", text: $username)
                    }
                    .frame(width: screen.width * 0.8, height: 44)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white, lineWidth: 0.3)
                    )
                    .background(Color(.white).cornerRadius(16))
                    
                    
                    
                    // Password Textfield
                    ZStack {
                        HStack {
                            if showPassword {
                                TextField("Password", text: $password)
                            } else {
                                SecureField("Password", text: $password)
                            }
                            Spacer()
                            
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                            }
                            .padding(.trailing, 6)
                        }
                        
                    }
                    .frame(width: screen.width * 0.8, height: 44)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white, lineWidth: 0.3)
                    )
                    .background(Color(.white).cornerRadius(16))
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    // No tienes una cuenta? y crear cuenta
                    HStack {
                        Text("No tienes una cuenta?")
                            .font(.system(size: 18, weight: .light))
                            .foregroundColor(Color.white.opacity(0.5))
                        
                        Button(action: {}) {
                            Text("Registrate")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    // Login Btn
                    Button(action: {
                        self.navigateToContentView = true
                    }) {
                        ZStack {
                            Text("Iniciar Sesión")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .frame(width: screen.width * 0.8, height: 60)
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.bottom, 40)
                    }
                    .background(
                        NavigationLink(destination: ContentView(), isActive: $navigateToContentView) {
                            EmptyView()
                        }
                            .hidden()
                    )
                }
                .frame(width: screen.width, height: screen.height)
                .edgesIgnoringSafeArea(.all)
                .background(Color("launchBackground"))
            }
            
            if !showLogin {
                ZStack{
                    Color("launchBackground")
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Image("LogoBufetec")
                            .resizable()
                            .aspectRatio(contentMode: .fit) // Mantén el aspecto original del logo
                            .frame(width: screen.width * 0.5, height: screen.width * 0.5)
                            .padding(.all, 20) // Agrega un padding alrededor del logo dentro del frame
                            .background(Color.clear) // Asegura que no haya un fondo no deseado
                            .foregroundColor(.white)
                            .padding(.top, showLogin ? 100 : screen.height / 3)
                            .padding(.bottom, 20) // Agrega un padding inferior si el logo está muy cerca del fondo
                        
                        Spacer()
                    }
                    .frame(width: screen.width, height: screen.height)
                    .edgesIgnoringSafeArea(.all)
                    .background(Color.clear)
                }
            }
        }
        .frame(width: screen.width, height: screen.height)
        .edgesIgnoringSafeArea(.all)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Mostrar login view despues de 2 segundos
                withAnimation(.spring()) {
                    showLogin = true
                }
            }
        }
    }
}

#Preview {
    LoginView()
}

let screen = UIScreen.main.bounds
