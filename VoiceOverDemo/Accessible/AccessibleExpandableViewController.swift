import UIKit

class AccessibleExpandableViewController: UIViewController {

    // MARK: - Properties
    private var rootItems: [ExpandableItem] = []
    private var flattenedItems: [ExpandableItem] = []
    private var isToggling = false  // 중복 호출 방지

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .systemBackground
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(AccessibleExpandableHeaderCell.self, forCellReuseIdentifier: AccessibleExpandableHeaderCell.identifier)
        table.register(AccessibleExpandableItemCell.self, forCellReuseIdentifier: AccessibleExpandableItemCell.identifier)
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
        rootItems = ExpandableDataProvider.createInitialData()
        rebuildFlattenedItems()
    }

    // MARK: - Data Management
    private func rebuildFlattenedItems() {
        flattenedItems = []
        for item in rootItems {
            appendItemAndChildren(item)
        }
        tableView.reloadData()
    }

    private func appendItemAndChildren(_ item: ExpandableItem) {
        flattenedItems.append(item)

        if item.isExpanded, let children = item.children {
            for child in children {
                appendItemAndChildren(child)
            }
        }
    }

    // MARK: - Toggle Logic
    private func toggleExpansion(at indexPath: IndexPath) {
        // 중복 호출 방지
        guard !isToggling else { return }
        isToggling = true

        let item = flattenedItems[indexPath.row]

        // 자식이 없으면 확장 불가
        guard let children = item.children, !children.isEmpty else {
            isToggling = false  // 플래그 초기화
            return
        }

        // rootItems에서 최신 상태 가져오기
        let currentExpandedState = getCurrentExpandedState(for: item)
        let newExpandedState = !currentExpandedState
        updateItemExpansionState(item: item, isExpanded: newExpandedState)

        if newExpandedState {
            // 확장: 자식들을 삽입
            let insertedIndices = insertChildren(of: item, afterIndex: indexPath.row)
            let insertedIndexPaths = insertedIndices.map { IndexPath(row: $0, section: 0) }

            tableView.performBatchUpdates({
                tableView.insertRows(at: insertedIndexPaths, with: .fade)
            }, completion: nil)

        } else {
            // 축소: 자식들의 확장 상태 초기화 및 제거
            collapseAllDescendants(of: item)

            let removedIndices = removeChildren(startingFrom: indexPath.row + 1)
            let removedIndexPaths = removedIndices.map { IndexPath(row: $0, section: 0) }

            tableView.performBatchUpdates({
                tableView.deleteRows(at: removedIndexPaths, with: .fade)
            }, completion: nil)
        }

        // 헤더 셀 업데이트 (chevron 회전)
        tableView.reloadRows(at: [indexPath], with: .none)

        // 애니메이션 완료 후 플래그 해제
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isToggling = false
        }
    }

    private func getCurrentExpandedState(for item: ExpandableItem) -> Bool {
        // rootItems에서 현재 확장 상태 가져오기
        for i in 0..<rootItems.count {
            if rootItems[i].id == item.id {
                return rootItems[i].isExpanded
            }

            // Level 1 (계절) 아이템 찾기
            if let children = rootItems[i].children {
                for j in 0..<children.count {
                    if children[j].id == item.id {
                        return children[j].isExpanded
                    }
                }
            }
        }
        return false
    }

    private func updateItemExpansionState(item: ExpandableItem, isExpanded: Bool) {
        // rootItems에서 아이템 찾아서 업데이트
        for i in 0..<rootItems.count {
            if rootItems[i].id == item.id {
                rootItems[i].isExpanded = isExpanded
                return
            }

            // Level 1 (계절) 아이템 찾기
            if let children = rootItems[i].children {
                for j in 0..<children.count {
                    if children[j].id == item.id {
                        rootItems[i].children?[j].isExpanded = isExpanded
                        return
                    }
                }
            }
        }
    }

    private func collapseAllDescendants(of item: ExpandableItem) {
        // rootItems에서 해당 아이템을 찾아 모든 자손의 확장 상태를 false로 설정
        for i in 0..<rootItems.count {
            if rootItems[i].id == item.id {
                // Level 0 아이템의 모든 자식(Level 1) 축소
                if var children = rootItems[i].children {
                    for j in 0..<children.count {
                        children[j].isExpanded = false
                        // Level 1의 모든 자식(Level 2)도 축소
                        if var grandchildren = children[j].children {
                            for k in 0..<grandchildren.count {
                                grandchildren[k].isExpanded = false
                            }
                            children[j].children = grandchildren
                        }
                    }
                    rootItems[i].children = children
                }
                return
            }

            // Level 1 (계절) 아이템의 자손 축소
            if var children = rootItems[i].children {
                for j in 0..<children.count {
                    if children[j].id == item.id {
                        // Level 1의 모든 자식(Level 2) 축소
                        if var grandchildren = children[j].children {
                            for k in 0..<grandchildren.count {
                                grandchildren[k].isExpanded = false
                            }
                            children[j].children = grandchildren
                        }
                        rootItems[i].children = children
                        return
                    }
                }
            }
        }
    }

    private func insertChildren(of item: ExpandableItem, afterIndex index: Int) -> [Int] {
        // rootItems에서 최신 children 데이터를 가져오기
        let freshChildren = getFreshChildren(for: item)
        guard let children = freshChildren, !children.isEmpty else { return [] }

        var insertedIndices: [Int] = []
        var currentIndex = index + 1

        for child in children {
            flattenedItems.insert(child, at: currentIndex)
            insertedIndices.append(currentIndex)
            currentIndex += 1
        }

        return insertedIndices
    }

    // rootItems에서 최신 children 데이터 가져오기
    private func getFreshChildren(for item: ExpandableItem) -> [ExpandableItem]? {
        // Level 0 아이템 찾기
        for rootItem in rootItems {
            if rootItem.id == item.id {
                return rootItem.children
            }

            // Level 1 아이템 찾기
            if let children = rootItem.children {
                for child in children {
                    if child.id == item.id {
                        return child.children
                    }
                }
            }
        }
        return nil
    }

    private func removeChildren(startingFrom startIndex: Int) -> [Int] {
        var removedIndices: [Int] = []
        let parentLevel = flattenedItems[startIndex - 1].level

        var currentIndex = startIndex

        // 다음 아이템이 자식인지 확인 (level이 더 큰 경우)
        while currentIndex < flattenedItems.count && flattenedItems[currentIndex].level > parentLevel {
            removedIndices.append(currentIndex)
            currentIndex += 1
        }

        // 역순으로 제거 (인덱스 유지를 위해)
        for index in removedIndices.reversed() {
            flattenedItems.remove(at: index)
        }

        return removedIndices
    }

    // MARK: - Item Selection
    private func handleItemSelection(_ item: ExpandableItem) {
        let localizedName = NSLocalizedString(item.title, comment: "")
        let message = "\(item.emoji) \(localizedName)"
        ToastView.show(message: message, in: self)
    }
}

