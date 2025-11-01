import UIKit

protocol AccessibleExpandableHeaderCellDelegate: AnyObject {
    func didTapHeader(at indexPath: IndexPath)
}

class AccessibleExpandableHeaderCell: UITableViewCell {

    static let identifier = "AccessibleExpandableHeaderCell"

    weak var delegate: AccessibleExpandableHeaderCellDelegate?
    private var indexPath: IndexPath?

    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        label.font = .systemFont(ofSize: 17, weight: .semibold)
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

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        backgroundColor = .systemBackground
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(emojiLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(chevronImageView)
        contentView.addSubview(separatorView)

        leadingConstraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
            leadingConstraint!,

            emojiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 36),

            titleLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -8),

            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20),

            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tapGesture)
    }

    // MARK: - Configuration
    func configure(with item: ExpandableItem, at indexPath: IndexPath) {
        self.indexPath = indexPath

        emojiLabel.text = item.emoji
        titleLabel.text = NSLocalizedString(item.title, comment: "")

        // 레벨에 따른 인덴트
        let indentAmount: CGFloat = CGFloat(item.level) * 24 + 16
        leadingConstraint?.constant = indentAmount

        // 레벨에 따른 배경색 (미묘한 차이)
        switch item.level {
        case 0:
            containerView.backgroundColor = .clear
            titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        case 1:
            containerView.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.5)
            titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        default:
            containerView.backgroundColor = .clear
            titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        }

        // Chevron 회전 애니메이션
        updateChevronRotation(isExpanded: item.isExpanded)

        // 높이 설정
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: item.level == 0 ? 56 : 48).isActive = true
    }

    private func updateChevronRotation(isExpanded: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            let angle: CGFloat = isExpanded ? .pi / 2 : 0
            self.chevronImageView.transform = CGAffineTransform(rotationAngle: angle)
        }
    }

    // MARK: - Actions
    @objc private func handleTap() {
        guard let indexPath = indexPath else { return }

        // 시각적 피드백
        UIView.animate(withDuration: 0.1, animations: {
            self.containerView.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.containerView.alpha = 1.0
            }
        }

        // delegate 호출 복원 - 실제 사용자를 위해
        delegate?.didTapHeader(at: indexPath)
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        indexPath = nil
        emojiLabel.text = nil
        titleLabel.text = nil
        chevronImageView.transform = .identity
        leadingConstraint?.constant = 16
    }
}
