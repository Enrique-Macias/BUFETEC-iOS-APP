//
//  OnboardingScreen1View.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/6/24.
//

import SwiftUI

struct OnboardingScreen1View: View {
    var body: some View {
        ZStack {
            VStack {

                Spacer()
                // Título
                Text("ACCEDE A\nRECURSOS LEGALES")
                    .font(CustomFonts.PoppinsExtraBold(size: 36))
                    .kerning(-2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("btBlue"))
                    .padding(.horizontal, 20)
                    .padding(.top, 40)

                Spacer()

                // Imagen del centro
                Image("onboarding-1")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .foregroundStyle(Color("btBlue"))
                    .padding(.bottom, 20)

                Spacer()

                // Texto descriptivo debajo de la imagen
                Text("It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout")
                    .font(CustomFonts.MontserratRegular(size: 16))
                    .foregroundColor(Color("btBlue"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)

                // Indicador de página
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color("btBlue"))
                        .frame(width: 10, height: 10)

                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 10, height: 10)

                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 10, height: 10)
                    
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 10, height: 10)
                }
                .padding(.bottom, 60)

                // Logo de Bufetec en la parte inferior
                Image("LogoBufetec") // Coloca el nombre de tu logo
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color("btBlue"))
                    .frame(width: 135, height: 35)
                    .padding(.bottom, 30)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct OnboardingScreen1View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingScreen1View()
                .preferredColorScheme(.light)
            OnboardingScreen1View()
                .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    OnboardingScreen1View()
}
