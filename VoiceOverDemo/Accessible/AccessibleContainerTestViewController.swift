import UIKit

class AccessibleContainerTestViewController: UIViewController {

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

        // 전체 스택뷰를 시맨틱 그룹으로 설정
        stackView.isAccessibilityElement = false
        stackView.accessibilityContainerType = .semanticGroup
        stackView.accessibilityLabel = "과일 채소 목록"
    }

    private func loadData() {
        categories = ContainerTestDataProvider.createTestData()

        for category in categories {
            let categoryView = createCategoryView(category: category)
            stackView.addArrangedSubview(categoryView)
        }

        // 동적으로 접근성 요소 설정 (서버에서 받아온 데이터처럼)
        stackView.accessibilityElements = stackView.arrangedSubviews
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

        // 접근성: 헤더뷰를 버튼으로 설정
        headerView.isAccessibilityElement = true
        headerView.accessibilityLabel = "\(category.emoji) \(NSLocalizedString(category.title, comment: ""))"
        headerView.accessibilityTraits = .button
        headerView.accessibilityValue = "축소됨"

        // Items Container
        let itemsContainer = UIView()
        itemsContainer.translatesAutoresizingMaskIntoConstraints = false
        itemsContainer.isHidden = true
        itemsContainer.tag = 1000 // Tag for identification

        // UIStackView 대신 UIView 사용
        let itemsInnerView = UIView()
        itemsInnerView.translatesAutoresizingMaskIntoConstraints = false

        var previousView: UIView?
        for (index, item) in category.items.enumerated() {
            // UIView로 감싸기
            let itemView = UIView()
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.backgroundColor = .systemGray5
            itemView.layer.cornerRadius = 8
            itemView.clipsToBounds = true

            let itemLabel = UILabel()
            itemLabel.text = item
            itemLabel.font = .systemFont(ofSize: 40)
            itemLabel.textAlignment = .center
            itemLabel.translatesAutoresizingMaskIntoConstraints = false

            itemView.addSubview(itemLabel)
            itemsInnerView.addSubview(itemView)

            NSLayoutConstraint.activate([
                itemLabel.centerXAnchor.constraint(equalTo: itemView.centerXAnchor),
                itemLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),

                itemView.topAnchor.constraint(equalTo: itemsInnerView.topAnchor),
                itemView.bottomAnchor.constraint(equalTo: itemsInnerView.bottomAnchor),
                itemView.widthAnchor.constraint(equalTo: itemsInnerView.widthAnchor, multiplier: 0.25, constant: -9)
            ])

            if let previous = previousView {
                itemView.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: 12).isActive = true
            } else {
                itemView.leadingAnchor.constraint(equalTo: itemsInnerView.leadingAnchor).isActive = true
            }

            if index == category.items.count - 1 {
                itemView.trailingAnchor.constraint(equalTo: itemsInnerView.trailingAnchor).isActive = true
            }

            previousView = itemView

            // 접근성 설정 - UIView를 접근성 요소로, 레이블은 UILabel에서 가져옴
            itemView.isAccessibilityElement = true
            itemView.accessibilityLabel = item
            itemView.accessibilityTraits = .button
        }

        itemsContainer.addSubview(itemsInnerView)

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

            itemsInnerView.topAnchor.constraint(equalTo: itemsContainer.topAnchor),
            itemsInnerView.leadingAnchor.constraint(equalTo: itemsContainer.leadingAnchor),
            itemsInnerView.trailingAnchor.constraint(equalTo: itemsContainer.trailingAnchor),
            itemsInnerView.bottomAnchor.constraint(equalTo: itemsContainer.bottomAnchor),
            itemsInnerView.heightAnchor.constraint(equalToConstant: 80)
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
            headerView.accessibilityValue = "축소됨"
            UIView.animate(withDuration: 0.3) {
                chevronImageView.transform = .identity
            }
        } else {
            // Expand
            expandedCategories.insert(category.id)
            itemsContainer.isHidden = false
            headerView.accessibilityValue = "확장됨"
            UIView.animate(withDuration: 0.3) {
                chevronImageView.transform = CGAffineTransform(rotationAngle: .pi / 2)
            }

            // 과일만 설정
            if category.id == "fruits" {
                // itemsInnerView에 시맨틱 그룹 컨테이너 설정
                if let itemsInnerView = itemsContainer.subviews.first {
                    // 시맨틱 그룹으로 컨테이너 타입 설정
                    itemsInnerView.accessibilityContainerType = .semanticGroup
                    itemsInnerView.accessibilityLabel = "과일 목록"

                    // 동적으로 접근성 요소 설정 (하위 UIView들)
                    itemsInnerView.accessibilityElements = itemsInnerView.subviews
                }
            }

            // VoiceOver 포커스 이동
            if UIAccessibility.isVoiceOverRunning {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIAccessibility.post(notification: .layoutChanged, argument: headerView)
                }
            }
        }
    }
}
