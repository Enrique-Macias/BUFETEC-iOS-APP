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
                ZStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 30) {
                            VStack(spacing: 30) {
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Listos para ayudarte")
                                        .font(CustomFonts.PoppinsBold(size: 25))
                                        .foregroundColor(.white)
                                    
                                    Text("Conoce a nuestros abogados y agenda una cita.")
                                        .font(CustomFonts.MontserratRegular(size: 14))
                                        .foregroundColor(.white)
                                        .lineSpacing(5)
                                    
                                    HStack {
                                        NavigationLink(destination: AttorneysListView()) {
                                            HStack {
                                                Text("Agendar Cita")
                                                    .font(CustomFonts.PoppinsSemiBold(size: 14))
                                                    .foregroundColor(Color("btBlue"))
                                                
                                                Image(systemName: "arrow.right")
                                                    .foregroundColor(Color("btBlue"))
                                            }
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(15)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.top, 15)
                                        .padding(.bottom, 10)
                                    }
                                }
                                .padding(18)
                                .background(Color("btBlue"))
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                
                                
                                
                                //                                CustomCard(selectedTab: $selectedTab,
                                //                                           title: "Conoce a nuestros abogados",
                                //                                           description: "It is a long established fact that a reader will be distracted by the readable content",
                                //                                           buttonText: "Visitar",
                                //                                           destination: AttorneysListView(),
                                //                                           tabIndex: nil)
                                
                                
                                CustomCard(selectedTab: $selectedTab,
                                           title: "Procesos legales",
                                           description: "It is a long established fact that a reader will be distracted by the readable content",
                                           buttonText: "Visitar",
                                           destination: ResourcesView(),
                                           tabIndex: nil)
                                
                                CustomCard(selectedTab: $selectedTab,
                                           title: "Preguntas Frecuentes",
                                           description: "It is a long established fact that a reader will be distracted by the readable content",
                                           buttonText: "Visitar",
                                           destination: FAQView(),
                                           tabIndex: nil)
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
        .environment(AppearanceManager())
}
