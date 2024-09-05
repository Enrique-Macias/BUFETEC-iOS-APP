//
//  LoadView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/5/24.
//

import SwiftUI

struct LoadView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        ZStack {
            Color(colorScheme == .light ? Color("btBlue") : .white)
                .edgesIgnoringSafeArea(.all)
            Image("ChatAILogo")
                .foregroundColor(Color(colorScheme == .light ? .white : Color("btBlue")))
            
        }
    }
}

struct LoadView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadView()
                .preferredColorScheme(.light) // Modo claro
            LoadView()
                .preferredColorScheme(.dark)  // Modo oscuro
        }
    }
}

#Preview {
    LoadView()
}
