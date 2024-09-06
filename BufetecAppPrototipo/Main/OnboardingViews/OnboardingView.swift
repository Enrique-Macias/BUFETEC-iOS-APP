//
//  OnboardingView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/6/24.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        TabView {
            OnboardingScreen1View()
            OnboardingScreen2View()
            OnboardingScreen3View()
            WelcomeScreenView()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Desactiva el indicador de página por defecto de TabView
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}


#Preview {
    OnboardingView()
}
