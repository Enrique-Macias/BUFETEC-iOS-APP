//
//  ChatBot.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/7/24.
//

import SwiftUI

// ChatBot Button in the lower-right corner
struct ChatBotButton: View {
    var body: some View {
        ZStack {
            // Outer border circle
            Circle()
                .stroke(Color("btBlue"), lineWidth: 4)
                .frame(width: 65, height: 65)
            
            // Inner filled circle
            Circle()
                .fill(Color("btBlue"))
                .frame(width: 55, height: 55)
            
            // Icon in the center
            Image("BOT-logo")
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
                .foregroundColor(.white)
        }
    }
}
