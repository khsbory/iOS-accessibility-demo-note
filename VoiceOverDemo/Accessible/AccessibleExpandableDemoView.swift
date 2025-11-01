import SwiftUI
import UIKit

struct AccessibleExpandableDemoView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> AccessibleExpandableViewController {
        let viewController = AccessibleExpandableViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: AccessibleExpandableViewController, context: Context) {
        // 업데이트 로직 없음
    }
}
