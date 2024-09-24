//
//  WelcomeScreenView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/5/24.
//

import SwiftUI

struct WelcomeScreenView: View {
    @State var appearanceManager = AppearanceManager()
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State private var showBufetecApp = false
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
                    .kerning(-2)
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                    

                Spacer()
                
                // Subtítulo
                Text("It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout")
                    .font(CustomFonts.MontserratSemiBold(size: 18))
                    .foregroundColor(Color("btBlue"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 80)
                
                // Botón Comenzar
                Button(action: {
                    // Acción al presionar el botón
                    hasSeenOnboarding = true
                    showBufetecApp = true
                }) {
                    Text("Comenzar")
                        .font(CustomFonts.PoppinsSemiBold(size: 19))
                        .frame(maxWidth: .infinity)
                        .frame(width: 250 ,height: 50)
                        .background(Color("btBlue"))
                        .foregroundColor(.white)
                        .cornerRadius(32)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 60)
                .fullScreenCover(isPresented: $showBufetecApp) {
                    LoginView()
                        .environment(appearanceManager)
                        .onAppear {
                            appearanceManager.initAppearanceStyle()
                        }
                    
                }

                Spacer()
                
                // Indicador de página
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 10, height: 10)

                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 10, height: 10)

                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 10, height: 10)
                    
                    Circle()
                        .fill(Color("btBlue"))
                        .frame(width: 10, height: 10)
                }
                .padding(.bottom, 60)
                
                // Logo y texto al pie de la vista
                VStack {
                    Image(logoImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 30)
                        .foregroundColor(Color(colorScheme == .light ? Color("btBlue") : .white))
                }
                .padding(.bottom, 30)
            }
        }
    }
    
    // Método que genera el texto con estilos usando AttributedString
    var attributedMainTitle: AttributedString {
        var attributedString = AttributedString("APOYO LEGAL\nSIN COSTO,\nJUSTICIA PARA\nTODOS")
        
        // Estilo general para todo el texto
        attributedString.font = CustomFonts.PoppinsMedium(size: 40)
        attributedString.foregroundColor = Color("btBlue")
        
        // Estilo para "SIN COSTO"
        if let range = attributedString.range(of: "SIN COSTO") {
            attributedString[range].font = CustomFonts.PoppinsExtraBold(size: 40)
        }
        
        // Estilo para "TODOS"
        if let range = attributedString.range(of: "TODOS") {
            attributedString[range].font = CustomFonts.PoppinsExtraBold(size: 40)
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
