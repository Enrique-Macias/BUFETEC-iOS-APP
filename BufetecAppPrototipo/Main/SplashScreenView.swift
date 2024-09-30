import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Color("btBackground").edgesIgnoringSafeArea(.all)
            
            Image("LogoBufetec")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.5)
                .position(appState.logoPosition)
        }
        .onAppear {
            // Add a delay before changing the position
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.spring(duration: 0.8)) {
                    appState.logoPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.1)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    appState.isShowingSplash = false
                }
            }
        }
    }
}
