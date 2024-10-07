import SwiftUI
import Kingfisher

struct NewsListView: View {
    @StateObject private var newsData = GetData()
    @State private var isRefreshing = false
    
    var body: some View {
        List {
            if newsData.isLoading {
                ForEach(0..<5) { _ in
                    LoadingCardView()
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
            } else if newsData.datas.isEmpty {
                Text("No hay artículos disponibles")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(newsData.datas) { article in
                    NavigationLink(destination: FullNewsView(article: article)) {
                        NewsCardView(article: article)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
                }
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            await refreshData()
        }
        .onAppear {
            if newsData.datas.isEmpty {
                newsData.fetchData()
            }
        }
        .background(Color("btBackground"))
        .navigationTitle("Noticias")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func refreshData() async {
        isRefreshing = true
        newsData.fetchData()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isRefreshing = false
    }
}

struct NewsCardView: View {
    let article: NewsDataType
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(article.date)
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(.secondary)
                
                Text(article.desc)
                    .font(.custom("Montserrat-Regular", size: 14))
                    .foregroundColor(.primary)
                    .lineLimit(3)
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            KFImage(URL(string: article.image))
                .resizable()
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(8)
        }
        .padding(.vertical, 12)
    }
}

struct LoadingCardView: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 20)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 16)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 16)
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 100, height: 100)
        }
        .padding(.vertical, 12)
        .opacity(isAnimating ? 0.5 : 1.0)
        .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
}

struct NewsDataType: Identifiable {
    var id: String
    var title: String
    var desc: String
    var url: String
    var image: String
    var date: String
    var body: String
}

class GetData: ObservableObject {
    @Published var datas = [NewsDataType]()
    @Published var isLoading = false
    
    func fetchData() {
        isLoading = true
        let apiUrl = "https://buffetec-api.vercel.app/getNoticias"
        
        guard let url = URL(string: apiUrl) else {
            isLoading = false
            return
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error {
                print("Error fetching news: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                DispatchQueue.main.async {
                    self.datas = decodedResponse.articles.map { article in
                        let formattedDate = self.formatDate(article.date)
                        let bodyContent = article.content ?? "No content available"
                        
                        return NewsDataType(
                            id: UUID().uuidString,
                            title: article.title,
                            desc: article.description ?? "No description",
                            url: article.url,
                            image: article.urlToImage ?? "",
                            date: formattedDate,
                            body: bodyContent
                        )
                    }
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}

struct Response: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let date: String
    let content: String?
}

#Preview {
    NewsListView()
}
