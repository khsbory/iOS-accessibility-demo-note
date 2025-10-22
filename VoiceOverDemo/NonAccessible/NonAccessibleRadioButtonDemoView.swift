import SwiftUI
import UIKit

struct NonAccessibleRadioButtonDemoView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> NonAccessibleRadioButtonViewController {
        let viewController = NonAccessibleRadioButtonViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: NonAccessibleRadioButtonViewController, context: Context) {
        // 업데이트 로직 없음
    }
}
