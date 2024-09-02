import SwiftUI

struct NewsView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showingScrolledTitle = false
    @State private var selectedIndex = 0
    @State private var showingSettings = false
    private let numberOfTabs = 5
    
    private func scrollDetector(topInsets: CGFloat) -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .global).minY
            let isUnderToolbar = minY - topInsets < 0
            Color.clear
                .onChange(of: isUnderToolbar) { newVal in
                    showingScrolledTitle = newVal
                }
        }
    }
    
    var body: some View {
        GeometryReader { outer in
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        NewsHeaderView(showingScrolledTitle: $showingScrolledTitle, topInsets: outer.safeAreaInsets.top)
                        
                        NewsTabView(numberOfTabs: numberOfTabs, selectedIndex: $selectedIndex)
                        
                        PageIndicator(numberOfTabs: numberOfTabs, selectedIndex: $selectedIndex)
                    }
                    .padding(.bottom, 20)
                }
                .background(Color("btBeige"))
                .toolbar {
                    CustomToolbar(showingScrolledTitle: $showingScrolledTitle, showingSettings: $showingSettings)
                }
                .navigationTitle("Noticias")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color("btBeige"))
                .sheet(isPresented: $showingSettings) {
                    SettingsView()
                }
            }
        }
    }
}

struct NewsHeaderView: View {
    @Binding var showingScrolledTitle: Bool
    var topInsets: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Noticias")
                .font(.custom("Cosen-Medium", size: 32))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color("btBlue"))
            
            Text("It is a long established fact that a reader will be distracted by the readable content")
                .font(.custom("HiraginoSans-W3", size: 16))
                .lineSpacing(5)
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 25)
        .padding(.top, 5)
        .background {
            GeometryReader { proxy in
                let minY = proxy.frame(in: .global).minY
                let isUnderToolbar = minY - topInsets < 0
                Color.clear
                    .onChange(of: isUnderToolbar) { newVal in
                        showingScrolledTitle = newVal
                    }
            }
        }
    }
}

struct NewsTabView: View {
    var numberOfTabs: Int
    @Binding var selectedIndex: Int
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(0..<numberOfTabs, id: \.self) { index in
                NewsCard(
                    cardTitle: "Plataforma de Poder Judicial \ndel Estado de Nuevo León",
                    cardBody: "It is a long established fact that a reader will be distracted by the readable content.",
                    image: "placeholderCardImage"
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

struct PageIndicator: View {
    var numberOfTabs: Int
    @Binding var selectedIndex: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfTabs, id: \.self) { index in
                Circle()
                    .fill(index == selectedIndex ? Color("btBlue") : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut(duration: 0.3), value: selectedIndex)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct CustomToolbar: ToolbarContent {
    @Binding var showingScrolledTitle: Bool
    @Binding var showingSettings: Bool // Binding to control the sheet presentation
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Image("placeholderProfileImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 27, height: 27)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.primary, lineWidth: 1)
                )
                .padding(.horizontal, 10)
        }
        ToolbarItem(placement: .principal) {
            Text("Noticias")
                .font(.custom("Cosen-Medium", size: 18))
                .bold()
                .opacity(showingScrolledTitle ? 1 : 0)
                .animation(.easeInOut, value: showingScrolledTitle)
                .foregroundColor(Color("btBlue"))
        }
        ToolbarItem(placement: .topBarTrailing) {
            HStack(spacing: 20) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color("btBlue"))
                
                Button(action: {
                    showingSettings.toggle()
                }) {
                    Image(systemName: "gearshape")
                        .foregroundColor(Color("btBlue"))
                }
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
    
    var body: some View {
        VStack(spacing: 10) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 120)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(colorScheme == .dark ? .white.opacity(0.5) : Color("btBlue"), lineWidth: 1)
                )
            
            Spacer()
            
            VStack(alignment: .leading, spacing: -10) {
                ForEach(cardTitle.components(separatedBy: "\n"), id: \.self) { line in
                    Text(line)
                        .font(.custom("Cosen-Medium", size: 18))
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text(cardBody)
                .font(.custom("HiraginoSans-W3", size: 16))
                .lineSpacing(5)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Button {
                print("Ver más")
            } label: {
                HStack {
                    Text("Ver más")
                        .font(.custom("HiraginoSans-W3", size: 16))
                    Image(systemName: "arrow.right")
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundStyle(.primary)
            }
        }
        .padding(20)
        .frame(width: 340, height: 350)
        .background(colorScheme == .dark ? .gray.opacity(0.15) : .white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(colorScheme == .dark ? .white.opacity(0.5) : Color("btBlue"), lineWidth: 1)
        )
    }
}

#Preview {
    NewsView()
        .environmentObject(AppearanceManager())
}
