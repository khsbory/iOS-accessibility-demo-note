import SwiftUI

struct AccessibleSwiftUIContainerDemoView: View {
    @State private var isFruitsExpanded = false
    @State private var isVegetablesExpanded = false

    let fruits = ["사과", "바나나", "오렌지", "포도", "딸기"]
    let vegetables = ["당근", "브로콜리", "양파", "토마토", "오이"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 과일 섹션
                VStack(alignment: .leading, spacing: 10) {
                    // 헤더
                    HStack {
                        Text("과일")
                            .font(.title2)
                            .fontWeight(.bold)

                        Spacer()

                        Button(action: {
                            isFruitsExpanded.toggle()
                        }) {
                            Image(systemName: isFruitsExpanded ? "chevron.up" : "chevron.down")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                        .accessibilityLabel("과일")
                        .accessibilityValue(isFruitsExpanded ? "확장됨" : "축소됨")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)

                    // 과일 항목들
                    if isFruitsExpanded {
                        HStack(spacing: 15) {
                            ForEach(fruits, id: \.self) { fruit in
                                VStack {
                                    Image(systemName: "apple.logo")
                                        .font(.largeTitle)
                                        .foregroundColor(.red)
                                        .accessibilityHidden(true)
                                    Text(fruit)
                                        .font(.caption)
                                }
                                .frame(width: 60)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .accessibilityElement(children: .contain)
                        .accessibilityLabel("과일 목록")
                    }
                }
                .padding(.horizontal)

                // 채소 섹션
                VStack(alignment: .leading, spacing: 10) {
                    // 헤더
                    HStack {
                        Text("채소")
                            .font(.title2)
                            .fontWeight(.bold)

                        Spacer()

                        Button(action: {
                            isVegetablesExpanded.toggle()
                        }) {
                            Image(systemName: isVegetablesExpanded ? "chevron.up" : "chevron.down")
                                .font(.title3)
                                .foregroundColor(.green)
                        }
                        .accessibilityLabel("채소")
                        .accessibilityValue(isVegetablesExpanded ? "확장됨" : "축소됨")
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)

                    // 채소 항목들
                    if isVegetablesExpanded {
                        HStack(spacing: 15) {
                            ForEach(vegetables, id: \.self) { vegetable in
                                VStack {
                                    Image(systemName: "leaf.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.green)
                                        .accessibilityHidden(true)
                                    Text(vegetable)
                                        .font(.caption)
                                }
                                .frame(width: 60)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 20)
            .accessibilityElement(children: .contain)
            .accessibilityLabel("과일 채소 목록")
        }
    }
}

#Preview {
    AccessibleSwiftUIContainerDemoView()
}
