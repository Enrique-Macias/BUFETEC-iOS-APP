import SwiftUI

struct DocumentValidationView: View {
    @Environment(AppearanceManager.self) var appearanceManager: AppearanceManager
    @Environment(\.colorScheme) var colorScheme
    @State private var isScanning = false
    @State private var selectedDocumentType: DocumentType = .ine
    
    enum DocumentType {
        case ine, licencia
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("btBackground")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Main title
                    Text("AYUDANOS A VALIDAR TU IDENTIDAD")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 25)
                    
                    // Subtitle
                    Text("Nuestra prioridad es mantener seguros los datos de nuestros clientes, por lo que necesitamos validar tu identidad con una identificación oficial.")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 18)
                        .padding(.bottom, 30)
                        .frame(maxWidth: 350)
                    
                    Spacer()
                    
                    // Document Type Title
                    Text("Tipo de Documento")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
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
                                .background(selectedDocumentType == .ine ? (colorScheme == .dark ? Color.white : Color.primary) : Color.clear)
                                .foregroundColor(selectedDocumentType == .ine ? (colorScheme == .dark ? .black : .white) : Color.primary)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primary, lineWidth: 2)
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
                                .background(selectedDocumentType == .licencia ? (colorScheme == .dark ? Color.white : Color.primary) : Color.clear)
                                .foregroundColor(selectedDocumentType == .licencia ? (colorScheme == .dark ? .black : .white) : Color.primary)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primary, lineWidth: 2)
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
                    
                    // Scan Button
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
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .background(colorScheme == .dark ? Color.white : Color.primary)
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image("btIcon")
                    .resizable()
                    .foregroundStyle(.primary)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
            }
        }
    }
}

#Preview {
    DocumentValidationView()
        .environment(AppearanceManager())
}
