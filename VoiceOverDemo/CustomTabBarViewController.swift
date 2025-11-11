import UIKit

class CustomTabBarViewController: UIViewController {

    // MARK: - Properties
    private var currentIndex: Int = 0

    private lazy var tabBarContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        // 상위 컨테이너: semantic group
        view.accessibilityContainerType = .semanticGroup
        view.accessibilityLabel = "커스텀 탭막대"

        return view
    }()

    private lazy var customTabBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false

        // 접근성 트레이트 탭바 설정
        view.accessibilityTraits = .tabBar

        return view
    }()

    private lazy var nonAccessibleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("미적용", for: .normal)
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 0
        button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)

        // 버튼 레이아웃 설정
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.imagePadding = 4
        button.configuration = config

        return button
    }()

    private lazy var accessibleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("적용", for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 1
        button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)

        // 버튼 레이아웃 설정
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.imagePadding = 4
        button.configuration = config

        return button
    }()

    private lazy var contentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nonAccessibleContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "미적용 화면"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        return view
    }()

    private lazy var accessibleContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true

        let label = UILabel()
        label.text = "적용 화면"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateTabSelection(index: 0)
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground

        // Add subviews
        view.addSubview(contentContainerView)
        view.addSubview(tabBarContainer)

        // tabBarContainer 안에 customTabBar 추가
        tabBarContainer.addSubview(customTabBar)

        contentContainerView.addSubview(nonAccessibleContentView)
        contentContainerView.addSubview(accessibleContentView)

        // 탭바 버튼 스택뷰
        let buttonStackView = UIStackView(arrangedSubviews: [nonAccessibleButton, accessibleButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        customTabBar.addSubview(buttonStackView)

        // Layout
        NSLayoutConstraint.activate([
            // Content container
            contentContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: tabBarContainer.topAnchor),

            // Tab bar container (상위 컨테이너)
            tabBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBarContainer.heightAnchor.constraint(equalToConstant: 60),

            // Custom tab bar (하위 탭바)
            customTabBar.topAnchor.constraint(equalTo: tabBarContainer.topAnchor),
            customTabBar.leadingAnchor.constraint(equalTo: tabBarContainer.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: tabBarContainer.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: tabBarContainer.bottomAnchor),

            // Button stack view
            buttonStackView.topAnchor.constraint(equalTo: customTabBar.topAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: customTabBar.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: customTabBar.trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: customTabBar.bottomAnchor),

            // Content views
            nonAccessibleContentView.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            nonAccessibleContentView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            nonAccessibleContentView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            nonAccessibleContentView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor),

            accessibleContentView.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            accessibleContentView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            accessibleContentView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            accessibleContentView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func tabButtonTapped(_ sender: UIButton) {
        updateTabSelection(index: sender.tag)
    }

    private func updateTabSelection(index: Int) {
        currentIndex = index

        // Update button states
        nonAccessibleButton.tintColor = index == 0 ? .systemRed : .systemGray
        accessibleButton.tintColor = index == 1 ? .systemGreen : .systemGray

        // Update accessibility traits - selected 트레이트 적용
        if index == 0 {
            nonAccessibleButton.accessibilityTraits = [.button, .selected]
            accessibleButton.accessibilityTraits = .button
        } else {
            nonAccessibleButton.accessibilityTraits = .button
            accessibleButton.accessibilityTraits = [.button, .selected]
        }

        // Update content visibility
        nonAccessibleContentView.isHidden = index != 0
        accessibleContentView.isHidden = index != 1
    }
}
