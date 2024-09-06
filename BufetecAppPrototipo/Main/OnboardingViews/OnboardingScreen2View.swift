//
//  OnboardingScreen2View.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/6/24.
//

import SwiftUI

import SwiftUI

struct OnboardingScreen2View: View {
    var body: some View {
        VStack {
            Spacer()

            // Título
            Text("AGENDA CITAS\nCON ABOGADOS")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color("btBlue"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.top, 50)

            Spacer()

            // Imagen del centro
            Image("onboarding-2")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .foregroundStyle(Color("btBlue"))
                .padding(.bottom, 30)

            Spacer()

            // Texto descriptivo debajo de la imagen
            Text("It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout")
                .font(.system(size: 16))
                .foregroundColor(Color("btBlue"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)

            // Indicador de página
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 10, height: 10)

                Circle()
                    .fill(Color("btBlue"))
                    .frame(width: 10, height: 10)

                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 10, height: 10)
            }
            .padding(.bottom, 40)

            // Logo de Bufetec en la parte inferior
            Image("LogoBufetec") // Coloca el nombre de tu logo
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color("btBlue"))
                .frame(width: 135, height: 35)
                .padding(.bottom, 30)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct OnboardingScreen2View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingScreen2View()
                .preferredColorScheme(.light)
            OnboardingScreen2View()
                .preferredColorScheme(.dark)
        }
    }
}


#Preview {
    OnboardingScreen2View()
}
