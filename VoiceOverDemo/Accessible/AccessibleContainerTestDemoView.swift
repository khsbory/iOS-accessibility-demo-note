import SwiftUI
import UIKit

struct AccessibleContainerTestDemoView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> AccessibleContainerTestViewController {
        return AccessibleContainerTestViewController()
    }

    func updateUIViewController(_ uiViewController: AccessibleContainerTestViewController, context: Context) {
        // 업데이트 로직 없음
    }
}
