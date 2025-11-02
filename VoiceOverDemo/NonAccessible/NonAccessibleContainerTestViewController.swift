import UIKit

class NonAccessibleContainerTestViewController: UIViewController {

    private var categories: [ContainerTestItem] = []
    private var expandedCategories = Set<String>()

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        loadData()
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }

    private func loadData() {
        categories = ContainerTestDataProvider.createTestData()

        for category in categories {
            let categoryView = createCategoryView(category: category)
            stackView.addArrangedSubview(categoryView)
        }
    }

    private func createCategoryView(category: ContainerTestItem) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        // Header
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .systemGray6
        headerView.layer.cornerRadius = 8

        let emojiLabel = UILabel()
        emojiLabel.text = category.emoji
        emojiLabel.font = .systemFont(ofSize: 28)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString(category.title, comment: "")
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let chevronImageView = UIImageView()
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .systemGray
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(emojiLabel)
        headerView.addSubview(titleLabel)
        headerView.addSubview(chevronImageView)

        // Items Container
        let itemsContainer = UIView()
        itemsContainer.translatesAutoresizingMaskIntoConstraints = false
        itemsContainer.isHidden = true
        itemsContainer.tag = 1000 // Tag for identification

        let itemsStack = UIStackView()
        itemsStack.axis = .horizontal
        itemsStack.spacing = 12
        itemsStack.distribution = .fillEqually
        itemsStack.translatesAutoresizingMaskIntoConstraints = false

        for item in category.items {
            let itemLabel = UILabel()
            itemLabel.text = item
            itemLabel.font = .systemFont(ofSize: 40)
            itemLabel.textAlignment = .center
            itemLabel.backgroundColor = .systemGray5
            itemLabel.layer.cornerRadius = 8
            itemLabel.clipsToBounds = true
            itemsStack.addArrangedSubview(itemLabel)
        }

        itemsContainer.addSubview(itemsStack)

        containerView.addSubview(headerView)
        containerView.addSubview(itemsContainer)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 56),

            emojiLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            emojiLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            chevronImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20),

            itemsContainer.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            itemsContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            itemsContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            itemsContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            itemsStack.topAnchor.constraint(equalTo: itemsContainer.topAnchor),
            itemsStack.leadingAnchor.constraint(equalTo: itemsContainer.leadingAnchor),
            itemsStack.trailingAnchor.constraint(equalTo: itemsContainer.trailingAnchor),
            itemsStack.bottomAnchor.constraint(equalTo: itemsContainer.bottomAnchor),
            itemsStack.heightAnchor.constraint(equalToConstant: 80)
        ])

        // Tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCategoryTap(_:)))
        headerView.addGestureRecognizer(tapGesture)
        headerView.tag = categories.firstIndex(where: { $0.id == category.id }) ?? 0

        return containerView
    }

    @objc private func handleCategoryTap(_ gesture: UITapGestureRecognizer) {
        guard let headerView = gesture.view,
              let containerView = headerView.superview,
              let itemsContainer = containerView.subviews.first(where: { $0.tag == 1000 }),
              let chevronImageView = headerView.subviews.compactMap({ $0 as? UIImageView }).first else {
            return
        }

        let index = headerView.tag
        let category = categories[index]

        if expandedCategories.contains(category.id) {
            // Collapse
            expandedCategories.remove(category.id)
            itemsContainer.isHidden = true
            UIView.animate(withDuration: 0.3) {
                chevronImageView.transform = .identity
            }
        } else {
            // Expand
            expandedCategories.insert(category.id)
            itemsContainer.isHidden = false
            UIView.animate(withDuration: 0.3) {
                chevronImageView.transform = CGAffineTransform(rotationAngle: .pi / 2)
            }
        }
    }
}
