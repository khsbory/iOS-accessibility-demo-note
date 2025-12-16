import SwiftUI

struct ContentView: View {
    @State private var showUIKitWebView = false
    @State private var showFocusTest = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: DemoTabView()) {
                    Text(NSLocalizedString("main.button.customScroll", comment: ""))
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(destination: RadioButtonTabView()) {
                    Text(NSLocalizedString("main.button.radioButton", comment: ""))
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(destination: ExpandableTabView()) {
                    Text(NSLocalizedString("main.button.expandable", comment: ""))
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(destination: WebViewDemoView()) {
                    Text(NSLocalizedString("main.button.webView", comment: ""))
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(
                    destination: UIKitWebViewWrapper(isPresented: $showUIKitWebView)
                        .modifier(HideNavigationBarModifier()),
                    isActive: $showUIKitWebView
                ) {
                    Text("웹뷰 테스트 (UIKit)")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(
                    destination: FocusTestViewControllerWrapper(isPresented: $showFocusTest)
                        .modifier(HideNavigationBarModifier()),
                    isActive: $showFocusTest
                ) {
                    Text("접근성 초점 테스트")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(destination: SwiftUIFocusTestView()) {
                    Text("SwiftUI 초점 테스트")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)


                NavigationLink(destination: ContainerTestTabView()) {
                    Text("접근성 컨테이너 테스트")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(destination: SwiftUIContainerTestTabView()) {
                    Text("SwiftUI 컨테이너 테스트")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(destination: SwiftUITableViewContainerTestTabView()) {
                    Text("SwiftUI 테이블뷰 컨테이너 테스트")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(destination: CustomTabBarView()) {
                    Text("커스텀 탭바")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.indigo)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle(NSLocalizedString("main.title", comment: ""))
        }
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
