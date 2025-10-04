import UIKit

class NonAccessibleViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(NonAccessibleTitleCell.self, forCellReuseIdentifier: NonAccessibleTitleCell.identifier)
        table.register(NonAccessibleHorizontalCell.self, forCellReuseIdentifier: NonAccessibleHorizontalCell.identifier)
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
extension NonAccessibleViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NonAccessibleTitleCell.identifier,
                for: indexPath
            ) as? NonAccessibleTitleCell else {
                return UITableViewCell()
            }
            cell.configure(with: "과일")
            cell.selectionStyle = .none
            return cell

        case 1:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NonAccessibleHorizontalCell.identifier,
                for: indexPath
            ) as? NonAccessibleHorizontalCell else {
                return UITableViewCell()
            }
            cell.configure(with: FoodData.fruits)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell

        case 2:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NonAccessibleTitleCell.identifier,
                for: indexPath
            ) as? NonAccessibleTitleCell else {
                return UITableViewCell()
            }
            cell.configure(with: "채소")
            cell.selectionStyle = .none
            return cell

        case 3:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NonAccessibleHorizontalCell.identifier,
                for: indexPath
            ) as? NonAccessibleHorizontalCell else {
                return UITableViewCell()
            }
            cell.configure(with: FoodData.vegetables)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell

        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension NonAccessibleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - NonAccessibleHorizontalCellDelegate
extension NonAccessibleViewController: NonAccessibleHorizontalCellDelegate {
    func didSelectItem(_ item: FoodItem) {
        let message = "\(item.emoji) \(item.name)을(를) 선택했습니다!"
        ToastView.show(message: message, in: self)
    }
}
