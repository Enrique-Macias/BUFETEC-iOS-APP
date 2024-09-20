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
            Color("btBakground")
                .edgesIgnoringSafeArea(.all)
            Image("ChatAILogo")
                .foregroundColor(colorScheme == .light ? Color.accentColor : Color.white)
            
        }
    }
}

#Preview {
    LoadView()
}
