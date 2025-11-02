import SwiftUI
import UIKit

struct NonAccessibleContainerTestDemoView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> NonAccessibleContainerTestViewController {
        return NonAccessibleContainerTestViewController()
    }

    func updateUIViewController(_ uiViewController: NonAccessibleContainerTestViewController, context: Context) {
        // 업데이트 로직 없음
    }
}
