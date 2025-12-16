import UIKit

class FocusTestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "초점 테스트"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .label
        label.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.7) // Semi-transparent to show overlap
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark.circle.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    private lazy var tabBarStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.backgroundColor = .secondarySystemBackground
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var numberTabButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Number", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: #selector(numberTabTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var alphabetTabButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Alphabet", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: #selector(alphabetTabTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    enum Tab {
        case number
        case alphabet
    }
    
    private var currentTab: Tab = .number {
        didSet {
            updateTabUI()
            tableView.reloadData()
        }
    }
    
    private let numberData: [String] = (1...26).map { "\($0)" }
    private let alphabetData: [String] = (0..<26).map { String(UnicodeScalar(65 + $0)!) }
    
    private var currentData: [String] {
        switch currentTab {
        case .number: return numberData
        case .alphabet: return alphabetData
        }
    }
    
    var dismissAction: (() -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        updateTabUI()
        
        // Define accessibility navigation order
        view.accessibilityElements = [titleLabel, closeButton, tableView, tabBarStackView]
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(tabBarStackView)
        
        tabBarStackView.addArrangedSubview(numberTabButton)
        tabBarStackView.addArrangedSubview(alphabetTabButton)
        
        NSLayoutConstraint.activate([
            // Close Button (Top Left)
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Tab Bar (Bottom)
            tabBarStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBarStackView.heightAnchor.constraint(equalToConstant: 60),
            
            // TableView (FullScreen, but sitting above TabBar)
            // Intentionally letting it go under the Title Label
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tabBarStackView.topAnchor),
            
            // Title Label
            // Overlapping the content. Positioned down slightly to overlap with the first few cells if scrolled up,
            // or effectively acting as a header that content scrolls behind.
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add some content inset to tableView so initial content isn't hidden by the title,
        // but as you scroll it goes BEHIND the title (overlap effect).
        tableView.contentInset = UIEdgeInsets(top: 120, left: 0, bottom: 0, right: 0)
    }
    
    private func updateTabUI() {
        switch currentTab {
        case .number:
            numberTabButton.tintColor = .systemBlue
            alphabetTabButton.tintColor = .systemGray
            numberTabButton.isSelected = true
            alphabetTabButton.isSelected = false
        case .alphabet:
            numberTabButton.tintColor = .systemGray
            alphabetTabButton.tintColor = .systemBlue
            numberTabButton.isSelected = false
            alphabetTabButton.isSelected = true
        }
    }
    
    // MARK: - Actions
    @objc private func closeTapped() {
        dismissAction?()
    }
    
    @objc private func numberTabTapped() {
        currentTab = .number
    }
    
    @objc private func alphabetTabTapped() {
        currentTab = .alphabet
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currentData[indexPath.row]
        return cell
    }
}
