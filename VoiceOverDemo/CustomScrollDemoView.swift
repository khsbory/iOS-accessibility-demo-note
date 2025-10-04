import SwiftUI
import UIKit

struct CustomScrollDemoView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> CustomScrollDemoViewController {
        let viewController = CustomScrollDemoViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: CustomScrollDemoViewController, context: Context) {
        // 업데이트 로직 없음
    }
}
