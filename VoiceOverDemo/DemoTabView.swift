import SwiftUI

struct DemoTabView: View {
    var body: some View {
        TabView {
            NonAccessibleDemoView()
                .tabItem {
                    Label("미적용", systemImage: "xmark.circle")
                }

            AccessibleDemoView()
                .tabItem {
                    Label("적용", systemImage: "checkmark.circle")
                }
        }
        .navigationTitle("커스텀 가로 스크롤 데모")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DemoTabView()
}
