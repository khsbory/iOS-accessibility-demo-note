import UIKit

class ProductListCell: UICollectionViewCell {
    static let identifier = "ProductListCell"
    
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
        sv.alignment = .leading
        return sv
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemGray
        button.backgroundColor = UIColor.white.withAlphaComponent(0.8) // Background for visibility
        button.layer.cornerRadius = 15 // Circular
        button.clipsToBounds = true
        return button
    }()
    
    // Callback
    var onLikeTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        self.isAccessibilityElement = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(productImageView)
        productImageView.addSubview(viewCountLabel) // Overlay
        
        contentView.addSubview(likeButton) // Overlay on image
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(originalPriceLabel)
        contentView.addSubview(discountLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(tagStackView)
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // Image (Top, Full Width, Aspect Ratio 1:1)
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            // View Count Overlay (Bottom of Image)
            viewCountLabel.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor),
            viewCountLabel.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor),
            viewCountLabel.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor),
            viewCountLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // Like Button (Top Right of Image)
            likeButton.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 8),
            likeButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -8),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Title (Below Image)
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            // Original Price
            originalPriceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            originalPriceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            // Discount & Price
            discountLabel.topAnchor.constraint(equalTo: originalPriceLabel.bottomAnchor, constant: 2),
            discountLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            priceLabel.centerYAnchor.constraint(equalTo: discountLabel.centerYAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: discountLabel.trailingAnchor, constant: 6),
            
            // Tags
            tagStackView.topAnchor.constraint(equalTo: discountLabel.bottomAnchor, constant: 8),
            tagStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tagStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc private func likeButtonTapped() {
        onLikeTapped?()
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
        let heartImage = product.isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likeButton.setImage(heartImage, for: .normal)
        likeButton.tintColor = product.isLiked ? .systemRed : .systemGray
    }
}
