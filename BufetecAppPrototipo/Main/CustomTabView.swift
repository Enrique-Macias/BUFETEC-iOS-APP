import SwiftUI

enum TabbedItems: Int, CaseIterable {
    case home = 0
    case clients
    case appointments
    case profile
    
    var title: String {
        switch self {
        case .home:
            return "Inicio"
        case .clients:
            return "Clientes"
        case .appointments:
            return "Citas"
        case .profile:
            return "Perfil"
        }
    }
    
    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .clients:
            return "person.crop.rectangle.stack"
        case .appointments:
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

struct CustomTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authModel: AuthModel
    @State private var selectedTab: Int = 0
    
    init() {
        let transparentAppearance = UITabBarAppearance()
        transparentAppearance.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = transparentAppearance
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if authModel.isLoading || authModel.userData.tipo.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: colorScheme == .dark ? .white : .black))
            } else if !authModel.userData.tipo.isEmpty {
                TabView(selection: $selectedTab) {
                    NavigationStack {
                        if authModel.userData.tipo == "cliente" {
                            ClientView(selectedTab: $selectedTab)
                        } else {
                            LawyerView(selectedTab: $selectedTab)
                        }
                    }
                    .tag(TabbedItems.home.rawValue)
                    
                    if authModel.userData.tipo == "abogado" {
                        NavigationStack {
                            ClientsListView()
                        }
                        .tag(TabbedItems.clients.rawValue)
                    }
                    
                    NavigationStack {
                        AppointmentsListView()
                    }
                    .tag(TabbedItems.appointments.rawValue)
                    
                    NavigationStack {
                        ProfileView()
                    }
                    .tag(TabbedItems.profile.rawValue)
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Gradient overlay
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color(UIColor.systemBackground).opacity(0.8),
                            Color(UIColor.systemBackground)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 100)
                    .allowsHitTesting(false)
                }
                .ignoresSafeArea()
                
                CustomTabBar(selectedTab: $selectedTab, colorScheme: colorScheme, isLawyer: authModel.userData.tipo == "abogado")
            } else {
                Text("Error: No se pudo cargar la información del usuario")
                    .foregroundColor(.red)
            }
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    var colorScheme: ColorScheme
    var isLawyer: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabbedItems.allCases, id: \.self) { item in
                if isLawyer || item != .clients {
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
        }
        .frame(height: 55)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(colorScheme == .dark ? .white.opacity(0.5) : .accentColor, lineWidth: 1)
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
                .foregroundColor(isActive ? (colorScheme == .dark ? .white : .accentColor) : .gray)
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 20)
            Text(title)
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(isActive ? (colorScheme == .dark ? .white : .accentColor) : .gray)
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
        .cornerRadius(20)
        .contentShape(Rectangle())
    }
}

#Preview {
    CustomTabView()
        .environmentObject(AuthModel())
}
