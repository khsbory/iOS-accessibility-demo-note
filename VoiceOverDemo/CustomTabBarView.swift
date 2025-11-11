import SwiftUI

struct CustomTabBarView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        CustomTabBarViewControllerRepresentable()
            .navigationTitle("커스텀 탭바")
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

struct CustomTabBarViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CustomTabBarViewController {
        return CustomTabBarViewController()
    }

    func updateUIViewController(_ uiViewController: CustomTabBarViewController, context: Context) {
        // No updates needed
    }
}

#Preview {
    NavigationView {
        CustomTabBarView()
    }
}
