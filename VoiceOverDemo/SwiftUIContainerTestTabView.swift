import SwiftUI

struct SwiftUIContainerTestTabView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        TabView {
            NonAccessibleSwiftUIContainerDemoView()
                .tabItem {
                    Label(NSLocalizedString("tab.nonAccessible", comment: ""), systemImage: "xmark.circle")
                }
                .tag(0)

            AccessibleSwiftUIContainerDemoView()
                .tabItem {
                    Label(NSLocalizedString("tab.accessible", comment: ""), systemImage: "checkmark.circle")
                }
                .tag(1)
        }
        .navigationTitle("SwiftUI 컨테이너 테스트")
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

#Preview {
    SwiftUIContainerTestTabView()
}
