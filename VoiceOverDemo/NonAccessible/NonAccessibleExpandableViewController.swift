import UIKit

class NonAccessibleExpandableViewController: UIViewController {

    // MARK: - Properties
    private var categories: [ExpandableItem] = []
    private var expandedSections = Set<Int>()

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .systemBackground
        table.translatesAutoresizingMaskIntoConstraints = false
        table.sectionHeaderHeight = UITableView.automaticDimension
        table.estimatedSectionHeaderHeight = 56
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 136
        table.register(CollectionViewContainerCell.self, forCellReuseIdentifier: CollectionViewContainerCell.identifier)
        table.register(CategoryHeaderView.self, forHeaderFooterViewReuseIdentifier: CategoryHeaderView.identifier)
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
extension NonAccessibleExpandableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expandedSections.contains(section) ? 1 : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CollectionViewContainerCell.identifier,
            for: indexPath
        ) as? CollectionViewContainerCell else {
            return UITableViewCell()
        }

        let category = categories[indexPath.section]
        cell.configure(with: category)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: CategoryHeaderView.identifier
        ) as? CategoryHeaderView else {
            return nil
        }

        let category = categories[section]
        let isExpanded = expandedSections.contains(section)
        headerView.configure(with: category, section: section, isExpanded: isExpanded)
        headerView.delegate = self
        return headerView
    }
}

// MARK: - UITableViewDelegate
extension NonAccessibleExpandableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

// MARK: - CategoryHeaderViewDelegate
extension NonAccessibleExpandableViewController: CategoryHeaderViewDelegate {
    func headerView(_ headerView: CategoryHeaderView, didTapSection section: Int) {
        let indexPath = IndexPath(row: 0, section: section)

        if expandedSections.contains(section) {
            // Collapse
            expandedSections.remove(section)
            tableView.deleteRows(at: [indexPath], with: .fade)
            headerView.setExpanded(false, animated: true)
        } else {
            // Expand
            expandedSections.insert(section)
            tableView.insertRows(at: [indexPath], with: .fade)
            headerView.setExpanded(true, animated: true)
        }
    }
}
