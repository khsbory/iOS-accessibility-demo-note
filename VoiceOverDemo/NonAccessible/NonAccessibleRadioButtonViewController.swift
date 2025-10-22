import UIKit

class NonAccessibleRadioButtonViewController: UIViewController {

    // MARK: - Properties
    private var selectedGender: String?
    private var selectedFruit: String?

    private var genderButtons: [UIButton] = []
    private var fruitButtons: [UIButton] = []

    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("demo.radioButton.title", comment: "")
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        // 접근성 미적용

        return label
    }()

    // 성별 라디오 그룹
    private lazy var genderGroupContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        // 접근성 미적용 - accessibilityContainerType 설정 안함

        return container
    }()

    private lazy var genderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("radioGroup.gender.title", comment: "")
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false

        // 접근성 미적용

        return label
    }()

    // 좋아하는 과일 라디오 그룹
    private lazy var fruitGroupContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        // 접근성 미적용 - accessibilityContainerType 설정 안함

        return container
    }()

    private lazy var fruitTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("radioGroup.fruit.title", comment: "")
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false

        // 접근성 미적용

        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupUI()
        createGenderRadioButtons()
        createFruitRadioButtons()
    }

    // MARK: - Setup
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(genderTitleLabel)
        contentView.addSubview(genderGroupContainer)
        contentView.addSubview(fruitTitleLabel)
        contentView.addSubview(fruitGroupContainer)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            genderTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            genderTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genderTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            genderGroupContainer.topAnchor.constraint(equalTo: genderTitleLabel.bottomAnchor, constant: 16),
            genderGroupContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genderGroupContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            fruitTitleLabel.topAnchor.constraint(equalTo: genderGroupContainer.bottomAnchor, constant: 40),
            fruitTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            fruitTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            fruitGroupContainer.topAnchor.constraint(equalTo: fruitTitleLabel.bottomAnchor, constant: 16),
            fruitGroupContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            fruitGroupContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            fruitGroupContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }

    private func createGenderRadioButtons() {
        let genders = [
            NSLocalizedString("radioButton.male", comment: ""),
            NSLocalizedString("radioButton.female", comment: "")
        ]

        var previousButton: UIButton?

        for (index, gender) in genders.enumerated() {
            let button = createRadioButton(title: gender, tag: index)
            button.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
            genderButtons.append(button)
            genderGroupContainer.addSubview(button)

            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: genderGroupContainer.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: genderGroupContainer.trailingAnchor),
                button.heightAnchor.constraint(equalToConstant: 50)
            ])

            if let previous = previousButton {
                button.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 12).isActive = true
            } else {
                button.topAnchor.constraint(equalTo: genderGroupContainer.topAnchor).isActive = true
            }

            previousButton = button
        }

        if let lastButton = previousButton {
            lastButton.bottomAnchor.constraint(equalTo: genderGroupContainer.bottomAnchor).isActive = true
        }
    }

    private func createFruitRadioButtons() {
        let fruits = [
            NSLocalizedString("radioButton.apple", comment: ""),
            NSLocalizedString("radioButton.banana", comment: ""),
            NSLocalizedString("radioButton.orange", comment: ""),
            NSLocalizedString("radioButton.grape", comment: "")
        ]

        var previousButton: UIButton?

        for (index, fruit) in fruits.enumerated() {
            let button = createRadioButton(title: fruit, tag: index)
            button.addTarget(self, action: #selector(fruitButtonTapped(_:)), for: .touchUpInside)
            fruitButtons.append(button)
            fruitGroupContainer.addSubview(button)

            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: fruitGroupContainer.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: fruitGroupContainer.trailingAnchor),
                button.heightAnchor.constraint(equalToConstant: 50)
            ])

            if let previous = previousButton {
                button.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 12).isActive = true
            } else {
                button.topAnchor.constraint(equalTo: fruitGroupContainer.topAnchor).isActive = true
            }

            previousButton = button
        }

        if let lastButton = previousButton {
            lastButton.bottomAnchor.constraint(equalTo: fruitGroupContainer.bottomAnchor).isActive = true
        }
    }

    private func createRadioButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.backgroundColor = .systemBackground
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = tag

        // 접근성 미적용

        return button
    }

    // MARK: - Actions
    @objc private func genderButtonTapped(_ sender: UIButton) {
        // 모든 성별 버튼의 선택 상태 해제
        for button in genderButtons {
            updateButtonAppearance(button, isSelected: false)
            // 접근성 미적용 - selected trait 제거 안함
        }

        // 선택된 버튼의 상태 업데이트
        updateButtonAppearance(sender, isSelected: true)
        // 접근성 미적용 - selected trait 추가 안함

        selectedGender = sender.titleLabel?.text

        // 접근성 미적용 - VoiceOver 알림 안함
    }

    @objc private func fruitButtonTapped(_ sender: UIButton) {
        // 모든 과일 버튼의 선택 상태 해제
        for button in fruitButtons {
            updateButtonAppearance(button, isSelected: false)
            // 접근성 미적용 - selected trait 제거 안함
        }

        // 선택된 버튼의 상태 업데이트
        updateButtonAppearance(sender, isSelected: true)
        // 접근성 미적용 - selected trait 추가 안함

        selectedFruit = sender.titleLabel?.text

        // 접근성 미적용 - VoiceOver 알림 안함
    }

    private func updateButtonAppearance(_ button: UIButton, isSelected: Bool) {
        if isSelected {
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.layer.borderColor = UIColor.systemBlue.cgColor
        } else {
            button.backgroundColor = .systemBackground
            button.setTitleColor(.label, for: .normal)
            button.layer.borderColor = UIColor.systemGray4.cgColor
        }
    }
}
