import UIKit

protocol AccessibleExpandableItemCellDelegate: AnyObject {
    func didSelectItem(_ item: ExpandableItem)
}

class AccessibleExpandableItemCell: UITableViewCell {

    static let identifier = "AccessibleExpandableItemCell"

    weak var delegate: AccessibleExpandableItemCellDelegate?
    private var item: ExpandableItem?

    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6.withAlphaComponent(0.3)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
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
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Properties
    private var leadingConstraint: NSLayoutConstraint?

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
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(emojiLabel)
        containerView.addSubview(titleLabel)

        leadingConstraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 64)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            leadingConstraint!,
            containerView.heightAnchor.constraint(equalToConstant: 48),

            emojiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            emojiLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 32),

            titleLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false  // didSelectRowAt도 호출되도록 허용
        containerView.addGestureRecognizer(tapGesture)
    }

    // MARK: - Configuration
    func configure(with item: ExpandableItem) {
        self.item = item

        emojiLabel.text = item.emoji
        titleLabel.text = NSLocalizedString(item.title, comment: "")

        // 레벨에 따른 인덴트 (level 2는 더 깊게)
        let indentAmount: CGFloat = CGFloat(item.level) * 24 + 16
        leadingConstraint?.constant = indentAmount
    }

    // MARK: - Actions
    @objc private func handleTap() {
        guard let item = item else { return }

        // 시각적 피드백
        UIView.animate(withDuration: 0.1, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.containerView.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.containerView.transform = .identity
                self.containerView.backgroundColor = .systemGray6.withAlphaComponent(0.3)
            }
        }

        delegate?.didSelectItem(item)
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        item = nil
        emojiLabel.text = nil
        titleLabel.text = nil
        leadingConstraint?.constant = 64
        containerView.transform = .identity
    }
}
