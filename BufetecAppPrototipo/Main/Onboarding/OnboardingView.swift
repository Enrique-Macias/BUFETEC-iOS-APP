import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authModel: AuthModel
    
    var body: some View {
        ZStack{
            Color("btBackground")
                .edgesIgnoringSafeArea(.all)
            TabView {
                OnboardingScreen1View()
                OnboardingScreen2View()
                OnboardingScreen3View()
                WelcomeScreenView()
            }
            .tabViewStyle(PageTabViewStyle())
            .onAppear {
                if colorScheme == .light {
                    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.black
                    UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
                } else {
                    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.white
                    UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AuthModel())
}
