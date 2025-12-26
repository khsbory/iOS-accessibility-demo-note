import SwiftUI

struct ContentView: View {
    @State private var showUIKitWebView = false
    @State private var showFocusTest = false
    @State private var selection: DemoID? // 일반 아이템용 선택 상태
    
    // 포커스 복귀를 위한 상태 변수들
    @State private var lastFocusedID: DemoID?
    @AccessibilityFocusState private var focus: DemoID?

    // 메뉴 아이템 식별자
    enum DemoID: Hashable {
        case customScroll
        case radioButton
        case expandable
        case webView
        case webViewUIKit
        case focusTest
        case swiftUIFocusTest
        case containerTest
        case swiftUIContainerTest
        case swiftUITableViewContainerTest
        case customTabBar
    }
    
    // 메뉴 아이템 데이터 구조체
    struct DemoItem: Identifiable {
        let id: DemoID
        let title: String
        let color: Color
        let destination: AnyView
    }
    
    // 메뉴 아이템 목록 생성
    var items: [DemoItem] {
        [
            DemoItem(id: .customScroll,
                     title: NSLocalizedString("main.button.customScroll", comment: ""),
                     color: .blue,
                     destination: AnyView(DemoTabView())),
            DemoItem(id: .radioButton,
                     title: NSLocalizedString("main.button.radioButton", comment: ""),
                     color: .green,
                     destination: AnyView(RadioButtonTabView())),
            DemoItem(id: .expandable,
                     title: NSLocalizedString("main.button.expandable", comment: ""),
                     color: .purple,
                     destination: AnyView(ExpandableTabView())),
            DemoItem(id: .webView,
                     title: NSLocalizedString("main.button.webView", comment: ""),
                     color: .orange,
                     destination: AnyView(WebViewDemoView())),
            DemoItem(id: .webViewUIKit,
                     title: "웹뷰 테스트 (UIKit)",
                     color: .cyan,
                     destination: AnyView(
                        UIKitWebViewWrapper(isPresented: $showUIKitWebView)
                            .modifier(HideNavigationBarModifier())
                     )),
            DemoItem(id: .focusTest,
                     title: "접근성 초점 테스트",
                     color: .orange,
                     destination: AnyView(
                        FocusTestViewControllerWrapper(isPresented: $showFocusTest)
                            .modifier(HideNavigationBarModifier())
                     )),
            DemoItem(id: .swiftUIFocusTest,
                     title: "SwiftUI 초점 테스트",
                     color: .blue,
                     destination: AnyView(SwiftUIFocusTestView())),
            DemoItem(id: .containerTest,
                     title: "접근성 컨테이너 테스트",
                     color: .red,
                     destination: AnyView(ContainerTestTabView())),
            DemoItem(id: .swiftUIContainerTest,
                     title: "SwiftUI 컨테이너 테스트",
                     color: .pink,
                     destination: AnyView(SwiftUIContainerTestTabView())),
            DemoItem(id: .swiftUITableViewContainerTest,
                     title: "SwiftUI 테이블뷰 컨테이너 테스트",
                     color: .teal,
                     destination: AnyView(SwiftUITableViewContainerTestTabView())),
            DemoItem(id: .customTabBar,
                     title: "커스텀 탭바",
                     color: .indigo,
                     destination: AnyView(CustomTabBarView()))
        ]
    }
    
    // 커스텀 바인딩 생성 함수
    // NavigationLink가 활성화될 때를 가로채서 ID를 저장합니다.
    private func binding(for item: DemoItem) -> Binding<Bool> {
        Binding(
            get: {
                if item.id == .webViewUIKit { return showUIKitWebView }
                if item.id == .focusTest { return showFocusTest }
                return selection == item.id
            },
            set: { newValue in
                if newValue {
                    // 화면 진입 시점: ID 저장
                    lastFocusedID = item.id
                    
                    if item.id == .webViewUIKit { showUIKitWebView = true }
                    else if item.id == .focusTest { showFocusTest = true }
                    else { selection = item.id }
                } else {
                    // 화면 복귀 시점
                    if item.id == .webViewUIKit { showUIKitWebView = false }
                    else if item.id == .focusTest { showFocusTest = false }
                    else { selection = nil }
                }
            }
        )
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(items) { item in
                        // 모든 NavigationLink에 isActive 적용 (커스텀 바인딩 사용)
                        NavigationLink(
                            destination: item.destination,
                            isActive: binding(for: item)
                        ) {
                            textButton(for: item)
                        }
                        .accessibilityFocused($focus, equals: item.id)
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            .navigationTitle(NSLocalizedString("main.title", comment: ""))
            .onAppear {
                checkAndRestoreFocus()
            }
        }
    }
    
    private func checkAndRestoreFocus() {
        if let lastID = lastFocusedID {
            // 화면 복귀 시 1초 후 마지막으로 눌렀던 버튼으로 초점 이동
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                focus = lastID
            }
        }
    }
    
    // 버튼 UI
    private func textButton(for item: DemoItem) -> some View {
        Text(item.title)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(item.color)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct UIKitWebViewWrapper: UIViewControllerRepresentable {
    @Binding var isPresented: Bool

    func makeCoordinator() -> Coordinator {
        return Coordinator(isPresented: $isPresented)
    }

    func makeUIViewController(context: Context) -> WebViewController {
        let webVC = WebViewController()
        webVC.dismissAction = {
            context.coordinator.dismiss()
        }

        return webVC
    }

    func updateUIViewController(_ uiViewController: WebViewController, context: Context) {
        // 업데이트 필요 없음
    }

    class Coordinator {
        var isPresented: Binding<Bool>

        init(isPresented: Binding<Bool>) {
            self.isPresented = isPresented
        }

        func dismiss() {
            isPresented.wrappedValue = false
        }
    }
}

struct HideNavigationBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    }
}

struct FocusTestViewControllerWrapper: UIViewControllerRepresentable {
    @Binding var isPresented: Bool

    func makeCoordinator() -> Coordinator {
        return Coordinator(isPresented: $isPresented)
    }

    func makeUIViewController(context: Context) -> FocusTestViewController {
        let vc = FocusTestViewController()
        vc.dismissAction = {
            context.coordinator.dismiss()
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: FocusTestViewController, context: Context) {
        // No update needed
    }

    class Coordinator {
        var isPresented: Binding<Bool>

        init(isPresented: Binding<Bool>) {
            self.isPresented = isPresented
        }

        func dismiss() {
            isPresented.wrappedValue = false
        }
    }
}

#Preview {
    ContentView()
}
