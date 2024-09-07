//
//  OnboardingChatBotView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/5/24.
//

import SwiftUI

struct OnboardingChatBotView: View {
    var onContinue: () -> Void // Closure que se ejecuta cuando el usuario hace clic en "Continuar"
    var body: some View {
        ZStack {
            // Color de fondo azul
            Color("btBlue")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                // Título principal
                Text("Aclara tu proceso con Bufetec")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(.white)
                    .frame(width: 410, height: 31)
                    .padding()

                // Subtítulo
                Text("Accede a nuestro chat de asesoría legal para resolver dudas sobre procesos")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 8)

                Spacer()

                // Imagen del Chatbot
                Image("Onboarding-ChatBot")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .padding(.bottom, 40)
                
                Spacer()

                // Botón Continuar
                Button(action: onContinue) {
                    ZStack {
                        Text("Continuar")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                            .foregroundColor(Color("btBlue"))
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.right")
                                .font(.system(size: 18))
                                .foregroundStyle(Color("btBlue"))
                        }
                        .padding(.trailing, 16)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(width: 330, height: 55)
                    .background(Color.white)
                    .foregroundColor(Color("btBlue"))
                    .cornerRadius(15)
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 40)
            }
        }
    }
}
