import UIKit
import WebKit

class WebViewController: UIViewController {
    private var webView: WKWebView!
    private var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        setupBackButton()
        loadURL()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Navigation bar 완전 숨김
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 이전 화면으로 돌아갈 때 Navigation bar 다시 표시
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupWebView() {
        // WebView 설정
        let configuration = WKWebViewConfiguration()
        configuration.preferences.javaScriptEnabled = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.allowsInlineMediaPlayback = true

        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = true

        // User Agent 설정
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"

        view.addSubview(webView)

        // ⭐ 핵심: WebView를 view의 정확한 (0,0)에 배치
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupBackButton() {
        // Floating 뒤로가기 버튼
        backButton = UIButton(type: .system)

        // 버튼 외형 설정
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "chevron.left")
        config.imagePadding = 4
        config.baseBackgroundColor = UIColor.white.withAlphaComponent(0.95)
        config.baseForegroundColor = .systemBlue
        config.cornerStyle = .medium

        let backText = NSLocalizedString("button.back", comment: "")
        config.title = backText

        backButton.configuration = config
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        // 그림자 효과
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        backButton.layer.shadowOpacity = 0.2
        backButton.layer.shadowRadius = 4

        view.addSubview(backButton)

        // 버튼 위치 설정 (Safe Area 기준)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        // VoiceOver 접근성
        backButton.accessibilityLabel = backText
        backButton.accessibilityHint = "이전 화면으로 돌아갑니다"
    }

    private func loadURL() {
        if let url = URL(string: "https://khsruru.com/textfield") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
