import SwiftUI
import UIKit

struct NonAccessibleDemoView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> NonAccessibleViewController {
        let viewController = NonAccessibleViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: NonAccessibleViewController, context: Context) {
        // 업데이트 로직 없음
    }
}
