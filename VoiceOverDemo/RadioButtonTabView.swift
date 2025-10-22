import SwiftUI

struct RadioButtonTabView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        TabView {
            NonAccessibleRadioButtonDemoView()
                .tabItem {
                    Label(NSLocalizedString("tab.nonAccessible", comment: ""), systemImage: "xmark.circle")
                }
                .tag(0)

            AccessibleRadioButtonDemoView()
                .tabItem {
                    Label(NSLocalizedString("tab.accessible", comment: ""), systemImage: "checkmark.circle")
                }
                .tag(1)
        }
        .navigationTitle(NSLocalizedString("navigation.title.radioButton", comment: ""))
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
    RadioButtonTabView()
}
