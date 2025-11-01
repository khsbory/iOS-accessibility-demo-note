import SwiftUI
import UIKit

struct NonAccessibleExpandableDemoView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> NonAccessibleExpandableViewController {
        let viewController = NonAccessibleExpandableViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: NonAccessibleExpandableViewController, context: Context) {
        // 업데이트 로직 없음
    }
}
