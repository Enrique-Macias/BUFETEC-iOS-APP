//
//  ChatBot.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/7/24.
//

import SwiftUI
import Foundation
import GoogleGenerativeAI

enum ChatRole {
    case user
    case model
}

struct ChatMessage: Identifiable, Equatable {
    let id = UUID().uuidString
    var role: ChatRole
    var message: String
}

@Observable
class ChatBot {
    private var chat: Chat?
    private(set) var messages = [ChatMessage]()
    private(set) var loadingResponse = false
    
    func sendMessage(_ message: String) {
        loadingResponse = true
        
        if(chat == nil) {
            let history: [ModelContent] = messages.map { ModelContent(role: $0.role == .user ? "user" : "model", parts: $0.message)}
            chat = GenerativeModel(name: "gemini-1.5-pro", apiKey: APIKey.default).startChat(history: history)
        }
        
            // Add Users message to the list
        messages.append(.init(role:.user, message: message))
        
        Task {
            do {
                let response = try await chat?.sendMessage(message)
                
                loadingResponse = false
                
                guard let text = response?.text else {
                    messages.append(.init(role: .model, message: "Something went wrong, please try again."))
                    return
                }
                
                messages.append(.init(role: .model, message: text))
            }
            catch {
                loadingResponse = false
                messages.append(.init(role: .model, message: "Something went wrong, please try again."))
            }
        }
    }
}

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
