//
//  DocumentValidationView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/4/24.
//

import SwiftUI

struct DocumentValidationView: View {
    let logoImageName = "BT-icon"

    var body: some View {
        ZStack {
            // Background color changes depending on dark mode
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Back button and logo
                HStack {
                    Button(action: {
                        // Action for back button
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
                Text("AYUDANOS A VALIDAR TU IDENTIDAD")
                    .font(.title)
                    .fontWeight(.heavy)
                    .font(.system(size: 32))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("btBlue"))
                    .padding(.horizontal)
                    .padding(.top, 25)

                // Subtitle (Placeholder text as per the image)
                Text("It is a long established fact that a reader will be distracted.")
                    .font(.body)
                    .fontWeight(.semibold)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("btBlue"))
                    .padding(.top, 18)
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                    .frame(maxWidth: 300)

                Spacer()
                
                Text("Tipo de Documento")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .font(.system(size: 16))
                    .foregroundColor(Color("btBlue"))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 24)

                // Document type selection (INE and Licencia de Conducir)
                HStack(spacing: 16) {
                    Button(action: {
                        // Action for INE button
                    }) {
                        Text("INE")
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                            .frame(width: 155, height: 43)
                            .background(Color("btBlue"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        // Action for Licencia de Conducir button
                    }) {
                        Text("Licencia de Conducir")
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                            .frame(width: 170, height: 43)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("btBlue"), lineWidth: 2)
                            )
                            .foregroundColor(Color("btBlue"))
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Example image and Scan button
                Image("INE-example") // Use a placeholder or actual image in assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 375,height: 230)
                    .padding()

                Button(action: {
                    // Action for scanning
                }) {
                    HStack {
                        Image(systemName: "camera.fill")
                        Text("Escanear")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                    }
                    .padding()
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

struct IdentityVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DocumentValidationView()
                .preferredColorScheme(.light) // Light mode preview
            DocumentValidationView()
                .preferredColorScheme(.dark)  // Dark mode preview
        }
    }
}


#Preview {
    DocumentValidationView()
}
