//
//  ClientView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/23/24.
//

import SwiftUI
import Kingfisher

struct ClientView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showingScrolledTitle = false
    @State private var selectedIndex = 0
    @State private var showingSettings = false
    
    // ChatBot
    @State private var currentView: ChatBotState = .main
    @AppStorage("hasSeenChatbotOnboarding") private var hasSeenChatbotOnboarding = false
    @State private var showingChatbotViews = false
    
    // Control Views of ChatBot
    enum ChatBotState {
        case main, load, onboarding, chat
    }
    
    private let numberOfTabs = 5
    
    private func scrollDetector(topInsets: CGFloat) -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .global).minY
            let isUnderToolbar = minY - topInsets < 0
            Color.clear
                .onChange(of: isUnderToolbar) { oldVal, newVal in
                    showingScrolledTitle = newVal
                }
        }
    }
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.tintColor]
    }
    
    var body: some View {
        GeometryReader { outer in
            NavigationStack {
                ZStack {
                    // Scrollable content in the background
                    ScrollView {
                        VStack(alignment: .leading, spacing: 30) {
                            // Título del Card
                            Text("LISTOS PARA AYUDARTE")
                                .font(CustomFonts.PoppinsBold(size: 35))
                                .foregroundColor(.white)
                            
                            // Descripción
                            Text("It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.")
                                .font(CustomFonts.MontserratRegular(size: 14))
                                .foregroundColor(.white)
                                .lineSpacing(5)
                            
                            // Botón "Agendar Cita" usando NavigationLink para navegar a AppointmentsView()
                            HStack {
                                NavigationLink(destination: AppointmentsView()) {
                                    HStack {
                                        Text("Agendar Cita")
                                            .font(CustomFonts.PoppinsSemiBold(size: 14))
                                            .foregroundColor(Color("btBlue"))
                                        
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(Color("btBlue"))
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(30)
                                }
                                .padding(.top, 15)
                                .padding(.bottom, 10) // Padding para que no quede pegado al borde inferior
                            }
                        }
                        .padding(25) // Padding interno
                        .background(Color("btBlue"))
                        .cornerRadius(15) // Borde redondeado
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5) // Sombra del card
                        .padding() // Padding externo
                        VStack(alignment: .leading, spacing: 30) {
                            // Cards
                            VStack(spacing: 30) {
                                CustomCard(title: "Recursos", description: "It is a long established fact that a reader will be distracted by the readable content", buttonText: "Visitar", destination: ResourcesView())
                                CustomCard(title: "Procesos legales", description: "It is a long established fact that a reader will be distracted by the readable content", buttonText: "Visitar", destination: ResourcesView())
                                CustomCard(title: "Preguntas Frecuentes", description: "It is a long established fact that a reader will be distracted by the readable content", buttonText: "Visitar", destination: FAQView())
                            }
                            .padding()
                        }
                        .padding(.bottom, 100)
                    }
                    .background(Color("btBackground"))
                    .toolbar {
                        CustomToolbar(showingScrolledTitle: $showingScrolledTitle, showingSettings: $showingSettings)
                    }
                    .navigationTitle("Cliente")
                    .navigationBarTitleDisplayMode(.inline)
                    .sheet(isPresented: $showingSettings) {
                        SettingsView()
                    }
                    
                    // Floating ChatBot Button
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ChatBotButton()
                                .padding(20)
                                .padding(.bottom, 85)
                                .onTapGesture {
                                    print("tapped chatbot button")
                                    showingChatbotViews = true
                                    currentView = .load
                                }
                        }
                    }
                    .ignoresSafeArea()
                }
                .fullScreenCover(isPresented: $showingChatbotViews) {
                    ChatBotFlowClientView(currentView: $currentView, hasSeenChatbotOnboarding: $hasSeenChatbotOnboarding)
                }
            }
        }
    }
}


// ChatBotFlowView: Esta vista maneja el flujo de vistas de carga, onboarding y el chat del ChatBot
struct ChatBotFlowClientView: View {
    @Binding var currentView: ClientView.ChatBotState
    @Binding var hasSeenChatbotOnboarding: Bool
    
    var body: some View {
        ZStack {
            if currentView == .load {
                LoadView()
                    .onAppear {
                        print("Mostrando LoadView...")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            if hasSeenChatbotOnboarding {
                                print("Mostrando ChatView...")
                                currentView = .chat
                            } else {
                                print("Mostrando OnboardingChatBotView...")
                                currentView = .onboarding
                            }
                        }
                    }
            } else if currentView == .onboarding {
                OnboardingChatBotView(onContinue: {
                    print("Onboarding completado. Mostrando ChatView.")
                    hasSeenChatbotOnboarding = true
                    currentView = .chat
                })
            } else if currentView == .chat {
                MultiturnChatView()
            } else {
                Text("Error: No se pudo determinar la vista actual.")
            }
        }
    }
}



#Preview {
    ClientView()
        .environment(AppearanceManager())
}
