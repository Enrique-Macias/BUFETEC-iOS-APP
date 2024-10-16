//
//  OnboardingScreen1View.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/6/24.
//

import SwiftUI

struct OnboardingScreen1View: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack {

                Spacer()
                // Título
                Text("ACCEDE A\nRECURSOS LEGALES")
                    .font(CustomFonts.PoppinsExtraBold(size: 36))
                    .kerning(-2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(colorScheme == .light ? Color.accentColor : .white))
                    .padding(.horizontal, 20)
                    .padding(.top, 40)

                Spacer()

                // Imagen del centro
                Image("onboarding-1")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .foregroundStyle(Color(colorScheme == .light ? Color.accentColor : .white))
                    .padding(.bottom, 20)

                Spacer()

                // Texto descriptivo debajo de la imagen
                Text("Con Bufetec, encuentra información confiable para guiarte en tus procedimientos legales.")
                    .font(CustomFonts.MontserratRegular(size: 16))
                    .foregroundColor(Color(colorScheme == .light ? Color.accentColor : .white))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                
                Spacer()

//                // Indicador de página
//                HStack(spacing: 8) {
//                    Circle()
//                        .fill(Color(colorScheme == .light ? Color.accentColor : .white))
//                        .frame(width: 10, height: 10)
//
//                    Circle()
//                        .fill(Color.gray.opacity(0.5))
//                        .frame(width: 10, height: 10)
//
//                    Circle()
//                        .fill(Color.gray.opacity(0.5))
//                        .frame(width: 10, height: 10)
//                    
//                    Circle()
//                        .fill(Color.gray.opacity(0.5))
//                        .frame(width: 10, height: 10)
//                }
//                .padding(.bottom, 60)

                // Logo de Bufetec en la parte inferior
//                Image("LogoBufetec") // Coloca el nombre de tu logo
//                    .resizable()
//                    .scaledToFit()
//                    .foregroundStyle(Color(colorScheme == .light ? Color.accentColor : .white))
//                    .frame(width: 135, height: 35)
//                    .padding(.bottom, 30)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    OnboardingScreen1View()
}
