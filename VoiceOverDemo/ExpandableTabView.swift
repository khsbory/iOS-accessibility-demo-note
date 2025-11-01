import SwiftUI

struct ExpandableTabView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        TabView {
            NonAccessibleExpandableDemoView()
                .tabItem {
                    Label(NSLocalizedString("tab.nonAccessible", comment: ""), systemImage: "xmark.circle")
                }
                .tag(0)

            AccessibleExpandableDemoView()
                .tabItem {
                    Label(NSLocalizedString("tab.accessible", comment: ""), systemImage: "checkmark.circle")
                }
                .tag(1)
        }
        .accessibilityLabel("탭 영역")
        .navigationTitle(NSLocalizedString("navigation.title.expandable", comment: ""))
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
    ExpandableTabView()
}
