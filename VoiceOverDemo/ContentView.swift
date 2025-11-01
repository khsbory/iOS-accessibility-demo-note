import SwiftUI

struct ContentView: View {
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

                Spacer()
            }
            .navigationTitle(NSLocalizedString("main.title", comment: ""))
        }
    }
}

#Preview {
    ContentView()
}
