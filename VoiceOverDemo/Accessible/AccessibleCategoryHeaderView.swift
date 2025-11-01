import UIKit

protocol AccessibleCategoryHeaderViewDelegate: AnyObject {
    func headerView(_ headerView: AccessibleCategoryHeaderView, didTapSection section: Int)
}

class AccessibleCategoryHeaderView: UITableViewHeaderFooterView {

    static let identifier = "AccessibleCategoryHeaderView"

    weak var delegate: AccessibleCategoryHeaderViewDelegate?
    var section: Int = 0
    private var isExpanded = false

    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
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

    // MARK: - Initialization
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(emojiLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(chevronImageView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 56),

            emojiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 36),

            titleLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -8),

            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerView.addGestureRecognizer(tapGesture)
    }

    // MARK: - Configuration
    func configure(with category: ExpandableItem, section: Int, isExpanded: Bool) {
        self.section = section
        self.isExpanded = isExpanded

        emojiLabel.text = category.emoji
        titleLabel.text = NSLocalizedString(category.title, comment: "")

        updateChevron()
    }

    // MARK: - Actions
    @objc private func handleTap() {
        delegate?.headerView(self, didTapSection: section)
    }

    private func updateChevron() {
        UIView.animate(withDuration: 0.3) {
            let angle: CGFloat = self.isExpanded ? .pi / 2 : 0
            self.chevronImageView.transform = CGAffineTransform(rotationAngle: angle)
        }
    }

    func setExpanded(_ expanded: Bool, animated: Bool) {
        self.isExpanded = expanded
        if animated {
            updateChevron()
        } else {
            let angle: CGFloat = expanded ? .pi / 2 : 0
            chevronImageView.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
}
