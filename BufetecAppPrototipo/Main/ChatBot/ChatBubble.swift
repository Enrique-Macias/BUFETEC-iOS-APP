//
//  ChatBubble.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/10/24.
//

import Foundation
import SwiftUI

struct ChatBubble<Content>: View where Content: View {
    let direction: ChatBubbleShape.Direction
    let content: () -> Content
    
    init(direction: ChatBubbleShape.Direction, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.direction = direction
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            if direction == .right {
                Spacer()
            }
            
            if direction == .left {
                // Bot Icon para el bubble del bot
                Image("BOT-logoO")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .padding(.trailing, 5)
                    .foregroundStyle(.foreground)
            } else {
                Spacer()
            }
            content()
                .clipShape(ChatBubbleShape(direction: direction))
        }
        .padding([(direction == .left) ? .leading : .trailing, .top, .bottom], 20)
        .padding((direction == .right) ? .leading : .trailing, 50)
    }
}
