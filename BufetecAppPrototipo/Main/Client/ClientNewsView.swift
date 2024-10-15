import SwiftUI
import Kingfisher

struct ClientNewsView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showingScrolledTitle = false
    @State private var selectedIndex = 0
    @State private var showingSettings = false
    
    @StateObject private var newsData = GetData()
    
    var body: some View {
        GeometryReader { outer in
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Más recientes")
                                .font(.system(size: 24, weight: .heavy))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(Color.accentColor)
                            
                            Text("Anuncios recientes y actualizaciones importantes de Bufetec.")
                                .font(.system(size: 16))
                                .lineSpacing(5)
                                .foregroundStyle(.primary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 5)
                        
                        VStack {
                            // TabView for News
                            NewsTabView(list: newsData, selectedIndex: $selectedIndex)
                            
                            // Page Indicator
                            PageIndicator(list: newsData, selectedIndex: $selectedIndex)
                        }
                        
                        NavigationLink(destination: NewsListView()){
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
                            .background(colorScheme == .dark ? Color.gray.opacity(0.15) : Color.accentColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.accentColor, lineWidth: 4)
                            )
                            .cornerRadius(15)
                        }
                        //                    .padding(.top, 10)
                        .padding(.horizontal, 15)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
        .onAppear {
            newsData.fetchData()
        }
        .background(Color("btBackground"))
        .navigationTitle("Noticias")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ClientNewsView()
}
