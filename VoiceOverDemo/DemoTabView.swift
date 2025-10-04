import SwiftUI

struct DemoTabView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        TabView {
            NonAccessibleDemoView()
                .tabItem {
                    Label("미적용", systemImage: "xmark.circle")
                }
                .tag(0)

            AccessibleDemoView()
                .tabItem {
                    Label("적용", systemImage: "checkmark.circle")
                }
                .tag(1)
        }
        .navigationTitle("커스텀 가로 스크롤 데모")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("뒤로")
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
    DemoTabView()
}
