import SwiftUI

struct WelcomeScreenView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var authModel: AuthModel
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State private var showBufetecApp = false
    @Environment(\.colorScheme) var colorScheme
    
    let logoImageName = "LogoBufetec"
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Text(attributedMainTitle)
                    .multilineTextAlignment(.center)
                    .kerning(-2)
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                
                Spacer()
                
                Text("Bufetec es un despacho jurídico que ofrece asesoría legal gratuita a grupos vulnerables, con atención humana y responsable. Además, impulsa el desarrollo ético de estudiantes de Derecho a través de prácticas formativas.")
                    .font(CustomFonts.MontserratSemiBold(size: 16))
                    .foregroundColor(Color(colorScheme == .light ? Color.accentColor : .white))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                
                Button(action: {
                    hasSeenOnboarding = true
                    showBufetecApp = true
                }) {
                    Text("Comenzar")
                        .font(CustomFonts.PoppinsSemiBold(size: 19))
                        .frame(maxWidth: .infinity)
                        .frame(width: 250 ,height: 50)
                        .foregroundColor(Color(colorScheme == .light ? Color.accentColor : .white))
                        .foregroundColor(.white)
                        .cornerRadius(32)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 60)
                .fullScreenCover(isPresented: $showBufetecApp) {
                    AuthenticationView()
                }
                
                Spacer()
                
                VStack {
                    Image(logoImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 30)
                        .foregroundColor(Color(colorScheme == .light ? Color.accentColor : .white))
                }
                Spacer()
                Spacer()
            }
        }
    }
    
    // Método que genera el texto con estilos usando AttributedString
    var attributedMainTitle: AttributedString {
        var attributedString = AttributedString("APOYO LEGAL\nSIN COSTO,\nJUSTICIA PARA\nTODOS")
        
        // Estilo general para todo el texto
        attributedString.font = CustomFonts.PoppinsMedium(size: 40)
        attributedString.foregroundColor = Color(colorScheme == .light ? Color.accentColor : .white)
        
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

#Preview {
    WelcomeScreenView()
        .environmentObject(AuthModel())
}
