import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var authModel: AuthModel
    @EnvironmentObject var splashScreenState: SplashScreenState
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("btBackground")
                    .edgesIgnoringSafeArea(.all)
                
                Image("LogoBufetec")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * 0.5)
                    .position(splashScreenState.logoPosition)
            }
            .onAppear {
                splashScreenState.logoPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                if authModel.authState == .authenticated {
                    // For authenticated users, show the logo briefly without animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.easeOut(duration: 0.3)) {
                            splashScreenState.isFinished = true
                        }
                    }
                } else {
                    // For non-authenticated users, perform the original animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            splashScreenState.logoPosition = CGPoint(x: geometry.size.width / 2, y: 70 + (UIScreen.main.bounds.width * 0.5 * 0.3) / 2)
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            withAnimation(.easeOut(duration: 0.3)) {
                                splashScreenState.isFinished = true
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(SplashScreenState())
        .environmentObject(AuthModel())
}
