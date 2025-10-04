import UIKit

enum TableSection: Int, CaseIterable {
    case fruitTitle = 0
    case fruitItems = 1
    case vegetableTitle = 2
    case vegetableItems = 3
}

class CustomScrollDemoViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        table.register(HorizontalScrollTableViewCell.self, forCellReuseIdentifier: HorizontalScrollTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension CustomScrollDemoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TableSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        switch section {
        case .fruitTitle:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TitleTableViewCell.identifier,
                for: indexPath
            ) as? TitleTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: "과일")
            cell.selectionStyle = .none
            return cell

        case .fruitItems:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: HorizontalScrollTableViewCell.identifier,
                for: indexPath
            ) as? HorizontalScrollTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: FoodData.fruits)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell

        case .vegetableTitle:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TitleTableViewCell.identifier,
                for: indexPath
            ) as? TitleTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: "채소")
            cell.selectionStyle = .none
            return cell

        case .vegetableItems:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: HorizontalScrollTableViewCell.identifier,
                for: indexPath
            ) as? HorizontalScrollTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: FoodData.vegetables)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension CustomScrollDemoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - HorizontalScrollTableViewCellDelegate
extension CustomScrollDemoViewController: HorizontalScrollTableViewCellDelegate {
    func didSelectItem(_ item: FoodItem) {
        let message = "\(item.emoji) \(item.name)을(를) 선택했습니다!"
        ToastView.show(message: message, in: self)
    }
}
