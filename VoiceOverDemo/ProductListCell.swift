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
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .systemRed
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .label
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
        mainContainer.addSubview(titleLabel)
        mainContainer.addSubview(originalPriceLabel)
        mainContainer.addSubview(discountLabel)
        mainContainer.addSubview(priceLabel)
        mainContainer.addSubview(tagStackView)
        mainContainer.addSubview(likeButton)
        
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
            
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -4),
            
            discountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            discountLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            priceLabel.centerYAnchor.constraint(equalTo: discountLabel.centerYAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: discountLabel.trailingAnchor, constant: 4),
            
            originalPriceLabel.centerYAnchor.constraint(equalTo: discountLabel.centerYAnchor),
            originalPriceLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 4),
            
            tagStackView.topAnchor.constraint(equalTo: discountLabel.bottomAnchor, constant: 8),
            tagStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tagStackView.heightAnchor.constraint(equalToConstant: 20)
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
        
        // Accessibility Label Configuration
        var priceA11yLabel = ""
        if let original = product.originalPrice {
            priceA11yLabel += "정상가 \(original), "
        }
        if let discount = product.discountRate {
            priceA11yLabel += "할인율 \(discount), "
        }
        priceA11yLabel += "판매가 \(product.price)"
        priceLabel.accessibilityLabel = priceA11yLabel
        
        if let count = product.viewingCount {
            viewCountLabel.text = count
            viewCountLabel.isHidden = false
        } else {
            viewCountLabel.isHidden = true
        }
        
        // Tags
        tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for tag in product.tags {
            let label = UILabel()
            label.text = " \(tag) "
            label.font = .systemFont(ofSize: 10)
            label.textColor = .systemGray
            label.backgroundColor = .systemGray6
            label.layer.cornerRadius = 4
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
