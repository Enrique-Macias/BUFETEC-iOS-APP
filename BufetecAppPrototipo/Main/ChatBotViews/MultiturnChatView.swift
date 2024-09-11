//
//  MultiturnChatView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/9/24.
//

import SwiftUI

struct MultiturnChatView: View {
    @State var textInput = ""
    @State var logoAnimating = false
    @State var timer: Timer?
    @State var chatBot = ChatBot()
    
    var body: some View {
        VStack {
            // Animating Logo
            Image("BOT-logo")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
                .foregroundStyle(.tint)
                .opacity(logoAnimating ? 0.5 : 1)
                .animation(.easeInOut, value: logoAnimating)
            Text("Asistente")
                .font(CustomFonts.MontserratBold(size: 24))
                .foregroundStyle(Color("btBlue"))
            
            // Chat message list
            ScrollViewReader(content: { proxy in
                ScrollView {
                    ForEach(chatBot.messages) { chatMessage in
                    // Chat Message View
                        chatMessageView(chatMessage)
                    }
                }
                .onChange(of: chatBot.messages) { _, _ in
                    guard let recentMessage = chatBot.messages.last else { return}
                    DispatchQueue.main.async {
                        withAnimation {
                            proxy.scrollTo(recentMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: chatBot.loadingResponse) { _, newValue in
                    if newValue {
                        startLoadingAnimation()
                    } else {
                        stopLoadingAnimation()
                    }
                }
            })
            
            // Input Fields
            HStack {
                TextField("Enter a message...", text: $textInput)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.black)
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                }
            }
        }
        .foregroundStyle(.white)
        .padding()
        .background {
            // Background
            ZStack {
                Color.gray
            }
            .ignoresSafeArea()
        }
    }
    
    // Chat Message View
    @ViewBuilder func chatMessageView(_ message: ChatMessage) -> some View {
        ChatBubble(direction: message.role == .model ? .left : .right) {
            Text(message.message)
                .font(.title3)
                .padding(.all, 20)
                .foregroundStyle(.white)
                .background(message.role == .model ? Color.blue : Color.green)
        }
    }
    
    // FetchResponse
    func sendMessage() {
        chatBot.sendMessage(textInput)
        textInput = ""
    }
    
    // Respone loading animattion
    func startLoadingAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
            logoAnimating.toggle()
        })
    }
    
    func stopLoadingAnimation() {
        logoAnimating = false
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    MultiturnChatView()
}
