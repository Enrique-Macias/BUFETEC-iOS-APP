import SwiftUI
import Kingfisher

struct NewsContentView: View {
    @ObservedObject var list = GetData()
    
    var body: some View {
        List {
            if list.datas.isEmpty {
                Text("No hay artículos disponibles")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(list.datas) { article in
                    NavigationLink(destination: FullNewsView(article: article)) {
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
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
                }
            }
        }
        .listStyle(PlainListStyle())
        .onAppear {
            if list.datas.isEmpty {
                list.fetchData()
            }
        }
        .background(Color("btBackground"))
        .navigationTitle("Noticias")
        .navigationBarTitleDisplayMode(.inline)
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
        let apiKey = "c265e314cdec4e99923322a182cc71be"
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
    let publishedAt: String
    let content: String?
}

struct NewsContentView_Previews: PreviewProvider {
    static var previews: some View {
        NewsContentView()
    }
}
