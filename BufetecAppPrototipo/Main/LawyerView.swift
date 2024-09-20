//
//  LawyerView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/7/24.
//

import SwiftUI
import SDWebImageSwiftUI

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
    
    var body: some View {
        GeometryReader { outer in
            NavigationStack {
                ZStack {
                    // Scrollable content in the background
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // News Header
                            NewsHeaderView(showingScrolledTitle: $showingScrolledTitle)
                            
                            // TabView for News
                            NewsTabView(numberOfTabs: numberOfTabs, selectedIndex: $selectedIndex)
                            
                            // Page Indicator
                            PageIndicator(numberOfTabs: numberOfTabs, selectedIndex: $selectedIndex)
                            
                            NavigationLink(destination: NewsContentView()){
                                HStack {
                                    Text("Ver Todas las Noticias")
                                        .font(CustomFonts.PoppinsSemiBold(size: 14))
                                    Image(systemName: "arrow.right")
                                }
                                .padding()
                                .frame(maxWidth: 230, maxHeight: 40, alignment: .center)
                                .foregroundColor(.white)
                                .background(Color("btBlue"))
                                .cornerRadius(10)
                            }
                            .padding(.horizontal, 25)
                            
                            // Cards for "Gestión de Casos" and "Clientes"
                            VStack(spacing: 20) {
                                CustomCard(title: "Gestión de Casos", description: "It is a long established fact that a reader will be distracted by the readable content", buttonText: "Visitar")
                                CustomCard(title: "Clientes", description: "It is a long established fact that a reader will be distracted by the readable content", buttonText: "Visitar")
                            }
                            .padding(.horizontal, 25)
                        }
                        .padding(.bottom, 100)
                    }
                    .toolbar {
                        CustomToolbar(showingScrolledTitle: $showingScrolledTitle, showingSettings: $showingSettings)
                    }
                    .navigationTitle("Abogado")
                    .navigationBarTitleDisplayMode(.inline)
                    .background(Color("btBackground"))
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
                .font(CustomFonts.PoppinsExtraBold(size: 30))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.accentColor)
                .padding(.top, 20)
            
            Text("It is a long established fact that a reader will be distracted by the readable content")
                .font(.custom("HiraginoSans-W3", size: 16))
                .lineSpacing(5)
                .foregroundStyle(.primary)
        }
    }
    
    // TabView for news cards
struct NewsTabView: View {
    var numberOfTabs: Int
    @ObservedObject var list = GetData()
    @Binding var selectedIndex: Int
    
    var body: some View {
        if list.datas.isEmpty {
            Text("Cargando artículos...") // Loading state
                .onAppear {
                    list.fetchData()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white) // To ensure it is visible
        } else {
            TabView(selection: $selectedIndex) {
                ForEach(0..<5, id: \.self) { index in
                    let article = list.datas[index]
                    NewsCard(
                        cardTitle: article.title,
                        cardBody: article.desc,
                        image: article.image.isEmpty ? "placeholderCardImage" : article.image,
                        cardDate:article.date, articleURL:article.url)
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
        @Binding var showingScrolledTitle: Bool
        @Binding var showingSettings: Bool // Binding to control the sheet presentation
        
        var body: some ToolbarContent {
            ToolbarItem(placement: .topBarLeading) {
                Image("btIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundStyle(Color("btBlue"))
                    .frame(width: 27, height: 27)
                    .padding(.horizontal, 20)
            }
            ToolbarItem(placement: .principal) {
                Text("Noticias")
                    .font(.custom("Cosen-Medium", size: 18))
                    .bold()
                    .opacity(showingScrolledTitle ? 1 : 0)
                    .animation(.easeInOut, value: showingScrolledTitle)
                    .foregroundColor(.accentColor)
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 20) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.accentColor)
                    
                    Button(action: {
                        showingSettings.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.accentColor)
                    }
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image("UserCircle")
                            .frame(width: 2, height: 2)
                            .foregroundStyle(Color("btBlue"))
                    })
                }
                .padding(.horizontal, 10)
            }
        }
    }
    
    struct NewsCard: View {
        @Environment(\.colorScheme) var colorScheme
        var cardTitle: String
        var cardBody: String
        var image: String
        var cardDate:String
        var articleURL:String
        
        var body: some View {
            VStack(spacing: 10) {
                if !image.isEmpty {
                               WebImage(url: URL(string: image))
                                   .resizable()
                                   .aspectRatio(contentMode: .fill)
                                   .frame(width: 300, height: 150)
                                   .cornerRadius(20)
                                   
                                   .clipped()
                                   
                                   .transition(.fade(duration: 0.5)) // Optional fade-in transition
                                   .animation(.easeInOut(duration: 0.5), value: image)
                } else {
                    Image("placeholderCardImage") // Default placeholder
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                    .clipped()}
                Spacer()
                
                VStack(alignment: .leading, spacing: -10) {
                    ForEach(cardTitle.components(separatedBy: "\n"), id: \.self) { line in
                        Text(line)
                            .font(.custom("Poppins-Bold", size: 18))
                            .foregroundStyle(.primary)
                           // .foregroundColor(Color(hex: "14397F"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Text(cardDate) // Display the date here
                    .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.bottom, 5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                               // .foregroundColor(Color(hex: "14397F"))
                
                Text(cardBody)
                    .font(.custom("Poppins", size: 15))
                    .lineSpacing(5)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                   // .foregroundColor(Color(hex: "14397F"))
                Spacer()
                
                NavigationLink(destination: FullNewsView(article: NewsDataType(id: UUID().uuidString, title: cardTitle, desc: cardBody, url: articleURL, image: image, date: cardDate, body: cardBody))) {
                               HStack {
                                   Text("Ver más")
                                       .font(.custom("HiraginoSans-W3", size: 16))
                                   Image(systemName: "arrow.right")
                               }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundStyle(Color.accentColor)
                }
            }
            .padding(20)
            .frame(width: 340, height: 350)
            .background(colorScheme == .dark ? .gray.opacity(0.15) : .white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(colorScheme == .dark ? .white.opacity(0.5) : .accentColor, lineWidth: 1)
            )
        }
    }
    
    // Custom Card for "Gestión de Casos" and "Clientes"
    struct CustomCard: View {
        var title: String
        var description: String
        var buttonText: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(CustomFonts.PoppinsBold(size: 25))
                    .foregroundColor(Color("btBlue"))
                
                Text(description)
                    .font(CustomFonts.MontserratRegular(size: 12))
                    .lineSpacing(5)
                    .foregroundStyle(.primary)
                
                Button(action: {
                    // Acción para visitar la sección
                }) {
                    Text(buttonText)
                        .font(CustomFonts.PoppinsSemiBold(size: 10))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 15)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 856)
                                .stroke(Color("btBlue"), lineWidth: 2)
                        )
                }
                .foregroundColor(Color("btBlue"))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("btBlue"), lineWidth: 1)
            )
        }
    }
    
    
    
    
    #Preview {
        LawyerView()
            .environment(AppearanceManager())
    }
}




#Preview {
    LawyerView()
        .environment(AppearanceManager())
}
