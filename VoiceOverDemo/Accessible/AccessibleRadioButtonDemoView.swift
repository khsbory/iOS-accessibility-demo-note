import SwiftUI
import UIKit

struct AccessibleRadioButtonDemoView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> RadioButtonDemoViewController {
        let viewController = RadioButtonDemoViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: RadioButtonDemoViewController, context: Context) {
        // 업데이트 로직 없음
    }
}
