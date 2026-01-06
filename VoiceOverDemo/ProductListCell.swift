import UIKit

class ProductListCell: UICollectionViewCell {
    static let identifier = "ProductListCell"
    
    // Callback for Like action
    var onLikeTapped: (() -> Void)?
    var isLiked: Bool = false
    
    // UI Components
    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        iv.image = UIImage(systemName: "photo")
        iv.tintColor = .systemGray4
        return iv
    }()
    
    private let viewCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()
    
    private let storeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        label.textColor = .label
        return label
    }()
    
    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let discountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(red: 3/255, green: 199/255, blue: 90/255, alpha: 1) // Naver Green
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let ratingStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 2
        sv.alignment = .center
        return sv
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let tagStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 4
        sv.distribution = .fillProportionally
        return sv
    }()
    
    private lazy var likeButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = .systemGray
        btn.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    // The Container to manage accessibility focus and labels
    private let mainContainer: OneFocusContainer = {
        let v = OneFocusContainer()
        v.translatesAutoresizingMaskIntoConstraints = false
        // Traits will be .button by default from OneFocusContainer.
        return v
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // We add mainContainer to contentView, and all other views to mainContainer
        contentView.addSubview(mainContainer)
        
        mainContainer.addSubview(productImageView)
        mainContainer.addSubview(viewCountLabel)
        mainContainer.addSubview(storeNameLabel)
        mainContainer.addSubview(titleLabel)
        mainContainer.addSubview(originalPriceLabel)
        mainContainer.addSubview(discountLabel)
        mainContainer.addSubview(priceLabel)
        mainContainer.addSubview(tagStackView)
        mainContainer.addSubview(ratingStackView)
        mainContainer.addSubview(likeButton)
        
        let starIcon = UIImageView(image: UIImage(systemName: "star.fill"))
        starIcon.tintColor = .systemOrange
        starIcon.translatesAutoresizingMaskIntoConstraints = false
        starIcon.widthAnchor.constraint(equalToConstant: 12).isActive = true
        starIcon.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        ratingStackView.addArrangedSubview(starIcon)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(reviewLabel)
        
        NSLayoutConstraint.activate([
            // Container fills the cell
            mainContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // Subviews constraints (relative to mainContainer)
            productImageView.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: mainContainer.widthAnchor),
            
            viewCountLabel.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: -6),
            viewCountLabel.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -6),
            viewCountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
            viewCountLabel.heightAnchor.constraint(equalToConstant: 18),
            
            likeButton.topAnchor.constraint(equalTo: mainContainer.topAnchor, constant: 8),
            likeButton.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -8),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
            
            storeNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            storeNameLabel.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 4),
            storeNameLabel.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -4),
            
            titleLabel.topAnchor.constraint(equalTo: storeNameLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -4),
            
            discountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            discountLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            priceLabel.centerYAnchor.constraint(equalTo: discountLabel.centerYAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: discountLabel.trailingAnchor, constant: 4),
            
            originalPriceLabel.topAnchor.constraint(equalTo: discountLabel.bottomAnchor, constant: 2),
            originalPriceLabel.leadingAnchor.constraint(equalTo: discountLabel.leadingAnchor),
            
            ratingStackView.topAnchor.constraint(equalTo: originalPriceLabel.bottomAnchor, constant: 4),
            ratingStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            tagStackView.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 6),
            tagStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tagStackView.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    @objc private func likeButtonTapped() {
        onLikeTapped?()
    }
    
    @objc private func accessibilityLikeAction() -> Bool {
        likeButtonTapped()
        return true
    }
    
    func configure(with product: Product) {
        storeNameLabel.text = product.storeName
        titleLabel.text = product.name
        
        // Original Price Strikethrough
        if let original = product.originalPrice {
            let attributedString = NSAttributedString(
                string: original,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            originalPriceLabel.attributedText = attributedString
            originalPriceLabel.isHidden = false
        } else {
            originalPriceLabel.isHidden = true
        }
        
        discountLabel.text = product.discountRate
        discountLabel.isHidden = product.discountRate == nil
        
        priceLabel.text = product.price
        
        ratingLabel.text = "\(product.rating)"
        reviewLabel.text = "(\(product.reviewCount))"
        
        // Accessibility Label Configuration for individual views (OneFocusContainer will aggregate these)
        storeNameLabel.accessibilityLabel = product.storeName
        titleLabel.accessibilityLabel = product.name
        
        if let discount = product.discountRate {
            discountLabel.accessibilityLabel = "할인율 \(discount)"
        } else {
            discountLabel.accessibilityLabel = nil
        }
        
        priceLabel.accessibilityLabel = "판매가 \(product.price)"
        
        if let original = product.originalPrice {
            originalPriceLabel.accessibilityLabel = "정상가 \(original)"
        } else {
            originalPriceLabel.accessibilityLabel = nil
        }
        
        ratingLabel.accessibilityLabel = "평점 \(product.rating)점"
        reviewLabel.accessibilityLabel = "리뷰 \(product.reviewCount)개"
        
        if let count = product.viewingCount {
            viewCountLabel.text = count
            viewCountLabel.isHidden = false
            viewCountLabel.accessibilityLabel = count
        } else {
            viewCountLabel.isHidden = true
            viewCountLabel.accessibilityLabel = nil
        }
        
        // Tags
        tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for tag in product.tags {
            let label = UILabel()
            label.text = " \(tag) "
            label.font = .systemFont(ofSize: 10, weight: .bold)
            if tag == "도착보장" || tag == "N Pay" {
                label.textColor = .white
                label.backgroundColor = UIColor(red: 3/255, green: 199/255, blue: 90/255, alpha: 1)
            } else {
                label.textColor = .systemGray
                label.backgroundColor = .systemGray6
            }
            label.layer.cornerRadius = 2
            label.clipsToBounds = true
            tagStackView.addArrangedSubview(label)
        }
        
        // Like Button
        self.isLiked = product.isLiked
        let heartImage = product.isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likeButton.setImage(heartImage, for: .normal)
        likeButton.tintColor = product.isLiked ? .systemRed : .systemGray
        
        // Custom Actions
        let actionName = product.isLiked ? "찜하기 취소" : "찜하기"
        mainContainer.accessibilityCustomActions = [
            UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(accessibilityLikeAction))
        ]
        
        // Ignore specific views from OneFocusContainer
        productImageView.accessibilityIdentifier = "a11y-ignore"
        likeButton.accessibilityIdentifier = "a11y-ignore"
        
        // Notify container to update label
        mainContainer.contentDidChange()
    }
}
