//
//  WelcomeScreenView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/5/24.
//

import SwiftUI

struct WelcomeScreenView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let logoImageName = "LogoBufetec"

    var body: some View {
        ZStack {
            // Fondo para soportar el modo claro/oscuro
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                // Título principal con diferentes pesos usando AttributedString
                Text(attributedMainTitle)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Spacer()
                
                // Subtítulo
                Text("It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout")
                    .font(.system(size: 16))
                    .foregroundColor(Color("btBlue"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)

                // Botón Comenzar
                Button(action: {
                    // Acción al presionar el botón
                }) {
                    Text("Comenzar")
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity)
                        .frame(width: 250 ,height: 50)
                        .background(Color("btBlue"))
                        .foregroundColor(.white)
                        .cornerRadius(32)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 60)

                Spacer()
                
                // Logo y texto al pie de la vista
                VStack {
                    Image(logoImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 30)
                        .foregroundColor(Color(colorScheme == .light ? Color("btBlue") : .white))
                }
                .padding(.bottom, 40)
            }
        }
    }
    
    // Método que genera el texto con estilos usando AttributedString
    var attributedMainTitle: AttributedString {
        var attributedString = AttributedString("APOYO LEGAL\nSIN COSTO,\nJUSTICIA PARA\nTODOS")
        
        // Estilo general para todo el texto
        attributedString.font = .system(size: 32, weight: .bold)
        attributedString.foregroundColor = Color("btBlue")
        
        // Estilo para "SIN COSTO"
        if let range = attributedString.range(of: "SIN COSTO") {
            attributedString[range].font = .system(size: 32, weight: .black)
        }
        
        // Estilo para "TODOS"
        if let range = attributedString.range(of: "TODOS") {
            attributedString[range].font = .system(size: 32, weight: .black)
        }
        
        return attributedString
    }
}

struct WelcomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WelcomeScreenView()
                .preferredColorScheme(.light) // Modo claro
            WelcomeScreenView()
                .preferredColorScheme(.dark)  // Modo oscuro
        }
    }
}

#Preview {
    WelcomeScreenView()
}
