import SwiftUI

struct WelcomeScreenView: View {
    @Environment(AppearanceManager.self) var appearanceManager: AppearanceManager
    @EnvironmentObject var authModel: AuthModel
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State private var showBufetecApp = false
    @Environment(\.colorScheme) var colorScheme
    
    let logoImageName = "LogoBufetec"
    
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                // Título principal con diferentes pesos usando AttributedString
                Text(attributedMainTitle)
                    .multilineTextAlignment(.center)
                    .kerning(-2)
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                
                
                Spacer()
                
                Text("It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout")
                    .font(CustomFonts.MontserratSemiBold(size: 18))
                    .foregroundColor(Color(colorScheme == .light ? Color.accentColor : .white))
                    .foregroundColor(Color(colorScheme == .light ? Color.accentColor : .white))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 80)
                
                Button(action: {
                    hasSeenOnboarding = true
                    showBufetecApp = true
                }) {
                    Text("Comenzar")
                        .font(CustomFonts.PoppinsSemiBold(size: 19))
                        .frame(maxWidth: .infinity)
                        .frame(width: 250 ,height: 50)
                        .foregroundColor(Color(colorScheme == .light ? Color.accentColor : .white))
                        .foregroundColor(Color(colorScheme == .light ? Color.accentColor : .white))
                        .foregroundColor(.white)
                        .cornerRadius(32)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 60)
                .fullScreenCover(isPresented: $showBufetecApp) {
                    AuthenticationView()
                    AuthenticationView()
                }
                
                
                Spacer()
                
                // Indicador de página
//                HStack(spacing: 8) {
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
//                    
//                    Circle()
//                        .fill(Color.accentColor)
//                        .frame(width: 10, height: 10)
//                }
//                .padding(.bottom, 60)
                
                
                // Logo y texto al pie de la vista
                VStack {
                    Image(logoImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 30)
                        .foregroundColor(Color(colorScheme == .light ? Color.accentColor : .white))
                        .foregroundColor(Color(colorScheme == .light ? Color.accentColor : .white))
                }
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            appearanceManager.initAppearanceStyle()
        }
        .onAppear {
            appearanceManager.initAppearanceStyle()
        }
    }
    
    // Método que genera el texto con estilos usando AttributedString
    var attributedMainTitle: AttributedString {
        var attributedString = AttributedString("APOYO LEGAL\nSIN COSTO,\nJUSTICIA PARA\nTODOS")
        
        // Estilo general para todo el texto
        attributedString.font = CustomFonts.PoppinsMedium(size: 40)
        attributedString.foregroundColor = Color(colorScheme == .light ? Color.accentColor : .white)
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
        .environment(AppearanceManager())
        .environmentObject(AuthModel())
        .environment(AppearanceManager())
        .environmentObject(AuthModel())
}
