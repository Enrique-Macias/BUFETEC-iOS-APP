import SwiftUI
import Kingfisher

struct ClientView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showingScrolledTitle = false
    @State private var selectedIndex = 0
    @State private var showingSettings = false
    @Binding var selectedTab: Int
    
    @State private var currentView: ChatBotState = .main
    @AppStorage("hasSeenChatbotOnboarding") private var hasSeenChatbotOnboarding = false
    @State private var showingChatbotViews = false
    
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
    
    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.tintColor]
    }
    
    var body: some View {
        GeometryReader { outer in
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        VStack(spacing: 30) {
                            // Existing "Listos para ayudarte" card
                            AttorneyAssistanceCard()
                            
                            // New ChatBot Assistant card
                            ChatBotAssistantCard(showingChatbotViews: $showingChatbotViews, currentView: $currentView)
                            
                            // Existing FAQ card
                            CustomCard(selectedTab: $selectedTab,
                                       title: "Preguntas Frecuentes",
                                       description: "Respuestas a dudas comunes sobre la plataforma.",
                                       buttonText: "Visitar",
                                       destination: FAQView(),
                                       tabIndex: nil)
                        }
                        .padding()
                    }
                    .padding(.bottom, 100)
                }
                .background(Color("btBackground"))
                .navigationTitle("Cliente")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showingSettings) {
                    SettingsView()
                }
            }
            .fullScreenCover(isPresented: $showingChatbotViews) {
                ChatBotFlowClientView(currentView: $currentView, hasSeenChatbotOnboarding: $hasSeenChatbotOnboarding)
            }
        }
    }
}

struct AttorneyAssistanceCard: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Listos para ayudarte")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(colorScheme == .dark ? Color.accentColor : Color.white)
            
            Text("Conoce a nuestros abogados y agenda una cita.")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .lineSpacing(5)
            
            HStack {
                NavigationLink(destination: AttorneysListView()) {
                    HStack {
                        Text("Agendar Cita")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("btBlue"))
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(Color("btBlue"))
                    }
                    .padding()
                    .background(colorScheme == .dark ? Color.clear : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.accentColor, lineWidth: 4)
                    )
                    .cornerRadius(15)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 15)
                .padding(.bottom, 10)
            }
        }
        .padding(18)
        .background(colorScheme == .dark ? .gray.opacity(0.15) : .accentColor)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(colorScheme == .dark ? .white.opacity(0.5) : .accentColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct ChatBotAssistantCard: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var showingChatbotViews: Bool
    @Binding var currentView: ClientView.ChatBotState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Asistente Virtual")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(colorScheme == .dark ? Color.accentColor : Color.white)
            
            Text("Resuelve tus dudas de forma rápida con nuestro asistente virtual.")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .lineSpacing(5)
            
            Button(action: {
                showingChatbotViews = true
                currentView = .load
            }) {
                HStack {
                    Text("Iniciar Chat")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("btBlue"))
                    
                    Image(systemName: "message.circle.fill")
                        .foregroundColor(Color("btBlue"))
                }
                .padding()
                .background(colorScheme == .dark ? Color.clear : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.accentColor, lineWidth: 4)
                )
                .cornerRadius(15)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 15)
            .padding(.bottom, 10)
        }
        .padding(18)
        .background(colorScheme == .dark ? .gray.opacity(0.15) : .accentColor)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(colorScheme == .dark ? .white.opacity(0.5) : .accentColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

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
    ClientView(selectedTab: .constant(0))
}
