import SwiftUI

struct FocusTestDemoView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FocusTestViewController {
        return FocusTestViewController()
    }

    func updateUIViewController(_ uiViewController: FocusTestViewController, context: Context) {
        // 업데이트 필요 없음
    }
}

#Preview {
    FocusTestDemoView()
}
