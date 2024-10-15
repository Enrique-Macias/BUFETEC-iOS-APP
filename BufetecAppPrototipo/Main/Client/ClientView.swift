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
    
    var body: some View {
        GeometryReader { outer in
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        VStack(spacing: 30) {
                            // Attorney Assistance Card
                            NavigationGradientCard(
                                icon: "person.fill.checkmark",
                                title: "Listos para ayudarte",
                                description: "Conoce a nuestros abogados y agenda una cita.",
                                buttonText: "Agendar Cita",
                                destination: AttorneysListView()
                            )
                            
                            // ChatBot Assistant Card
                            ActionGradientCard(
                                icon: "bubble.left.and.bubble.right.fill",
                                title: "Asistente Virtual",
                                description: "Resuelve tus dudas de forma rápida con nuestro asistente virtual inteligente.",
                                buttonText: "Iniciar Chat",
                                action: {
                                    showingChatbotViews = true
                                    currentView = .load
                                },
                                gradientColors: colorScheme == .dark ? [Color.gray.opacity(0.15), Color.accentColor.opacity(0.15)] : [Color.white]
                            )
                            
                            // FAQ Card
                            NavigationGradientCard(
                                icon: "questionmark.circle",
                                title: "Preguntas Frecuentes",
                                description: "Respuestas a dudas comunes sobre la plataforma.",
                                buttonText: "Visitar",
                                destination: FAQView()
                            )
                        }
                        .padding()
                    }
                    .padding(.bottom, 100)
                }
                .background(Color("btBackground"))
                .navigationTitle("Inicio")
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

struct ActionGradientCard: View {
    @Environment(\.colorScheme) var colorScheme
    
    var icon: String
    var title: String
    var description: String
    var buttonText: String
    var action: () -> Void
    var gradientColors: [Color]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 25))
                    .foregroundColor(.accentColor)
                
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.accentColor)
            }
            
            Text(description)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .lineSpacing(5)
            
            Button(action: action) {
                HStack {
                    Text(buttonText)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.accentColor)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.accentColor, lineWidth: 3)
                )
                .cornerRadius(15)
            }
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .padding(25)
        .background(
            LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .bottomLeading, endPoint: .top)
        )
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(colorScheme == .dark ? .white.opacity(0.5) : .accentColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct NavigationGradientCard<Destination: View>: View {
    @Environment(\.colorScheme) var colorScheme
    
    var icon: String
    var title: String
    var description: String
    var buttonText: String
    var destination: Destination?
    var gradientColors: [Color]?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 25))
                    .foregroundColor(.accentColor)
                
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.accentColor)
            }
            
            Text(description)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .lineSpacing(5)
            
            Group {
                NavigationLink(destination: destination) {
                    buttonContent
                }
            }
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .padding(25)
        .background(
            LinearGradient(
                gradient: Gradient(colors: gradientColors ?? [colorScheme == .dark ? Color.gray.opacity(0.15) : .white]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(colorScheme == .dark ? .white.opacity(0.5) : .accentColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    private var buttonContent: some View {
        HStack {
            Text(buttonText)
                .font(.system(size: 16, weight: .semibold))
            
            Image(systemName: "arrow.right")
        }
        .foregroundColor(.accentColor)
        .padding()
        .background(.clear)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.accentColor, lineWidth: 3)
        )
        .cornerRadius(15)
    }
}


#Preview {
    ClientView(selectedTab: .constant(0))
}
