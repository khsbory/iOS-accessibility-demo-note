import UIKit

class AccessibleExpandableViewController: UIViewController {

    // MARK: - Properties
    private var categories: [ExpandableItem] = []

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .systemBackground
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 100
        table.register(AccessibleCategoryTableViewCell.self, forCellReuseIdentifier: AccessibleCategoryTableViewCell.identifier)
        return table
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupTableView()
        loadData()
    }

    // MARK: - Setup
    private func setupTableView() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadData() {
        categories = ExpandableDataProvider.createInitialData()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension AccessibleExpandableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AccessibleCategoryTableViewCell.identifier,
            for: indexPath
        ) as? AccessibleCategoryTableViewCell else {
            return UITableViewCell()
        }

        let category = categories[indexPath.row]
        cell.configure(with: category)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AccessibleExpandableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - AccessibleCategoryTableViewCellDelegate
extension AccessibleExpandableViewController: AccessibleCategoryTableViewCellDelegate {
    func categoryCell(_ cell: AccessibleCategoryTableViewCell, didUpdateHeight height: CGFloat) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
