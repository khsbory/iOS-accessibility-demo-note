import SwiftUI

struct NonAccessibleSwiftUITableViewContainerDemoView: View {
    let fruits = ["사과", "바나나", "오렌지", "포도", "딸기"]
    let vegetables = ["당근", "브로콜리", "양파", "토마토", "오이"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // List (테이블뷰)
                List {
                    Section(header: Text("과일")) {
                        ForEach(fruits, id: \.self) { fruit in
                            HStack {
                                Image(systemName: "apple.logo")
                                    .foregroundColor(.red)
                                Text(fruit)
                            }
                        }
                    }

                    Section(header: Text("채소")) {
                        ForEach(vegetables, id: \.self) { vegetable in
                            HStack {
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(.green)
                                Text(vegetable)
                            }
                        }
                    }
                }
                .frame(height: 400)

                Divider()
                    .padding(.vertical)

                // LazyVGrid (그리드/콜렉션뷰)
                VStack(alignment: .leading, spacing: 10) {
                    Text("과일 채소 그리드")
                        .font(.headline)
                        .padding(.horizontal)

                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        // 과일
                        ForEach(fruits, id: \.self) { fruit in
                            VStack {
                                Image(systemName: "apple.logo")
                                    .font(.largeTitle)
                                    .foregroundColor(.red)
                                Text(fruit)
                                    .font(.caption)
                            }
                            .frame(width: 80, height: 80)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                        }

                        // 채소
                        ForEach(vegetables, id: \.self) { vegetable in
                            VStack {
                                Image(systemName: "leaf.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.green)
                                Text(vegetable)
                                    .font(.caption)
                            }
                            .frame(width: 80, height: 80)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("테이블뷰 컨테이너 테스트")
    }
}

#Preview {
    NonAccessibleSwiftUITableViewContainerDemoView()
}
