//
//  DocumentValidationView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/4/24.
//

import SwiftUI

struct DocumentValidationView: View {
    @State private var isScanning = false
    @State private var selectedDocumentType: DocumentType = .ine
    
    let logoImageName = "BT-icon"
    
    enum DocumentType {
        case ine, licencia
    }

    var body: some View {
        ZStack {
            // Background color changes depending on dark mode
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Logo aligned to the right
                HStack {
                    Spacer()
                    Image(logoImageName)
                        .resizable()
                        .frame(width: 62, height: 29)
                }
                .padding() // Adjust the spacing between the logo and the edge of the screen

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

                // Subtitle
                Text("Nuestra prioridad es mantener seguros los datos de nuestros clientes, por lo que necesitamos validar tu identidad con una identificación oficial.")
                    .font(.body)
                    .fontWeight(.semibold)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("btBlue"))
                    .padding(.top, 18)
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                    .frame(maxWidth: 350)

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
                        selectedDocumentType = .ine
                    }) {
                        Text("INE")
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                            .frame(width: 155, height: 43)
                            .background(selectedDocumentType == .ine ? Color("btBlue") : Color.clear)
                            .foregroundColor(selectedDocumentType == .ine ? .white : Color("btBlue"))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("btBlue"), lineWidth: 2)
                                    .opacity(selectedDocumentType == .ine ? 0 : 1)
                            )
                    }

                    Button(action: {
                        // Action for Licencia de Conducir button
                        selectedDocumentType = .licencia
                    }) {
                        Text("Licencia de Conducir")
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                            .frame(width: 170, height: 43)
                            .background(selectedDocumentType == .licencia ? Color("btBlue") : Color.clear)
                            .foregroundColor(selectedDocumentType == .licencia ? .white : Color("btBlue"))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("btBlue"), lineWidth: 2)
                                    .opacity(selectedDocumentType == .licencia ? 0 : 1)
                            )
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Example image and Scan button
                Image("INE-example") // Use a placeholder or actual image in assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 375, height: 230)
                    .padding()

                Button(action: {
                    // Action for scanning
                    isScanning = true
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
                .sheet(isPresented: $isScanning) {
                    DocumentScanView()
                }
                .padding(.horizontal)

                Spacer()
            }
        }
    }
}

struct DocumentValidationView_Previews: PreviewProvider {
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
