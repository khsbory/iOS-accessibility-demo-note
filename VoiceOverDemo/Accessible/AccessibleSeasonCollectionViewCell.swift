import UIKit

class AccessibleSeasonCollectionViewCell: UICollectionViewCell {

    static let identifier = "AccessibleSeasonCollectionViewCell"

    // MARK: - Properties
    private var season: ExpandableItem?
    private var isExpanded = false

    // MARK: - UI Components
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 8
        view.isAccessibilityElement = true
        view.accessibilityTraits = .button
        return view
    }()

    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let itemsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        return stack
    }()

    private var stackHeightConstraint: NSLayoutConstraint?

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(headerView)
        headerView.addSubview(emojiLabel)
        headerView.addSubview(titleLabel)
        headerView.addSubview(chevronImageView)
        contentView.addSubview(itemsStackView)

        stackHeightConstraint = itemsStackView.heightAnchor.constraint(equalToConstant: 0)
        stackHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            headerView.heightAnchor.constraint(equalToConstant: 44),

            emojiLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            emojiLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 30),

            titleLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -8),

            chevronImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -12),
            chevronImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),

            itemsStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            itemsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            itemsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            itemsStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        headerView.addGestureRecognizer(tapGesture)
    }

    // MARK: - Configuration
    func configure(with season: ExpandableItem) {
        self.season = season
        self.isExpanded = false

        emojiLabel.text = season.emoji
        titleLabel.text = NSLocalizedString(season.title, comment: "")

        // Clear previous items
        itemsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        itemsStackView.isHidden = true
        stackHeightConstraint?.constant = 0

        updateChevron()
        updateAccessibility()
    }

    // MARK: - Actions
    @objc private func handleTap() {
        guard let season = season, let items = season.children, !items.isEmpty else { return }

        isExpanded.toggle()

        if isExpanded {
            // Add items to stack view
            for item in items {
                let itemView = createItemView(item: item)
                itemsStackView.addArrangedSubview(itemView)
            }
            itemsStackView.isHidden = false

            // Calculate height
            let itemHeight: CGFloat = 36
            let spacing = itemsStackView.spacing
            let totalHeight = CGFloat(items.count) * itemHeight + CGFloat(items.count - 1) * spacing
            stackHeightConstraint?.constant = totalHeight

            // 스택뷰 접근성 설정
            itemsStackView.accessibilityContainerType = .semanticGroup
            let seasonName = NSLocalizedString(season.title, comment: "")
            itemsStackView.accessibilityLabel = "\(seasonName) 목록"
        } else {
            // Remove items
            itemsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            itemsStackView.isHidden = true
            stackHeightConstraint?.constant = 0
        }

        updateChevron()
        updateAccessibility()

        // Notify collection view to update layout
        if let collectionView = superview as? UICollectionView {
            UIView.animate(withDuration: 0.3) {
                collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }

    private func createItemView(item: ExpandableItem) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.systemGray5
        container.layer.cornerRadius = 6

        let emojiLabel = UILabel()
        emojiLabel.text = item.emoji
        emojiLabel.font = .systemFont(ofSize: 20)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false

        let nameLabel = UILabel()
        nameLabel.text = NSLocalizedString(item.title, comment: "")
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        nameLabel.textColor = .label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(emojiLabel)
        container.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 36),

            emojiLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            emojiLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),

            nameLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12)
        ])

        return container
    }

    private func updateChevron() {
        UIView.animate(withDuration: 0.3) {
            self.chevronImageView.transform = self.isExpanded ?
                CGAffineTransform(rotationAngle: .pi) :
                CGAffineTransform.identity
        }
    }

    private func updateAccessibility() {
        // 접근성 레이블: 이모지 + 제목
        let label = "\(season?.emoji ?? "") \(NSLocalizedString(season?.title ?? "", comment: ""))"
        headerView.accessibilityLabel = label

        // 접근성 밸류: 확장/축소 상태
        if isExpanded {
            headerView.accessibilityValue = NSLocalizedString("expanded", comment: "확장됨")
        } else {
            headerView.accessibilityValue = NSLocalizedString("collapsed", comment: "축소됨")
        }
    }

    // MARK: - Layout
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        let targetSize = CGSize(width: layoutAttributes.frame.width, height: UIView.layoutFittingCompressedSize.height)
        let size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)

        attributes.frame.size.height = size.height
        return attributes
    }
}
