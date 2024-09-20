import SwiftUI
import SDWebImageSwiftUI

struct NewsContentView: View {
    @ObservedObject var list = GetData()

    var body: some View {
        NavigationView {
            List {
                if list.datas.isEmpty {
                    Text("No articles available")
                        .foregroundColor(.gray)
                } else {
                    ForEach(list.datas) { article in
                        NavigationLink(destination: FullNewsView(article: article)) {
                            HStack(spacing: 15) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(article.title)
                                        .font(.custom("Poppins-Bold", size: 17))
                                        .foregroundColor(Color(hex: "14397F"))
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.8)

                                    Text(article.date)
                                        .font(.custom("Poppins-Medium", size: 13))
                                        .foregroundColor(Color(hex: "14397F"))
                                        .minimumScaleFactor(0.3)

                                    Text(article.desc)
                                        .font(.custom("Montserrat-Regular", size: 16))
                                        .foregroundColor(Color(hex: "14397F"))
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.6)
                                }

                                if let imageUrl = URL(string: article.image), !imageUrl.absoluteString.isEmpty {
                                    WebImage(url: imageUrl, options: .highPriority)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 100)
                                        .cornerRadius(20)
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .scaledToFit()
                                        .frame(width: 110, height: 135)
                                        .cornerRadius(20)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 0)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Noticias recientes")
                        .font(.custom("Poppins-ExtraBold", size: 24))
                        .foregroundColor(Color(hex: "14397F"))
                }
            }
        }
        .onAppear {
            if list.datas.isEmpty {
                list.fetchData()
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let r, g, b: Double
        
        // Remove the hash at the start if it's there
        let hexColor = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        
        // Convert hex string to Int
        var hexNumber: UInt64 = 0
        Scanner(string: hexColor).scanHexInt64(&hexNumber)

        r = Double((hexNumber & 0xFF0000) >> 16) / 255.0
        g = Double((hexNumber & 0x00FF00) >> 8) / 255.0
        b = Double(hexNumber & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
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
    
    func fetchData() {
        let apiKey = "c265e314cdec4e99923322a182cc71be" // Replace with your actual API key
        let searchQuery = "leyes AND monterrey"
        let apiUrl = "https://newsapi.org/v2/everything?q=\(searchQuery)&apiKey=\(apiKey)"
        
        guard let url = URL(string: apiUrl) else { return }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
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
                        let formattedDate = self.formatDate(article.publishedAt)
                        let bodyContent = article.content ?? "No content available" // Get the body content
                        
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
    let publishedAt: String
    let content: String?
}

struct NewsContentView_Previews: PreviewProvider {
    static var previews: some View {
        NewsContentView()
    }
}
