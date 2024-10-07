import SwiftUI
import WebKit

struct FullNewsView: View {
    var article: NewsDataType

    var body: some View {
        WebView(url: URL(string: article.url)!)
            .navigationTitle("Noticia")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct WebView: UIViewRepresentable {
    var url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
