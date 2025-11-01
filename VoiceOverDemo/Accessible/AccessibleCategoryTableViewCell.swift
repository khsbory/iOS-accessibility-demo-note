import UIKit

protocol AccessibleCategoryTableViewCellDelegate: AnyObject {
    func categoryCell(_ cell: AccessibleCategoryTableViewCell, didUpdateHeight height: CGFloat)
}

class AccessibleCategoryTableViewCell: UITableViewCell {

    static let identifier = "AccessibleCategoryTableViewCell"

    weak var delegate: AccessibleCategoryTableViewCellDelegate?

    // MARK: - Properties
    private var category: ExpandableItem?
    private var isExpanded = false
    private var collectionViewHeightConstraint: NSLayoutConstraint?

    // MARK: - UI Components
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.isAccessibilityElement = true
        view.accessibilityTraits = .button
        return view
    }()

    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.estimatedItemSize = CGSize(width: 200, height: 100)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(AccessibleSeasonCollectionViewCell.self, forCellWithReuseIdentifier: AccessibleSeasonCollectionViewCell.identifier)
        cv.isHidden = true
        return cv
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .systemBackground

        contentView.addSubview(headerView)
        headerView.addSubview(emojiLabel)
        headerView.addSubview(titleLabel)
        headerView.addSubview(chevronImageView)
        contentView.addSubview(collectionView)
        contentView.addSubview(separatorView)

        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 56),

            emojiLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 36),

            titleLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -8),

            chevronImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            chevronImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20),

            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            separatorView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeaderTap))
        headerView.addGestureRecognizer(tapGesture)
    }

    // MARK: - Configuration
    func configure(with category: ExpandableItem) {
        self.category = category
        self.isExpanded = false

        emojiLabel.text = category.emoji
        titleLabel.text = NSLocalizedString(category.title, comment: "")

        // 콜렉션뷰 접근성 레이블 설정
        let categoryName = NSLocalizedString(category.title, comment: "")
        collectionView.accessibilityLabel = "\(categoryName) 계절 목록"

        collectionView.isHidden = true
        collectionViewHeightConstraint?.constant = 0
        updateChevron()
        updateAccessibility()
    }

    // MARK: - Actions
    @objc private func handleHeaderTap() {
        print("🔵 AccessibleCategoryTableViewCell handleHeaderTap - isExpanded: \(isExpanded)")
        guard let category = category, let seasons = category.children, !seasons.isEmpty else {
            print("❌ No category or seasons found")
            return
        }

        print("✅ Category: \(category.title), Seasons count: \(seasons.count)")

        isExpanded.toggle()

        if isExpanded {
            // Show collection view
            collectionView.isHidden = false
            collectionView.reloadData()

            print("📊 CollectionView items: \(collectionView.numberOfItems(inSection: 0))")

            // Calculate initial height
            calculateCollectionViewHeight()

            // 접근성 엘리먼트를 헤더뷰와 콜렉션뷰로 변경
            accessibilityElements = [headerView, collectionView]
        } else {
            // Hide collection view
            UIView.animate(withDuration: 0.3) {
                self.collectionViewHeightConstraint?.constant = 0
                self.contentView.layoutIfNeeded()
            } completion: { _ in
                self.collectionView.isHidden = true
            }

            accessibilityElements = nil
        }

        updateChevron()
        updateAccessibility()

        // Notify table view to update layout
        if let tableView = superview as? UITableView {
            print("🔄 Updating table view layout")
            UIView.animate(withDuration: 0.3) {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
    }

    private func calculateCollectionViewHeight() {
        // Default height for horizontal scrolling CollectionView
        let defaultHeight: CGFloat = 120
        collectionViewHeightConstraint?.constant = defaultHeight

        print("📏 Setting CollectionView height to: \(defaultHeight)")

        UIView.animate(withDuration: 0.3) {
            self.contentView.layoutIfNeeded()
        }
    }

    private func updateChevron() {
        UIView.animate(withDuration: 0.3) {
            let angle: CGFloat = self.isExpanded ? .pi / 2 : 0
            self.chevronImageView.transform = CGAffineTransform(rotationAngle: angle)
        }
    }

    private func updateAccessibility() {
        // 접근성 레이블: 카테고리 제목
        let label = "\(category?.emoji ?? "") \(NSLocalizedString(category?.title ?? "", comment: ""))"
        headerView.accessibilityLabel = label

        // 접근성 밸류: 확장/축소 상태
        if isExpanded {
            headerView.accessibilityValue = NSLocalizedString("expanded", comment: "확장됨")
        } else {
            headerView.accessibilityValue = NSLocalizedString("collapsed", comment: "축소됨")
        }
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        isExpanded = false
        category = nil
        collectionView.isHidden = true
        collectionViewHeightConstraint?.constant = 0
        chevronImageView.transform = .identity
        accessibilityElements = nil
    }
}

// MARK: - UICollectionViewDataSource
extension AccessibleCategoryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category?.children?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AccessibleSeasonCollectionViewCell.identifier,
            for: indexPath
        ) as? AccessibleSeasonCollectionViewCell,
              let seasons = category?.children else {
            return UICollectionViewCell()
        }

        let season = seasons[indexPath.item]
        cell.configure(with: season)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AccessibleCategoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return estimated size - actual size will be calculated by cell
        return CGSize(width: 200, height: 100)
    }
}
