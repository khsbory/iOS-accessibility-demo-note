import UIKit

struct Product {
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

class ProductDiscoveryViewController: UIViewController {
    
    private var products: [Product] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .systemBackground
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "상품 탐색하기"
        self.view.backgroundColor = .systemBackground
        
        setupData()
        setupUI()
    }
    
    private func setupData() {
        // Rich Dummy Data
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
            "삼성공식판매처",
            "로보락코리아",
            "LG전자직영점",
            "나이키코리아",
            "애플스토어",
            "다이슨코리아",
            "소니코리아",
            "스타벅스코리아",
            "농심몰",
            "유한킴벌리"
        ]
        
        for i in 0..<10 {
            let original = (i + 1) * 50000
            let discount = Int.random(in: 10...40)
            let finalPrice = original * (100 - discount) / 100
            
            products.append(Product(
                id: UUID(),
                name: sampleNames[i],
                price: formatCurrency(finalPrice),
                originalPrice: formatCurrency(original),
                discountRate: "\(discount)%",
                tags: i % 2 == 0 ? ["도착보장", "N Pay"] : ["무료배송", "쿠폰"],
                viewingCount: "\(Int.random(in: 100...9999))명 구경 함",
                storeName: sampleStores[i],
                rating: Double.random(in: 4.0...5.0).rounded(toPlaces: 1),
                reviewCount: Int.random(in: 50...5000),
                isLiked: false
            ))
        }
    }
    
    private func formatCurrency(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return (formatter.string(from: NSNumber(value: value)) ?? "0") + "원"
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductListCell.self, forCellWithReuseIdentifier: ProductListCell.identifier)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func toggleLike(at indexPath: IndexPath) {
        products[indexPath.item].isLiked.toggle()
        let isLiked = products[indexPath.item].isLiked
        
        // Reload specific item to update UI
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [indexPath])
        }
        
        // Show Toast
        let message = isLiked ? "관심상품에 추가되었습니다." : "관심상품에서 삭제되었습니다."
        ToastView.show(message: message, in: self)
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension ProductDiscoveryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCell.identifier, for: indexPath) as? ProductListCell else {
            return UICollectionViewCell()
        }
        
        let product = products[indexPath.item]
        cell.configure(with: product)
        
        // 찜하기 버튼 동작
        cell.onLikeTapped = { [weak self] in
            self?.toggleLike(at: indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.item]
        let message = "\(product.name) 상품을 선택했습니다."
        ToastView.show(message: message, in: self)
    }
    
    // Grid Layout Calculation
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2 items per row with 16pt margin and 10pt space
        // Width = (Screen - 16 - 16 - 10) / 2
        let totalSpacing: CGFloat = 16 + 16 + 10
        let width = (collectionView.bounds.width - totalSpacing) / 2
        
        // Height Calculation: Image (Width) + Title (~40) + Price info (~60) + Tags (~20) + Padding
        // Rough estimate + aspect ratio
        return CGSize(width: width, height: width + 140)
    }
}
