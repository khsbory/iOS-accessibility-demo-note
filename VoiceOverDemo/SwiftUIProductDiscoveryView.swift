import SwiftUI

// UIKit의 Product 구조체와 호환되거나 유사한 구조체 정의
struct SwiftUIProduct: Identifiable {
    let id: UUID
    let name: String
    let price: String
    let originalPrice: String?
    let discountRate: String?
    let tags: [String]
    let viewingCount: String?
    let storeName: String
    let rating: Double
    let reviewCount: Int
    var isLiked: Bool
}

struct SwiftUIProductDiscoveryView: View {
    @State private var products: [SwiftUIProduct] = SampleProductData.load()
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach($products) { $product in
                    SwiftUIProductListCell(product: $product)
                }
            }
            .padding(16)
        }
        .navigationTitle("상품 탐색하기 (SwiftUI)")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemBackground))
    }
}

struct SwiftUIProductListCell: View {
    @Binding var product: SwiftUIProduct
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 이미지 영역
            ZStack(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .aspectRatio(1, contentMode: .fill)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray.opacity(0.4))
                    )
                
                if let viewCount = product.viewingCount {
                    Text(viewCount)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(4)
                        .padding(6)
                }
                
                // 찜하기 버튼
                Button(action: {
                    product.isLiked.toggle()
                }) {
                    Image(systemName: product.isLiked ? "heart.fill" : "heart")
                        .foregroundColor(product.isLiked ? .red : .gray)
                        .padding(8)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.storeName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(product.name)
                    .font(.system(size: 14))
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    if let discount = product.discountRate {
                        Text(discount)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 3/255, green: 199/255, blue: 90/255))
                    }
                    
                    Text(product.price)
                        .font(.system(size: 16, weight: .bold))
                }
                
                if let original = product.originalPrice {
                    Text(original)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .strikethrough()
                }
                
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.orange)
                    Text("\(String(format: "%.1f", product.rating))")
                        .font(.system(size: 12, weight: .medium))
                    Text("(\(product.reviewCount))")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 2)
                
                HStack(spacing: 4) {
                    ForEach(product.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(isGreenTag(tag) ? Color(red: 3/255, green: 199/255, blue: 90/255) : Color(UIColor.systemGray6))
                            .foregroundColor(isGreenTag(tag) ? .white : .secondary)
                            .cornerRadius(2)
                    }
                }
                .padding(.top, 4)
            }
            .padding(.top, 8)
            .padding(.horizontal, 4)
        }
    }
    
    private func isGreenTag(_ tag: String) -> Bool {
        return tag == "도착보장" || tag == "N Pay"
    }
}

struct SampleProductData {
    static func load() -> [SwiftUIProduct] {
        let sampleNames = [
            "삼성전자 스마트모니터 M7 80.1cm(32인치) 4K UHD",
            "로보락 S9 MaxV Ultra 로봇청소기",
            "LG전자 오브제컬렉션 냉장고 870L",
            "나이키 에어맥스 97 트리플화이트",
            "애플 아이패드 에어 5세대 Wi-Fi 64GB",
            "다이슨 에어랩 멀티 스타일러 컴플리트",
            "소니 노이즈캔슬링 헤드폰 WH-1000XM5",
            "스타벅스 아메리카노 Tall 모바일 쿠폰",
            "농심 신라면 120g x 20개입 (1박스)",
            "크리넥스 3겹 데코앤소프트 30m 30롤"
        ]
        
        let sampleStores = [
            "삼성공식판매처", "로보락코리아", "LG전자직영점", "나이키코리아", "애플스토어",
            "다이슨코리아", "소니코리아", "스타벅스코리아", "농심몰", "유한킴벌리"
        ]
        
        return (0..<10).map { i in
            SwiftUIProduct(
                id: UUID(),
                name: sampleNames[i],
                price: "\(50000 + i * 1000)원",
                originalPrice: "\(70000 + i * 1000)원",
                discountRate: "\(20 + i)%",
                tags: i % 2 == 0 ? ["도착보장", "N Pay"] : ["무료배송", "쿠폰"],
                viewingCount: "\(Int.random(in: 100...999))명 구경 함",
                storeName: sampleStores[i],
                rating: 4.8,
                reviewCount: 120 + i * 10,
                isLiked: false
            )
        }
    }
}

struct SwiftUIProductDiscoveryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SwiftUIProductDiscoveryView()
        }
    }
}
