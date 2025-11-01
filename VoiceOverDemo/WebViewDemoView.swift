import SwiftUI

struct WebViewDemoView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            if let url = URL(string: "https://rpp.gmarket.co.kr/?exhib=257140") {
                WebView(url: url)
            } else {
                Text("Invalid URL")
                    .foregroundColor(.red)
            }
        }
        .navigationTitle(NSLocalizedString("navigation.title.webView", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text(NSLocalizedString("button.back", comment: ""))
                    }
                }
            }
        }
        .accessibilityAction(.escape) {
            dismiss()
        }
    }
}

#Preview {
    WebViewDemoView()
}
