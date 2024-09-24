//
//  LawyerView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/7/24.
//

import SwiftUI
import Kingfisher

struct LawyerView: View {
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
                            // News Header
                            NewsHeaderView(showingScrolledTitle: $showingScrolledTitle)
                            VStack {
                                // TabView for News
                                NewsTabView(numberOfTabs: numberOfTabs, selectedIndex: $selectedIndex)
                                
                                // Page Indicator
                                PageIndicator(numberOfTabs: numberOfTabs, selectedIndex: $selectedIndex)
                            }
                            
                            NavigationLink(destination: NewsContentView()){
                                HStack {
                                    Text("Todas las noticias")
                                        .font(.system(size: 16, weight: .semibold))
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 14))
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 10)
                                .frame(maxWidth: 230, maxHeight: 40, alignment: .center)
                                .foregroundColor(.white)
                                .background(Color("btBlue"))
                                .cornerRadius(15)
                            }
                            .padding(.horizontal, 25)
                            .frame(maxWidth: .infinity, alignment: .center)

                            
                            // Cards for "Gestión de Casos" and "Clientes"
                            VStack(spacing: 30) {
                                CustomCard(title: "Gestión de Casos", description: "It is a long established fact that a reader will be distracted by the readable content", buttonText: "Visitar", destination: CasesView())
                                CustomCard(title: "Clientes", description: "It is a long established fact that a reader will be distracted by the readable content", buttonText: "Visitar", destination: ClientView())
                            }
                            .padding(.horizontal, 25)
                        }
                        .padding(.bottom, 100)
                    }
                    .background(Color("btBackground"))
                    .toolbar {
                        CustomToolbar(showingScrolledTitle: $showingScrolledTitle, showingSettings: $showingSettings)
                    }
                    .navigationTitle("Abogado")
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
                    ChatBotFlowView(currentView: $currentView, hasSeenChatbotOnboarding: $hasSeenChatbotOnboarding)
                }
            }
        }
    }
}

// ChatBotFlowView: Esta vista maneja el flujo de vistas de carga, onboarding y el chat del ChatBot
struct ChatBotFlowView: View {
    @Binding var currentView: LawyerView.ChatBotState
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

struct NewsHeaderView: View {
    @Binding var showingScrolledTitle: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Últimas Noticias")
                .font(.system(size: 30, weight: .heavy))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.accentColor)
                .padding(.top, 20)
            
            Text("It is a long established fact that a reader will be distracted by the readable content")
                .font(.system(size: 16))
                .lineSpacing(5)
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 25)
        .padding(.top, 5)
    }
}

struct PlaceholderCard: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 300, height: 150)
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 10) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 20)
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 20)
                    .frame(width: 200)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 15)
                .frame(width: 100)
            
            Spacer()
        }
        .padding(20)
        .frame(width: 340, height: 350)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .opacity(isAnimating ? 0.5 : 1.0)
        .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
}

struct NewsTabView: View {
    var numberOfTabs: Int
    @ObservedObject var list = GetData()
    @Binding var selectedIndex: Int
    
    var body: some View {
        if list.datas.isEmpty {
            TabView {
                ForEach(0..<3) { _ in
                    PlaceholderCard()
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 380)
            .onAppear {
                list.fetchData()
            }
        } else {
            TabView(selection: $selectedIndex) {
                ForEach(0..<min(5, list.datas.count), id: \.self) { index in
                    let article = list.datas[index]
                    NewsCard(
                        cardTitle: article.title,
                        cardBody: article.desc,
                        image: article.image.isEmpty ? "placeholderCardImage" : article.image,
                        cardDate: article.date,
                        articleURL: article.url
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 380)
            .mask(
                LinearGradient(gradient: Gradient(stops: [
                    .init(color: .clear, location: 0),
                    .init(color: .black.opacity(0.05), location: 0.02),
                    .init(color: .black, location: 0.05),
                    .init(color: .black, location: 0.95),
                    .init(color: .black.opacity(0.05), location: 0.98),
                    .init(color: .clear, location: 1)
                ]), startPoint: .leading, endPoint: .trailing)
            )
        }
    }
}

// Page Indicator for the TabView
struct PageIndicator: View {
    var numberOfTabs: Int
    @Binding var selectedIndex: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfTabs, id: \.self) { index in
                Circle()
                    .fill(index == selectedIndex ? Color.accentColor : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut(duration: 0.3), value: selectedIndex)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// Custom Toolbar
struct CustomToolbar: ToolbarContent {
    @Environment(\.colorScheme) var colorScheme
    @Binding var showingScrolledTitle: Bool
    @Binding var showingSettings: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Image("btIcon")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 20, height: 20)
                .padding(.horizontal, 20)
                .foregroundStyle(Color.accentColor)
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                showingSettings.toggle()
            }) {
                Image(systemName: "gearshape")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.accentColor)
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.accentColor)
            })
        }
    }
}

import SwiftUI
import Kingfisher

struct NewsCard: View {
    @Environment(\.colorScheme) var colorScheme
    var cardTitle: String
    var cardBody: String
    var image: String
    var cardDate: String
    var articleURL: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            KFImage(URL(string: image))
                .resizable()
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 310, height: 160)
                        .cornerRadius(15)
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 310, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(cardTitle)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .padding(.top, 5)
            
            Text(cardDate)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Text(cardBody)
                .font(.system(size: 16))
                .lineSpacing(5)
                .foregroundStyle(.primary)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            NavigationLink(destination: FullNewsView(article: NewsDataType(id: UUID().uuidString, title: cardTitle, desc: cardBody, url: articleURL, image: image, date: cardDate, body: cardBody))) {
                HStack {
                    Text("Ver más")
                        .font(.system(size: 16))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14))
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundStyle(Color.accentColor)
                .padding(.top, 5)
            }
        }
        .padding(20)
        .frame(width: 350, height: 350)
        .background(colorScheme == .dark ? .gray.opacity(0.15) : .white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(colorScheme == .dark ? .white.opacity(0.5) : .accentColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct CustomCard: View {
    @Environment(\.colorScheme) var colorScheme
    var title: String
    var description: String
    var buttonText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color.accentColor)
            
            Text(description)
                .font(.system(size: 16))
                .lineSpacing(5)
                .foregroundStyle(.primary)
            
            
            if title == "Clientes" {
                NavigationLink(destination: ClientsView()) {
                    Text(buttonText)
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.accentColor, lineWidth: 2)
                        )
                }
                .foregroundColor(Color.accentColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            } else if title == "Gestión de Casos" {
                NavigationLink(destination: CasesView()) {
                    Text(buttonText)
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.accentColor, lineWidth: 2)
                        )
                }
                .foregroundColor(Color.accentColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            } else {
                Button(action: {
                   
                }) {
                    Text(buttonText)
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.accentColor, lineWidth: 2)
                        )
                }
                .foregroundColor(Color.accentColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(20)
        .background(colorScheme == .dark ? .gray.opacity(0.15) : .white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(colorScheme == .dark ? .white.opacity(0.5) : .accentColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}



#Preview {
    LawyerView()
        .environment(AppearanceManager())
}
