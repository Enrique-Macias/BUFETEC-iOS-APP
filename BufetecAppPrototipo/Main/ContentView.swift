import SwiftUI


enum TabbedItems: Int, CaseIterable {
    case home = 0
    case favorite
    case chat
    case profile
    
    var title: String {
        switch self {
        case .home:
            return "Noticias"
        case .favorite:
            return "Casos"
        case .chat:
            return "Citas"
        case .profile:
            return "Perfil"
        }
    }
    
    var iconName: String {
        switch self {
        case .home:
            return "newspaper"
        case .favorite:
            return "book.closed"
        case .chat:
            return "text.bubble"
        case .profile:
            return "person"
        }
    }
}

struct NoEffectButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

struct ContentView: View {
    @Environment(AppearanceManager.self) var appearanceManager: AppearanceManager
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab = 0
    
    
    init() {
        let transparentAppearance = UITabBarAppearance()
        transparentAppearance.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = transparentAppearance
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    NewsView().tag(TabbedItems.home.rawValue)
                    CasesView().tag(TabbedItems.favorite.rawValue)
                    AppointmentsView().tag(TabbedItems.chat.rawValue)
                    ProfileView().tag(TabbedItems.profile.rawValue)
                }
                
                CustomTabBar(selectedTab: $selectedTab, colorScheme: colorScheme)
            }
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    var colorScheme: ColorScheme
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabbedItems.allCases, id: \.self) { item in
                Button {
                    withAnimation(nil) {
                        selectedTab = item.rawValue
                    }
                } label: {
                    CustomTabItem(imageName: item.iconName, title: item.title, isActive: selectedTab == item.rawValue, colorScheme: colorScheme)
                }
                .buttonStyle(NoEffectButton())
            }
        }
        .frame(height: 55)
        .background(
            colorScheme == .dark ? Color.clear : Color.white
        )
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(colorScheme == .dark ? .white.opacity(0.5) : Color("btBlue"), lineWidth: 1)
        )
        .padding(.bottom, -5)
        .shadow(color: .black.opacity(0.1), radius: 10, y: 15)
        .padding(.horizontal)
    }
}

struct CustomTabItem: View {
    var imageName: String
    var title: String
    var isActive: Bool
    var colorScheme: ColorScheme
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: isActive ? "\(imageName).fill" : imageName)
                .symbolRenderingMode(.monochrome)
                .resizable()
                .foregroundColor(isActive ? (colorScheme == .dark ? .white : Color("btBlue")) : .gray)
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 20)
            Text(title)
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(isActive ? (colorScheme == .dark ? .white : Color("btBlue")) : .gray)
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
        .cornerRadius(20)
        .contentShape(Rectangle())
    }
}

#Preview {
    ContentView()
        .environment(AppearanceManager())
}