// MARK: - UITableViewDataSource
extension AccessibleExpandableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flattenedItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = flattenedItems[indexPath.row]

        switch item.type {
        case .category, .season:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: AccessibleExpandableHeaderCell.identifier,
                for: indexPath
            ) as? AccessibleExpandableHeaderCell else {
                return UITableViewCell()
            }
            cell.configure(with: item, at: indexPath)
            cell.delegate = self
            return cell

        case .item:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: AccessibleExpandableItemCell.identifier,
                for: indexPath
            ) as? AccessibleExpandableItemCell else {
                return UITableViewCell()
            }
            cell.configure(with: item)
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension AccessibleExpandableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = flattenedItems[indexPath.row]
        return item.type == .item ? 56 : 52
    }

    // UI 테스트를 위한 didSelectRowAt 구현
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        toggleExpansion(at: indexPath)
    }
}

// MARK: - AccessibleExpandableHeaderCellDelegate
extension AccessibleExpandableViewController: AccessibleExpandableHeaderCellDelegate {
    func didTapHeader(at indexPath: IndexPath) {
        toggleExpansion(at: indexPath)
    }
}

// MARK: - AccessibleExpandableItemCellDelegate
extension AccessibleExpandableViewController: AccessibleExpandableItemCellDelegate {
    func didSelectItem(_ item: ExpandableItem) {
        handleItemSelection(item)
    }
}
