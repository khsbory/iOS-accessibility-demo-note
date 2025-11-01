import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()

        // JavaScript 활성화
        configuration.preferences.javaScriptEnabled = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true

        // 미디어 재생 설정
        configuration.allowsInlineMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: configuration)

        // 사용자 에이전트 설정 (모바일 웹 사이트가 제대로 동작하도록)
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"

        // 줌 허용
        webView.scrollView.isScrollEnabled = true

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
