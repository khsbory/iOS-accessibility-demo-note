import UIKit

class AccessibilityElementTestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var dismissAction: (() -> Void)?
    
    // 섹션 타입 정의
    enum SectionType: String, CaseIterable {
        case train = "기차 좌석"
        case bus = "고속버스 좌석"
    }
    
    // 데이터 모델
    struct SeatItem {
        let id: String
        let sectionType: SectionType
        let seatNumber: String
        let description: String
        let isAvailable: Bool
        var isLiked: Bool = false
        
        var fullTitle: String {
            return "\(description) \(seatNumber)"
        }
    }
    
    struct SectionData {
        let type: SectionType
        var items: [SeatItem]
    }
    
    private var sections: [SectionData] = []
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(RichSeatCell.self, forCellReuseIdentifier: "RichSeatCell")
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 100
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupData()
        setupUI()
    }
    
    private func setupData() {
        // 기차 섹션 데이터 생성
        var trainItems: [SeatItem] = []
        for i in 1...10 {
            let row = (i + 1) / 2
            let col = (i % 2 == 0) ? "B" : "A"
            let isAvailable = (i % 3 != 0)
            
            let item = SeatItem(
                id: "T-\(i)",
                sectionType: .train,
                seatNumber: "\(row)\(col)",
                description: "1호차",
                isAvailable: isAvailable
            )
            trainItems.append(item)
        }
        sections.append(SectionData(type: .train, items: trainItems))
        
        // 고속버스 섹션 데이터 생성
        var busItems: [SeatItem] = []
        for i in 1...10 {
            let isPremium = i <= 5
            let typeString = isPremium ? "우등" : "일반"
            let isAvailable = (i % 4 != 0)
            
            let item = SeatItem(
                id: "B-\(i)",
                sectionType: .bus,
                seatNumber: "\(i)번",
                description: typeString,
                isAvailable: isAvailable
            )
            busItems.append(item)
        }
        sections.append(SectionData(type: .bus, items: busItems))
    }

    private func setupUI() {
        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = "좌석 예매"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Back Button
        let backButton = UIButton(type: .system)
        backButton.setTitle("초기화면", for: .normal)
        backButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            // Header Area
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // TableView
            tableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func handleBackButton() {
        dismissAction?()
    }
    
    // 토스트 메시지 표시
    func showToast(message: String) {
        ToastView.show(message: message, in: self)
    }
    
    // MARK: - TableView DataSource & Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].type.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RichSeatCell", for: indexPath) as? RichSeatCell else {
            return UITableViewCell()
        }
        
        let item = sections[indexPath.section].items[indexPath.row]
        cell.configure(item: item)
        
        cell.likeAction = { [weak self] in
            guard let self = self else { return }
            self.sections[indexPath.section].items[indexPath.row].isLiked.toggle()
            let newItem = self.sections[indexPath.section].items[indexPath.row]
            
            // UI 업데이트
            if let visibleCell = tableView.cellForRow(at: indexPath) as? RichSeatCell {
                visibleCell.configure(item: newItem)
            }
            
            let status = newItem.isLiked ? "찜했습니다." : "찜하기 취소했습니다."
            self.showToast(message: "\(newItem.fullTitle) \(status)")
        }
        
        // 좌석 선택 액션 (컨테이너 뷰 탭)
        cell.seatSelectAction = { [weak self] in
            guard let self = self else { return }
            let item = self.sections[indexPath.section].items[indexPath.row]
            let status = item.isAvailable ? "선택되었습니다." : "매진된 좌석입니다."
            let prefix = (item.sectionType == .train) ? "(기차)" : "(버스)"
            
            self.showToast(message: "\(prefix) \(item.fullTitle) \(status)")
            
            // --- 초점 이동 로직 ---
            let targetSection = (indexPath.section == 0) ? 1 : 0
            let targetIndexPath = IndexPath(row: indexPath.row, section: targetSection)
            
            if targetSection < self.sections.count, indexPath.row < self.sections[targetSection].items.count {
                tableView.scrollToRow(at: targetIndexPath, at: .none, animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    if let targetCell = tableView.cellForRow(at: targetIndexPath) as? RichSeatCell {
                        // 변경: 셀 자체가 아닌 containerView로 포커스 이동
                        UIAccessibility.post(notification: .layoutChanged, argument: targetCell.containerView)
                    }
                }
            }
        }
        
        return cell
    }
    
    // 셀 선택 처리 (기존 로직 제거)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 컨테이너 뷰가 터치 이벤트를 가로채므로 여기는 호출되지 않을 수 있음
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - Custom Rich Cell
class RichSeatCell: UITableViewCell {
    
    var likeAction: (() -> Void)?
    var seatSelectAction: (() -> Void)? // 좌석 선택 액션
    
    // 컨테이너 뷰 (접근성 포커스 이동을 위해 internal로 변경)
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.tertiarySystemFill.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    // 찜하기 컨테이너 뷰
    private let likeContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()

    // 찜하기 뷰 (텍스트 라벨)
    private let likeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.isUserInteractionEnabled = false // 컨테이너가 제스처 처리
        return label
    }()
    
    // 좌석 번호
    private let seatNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .heavy)
        label.textColor = .label
        return label
    }()
    
    // 설명
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // 상태 뱃지
    private let statusBadge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animate(withDuration: 0.1) {
            if highlighted {
                self.containerView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
                self.containerView.backgroundColor = .systemFill
            } else {
                self.containerView.transform = .identity
                self.containerView.backgroundColor = .secondarySystemGroupedBackground
            }
        }
    }
    
    private func setupCellUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        
        // 계층 구조 변경: likeLabel을 likeContainerView에 넣음
        containerView.addSubview(likeContainerView)
        likeContainerView.addSubview(likeLabel)
        
        containerView.addSubview(statusBadge)
        
        let textStack = UIStackView(arrangedSubviews: [descriptionLabel, seatNumberLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.alignment = .leading
        textStack.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textStack)
        
        // 컨테이너 뷰 액션 추가
        let containerTap = UITapGestureRecognizer(target: self, action: #selector(handleSeatTap))
        containerView.addGestureRecognizer(containerTap)
        containerView.isUserInteractionEnabled = true
        
        // 찜하기 제스처를 likeContainerView에 추가
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleLikeTap))
        likeContainerView.addGestureRecognizer(likeTap)
        
        // 접근성 설정 (버튼 트레이트 제거됨)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Like Container Constraints
            likeContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            likeContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            likeContainerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            likeContainerView.heightAnchor.constraint(equalToConstant: 44),
            
            // Like Label Constraints (Center in Container)
            likeLabel.centerXAnchor.constraint(equalTo: likeContainerView.centerXAnchor),
            likeLabel.centerYAnchor.constraint(equalTo: likeContainerView.centerYAnchor),
            
            textStack.leadingAnchor.constraint(equalTo: likeContainerView.trailingAnchor, constant: 8),
            textStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            textStack.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 16),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16),
            
            statusBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            statusBadge.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            statusBadge.leadingAnchor.constraint(greaterThanOrEqualTo: textStack.trailingAnchor, constant: 16),
            statusBadge.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configure(item: AccessibilityElementTestViewController.SeatItem) {
        seatNumberLabel.text = item.seatNumber
        descriptionLabel.text = item.description
        
        // 찜 상태에 따라 텍스트 변경
        likeLabel.text = item.isLiked ? "찜하기 취소" : "찜하기"
        
        // 찜 상태에 따라 텍스트 변경
        likeLabel.text = item.isLiked ? "찜하기 취소" : "찜하기"
        
        // 찜 상태에 따라 텍스트 변경
        likeLabel.text = item.isLiked ? "찜하기 취소" : "찜하기"
        
        // 1. 찜하기 요소 버튼 트레이트 추가
        likeLabel.accessibilityTraits = .button
        
        // 2. 좌석 정보 버튼 설정
        containerView.accessibilityTraits = .none
        
        var seatAccessibilityLabel = "\(item.description), \(item.seatNumber)"
        
        if item.isAvailable {
            statusBadge.text = "예매 가능"
            statusBadge.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.15)
            statusBadge.textColor = .systemBlue
            statusBadge.accessibilityLabel = "예매 가능"
            seatAccessibilityLabel += ", 예매 가능"
            
            containerView.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.3).cgColor
            seatNumberLabel.textColor = .label
        } else {
            statusBadge.text = "매진"
            statusBadge.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
            statusBadge.textColor = .systemGray
            statusBadge.accessibilityLabel = "매진"
            seatAccessibilityLabel += ", 안타깝게도 매진"
            
            containerView.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.2).cgColor
            seatNumberLabel.textColor = .secondaryLabel
        }
        
        // 3. 부모 셀 설정: 버튼 트레이트 유지, 명시적 라벨 제거, 엘리먼트 설정 삭제(기본값 사용)
        self.accessibilityTraits = .button
        self.accessibilityLabel = nil 
        
        // 4. 접근성 요소 순서 지정 제거
        self.accessibilityElements = nil
    }
    
    @objc private func handleLikeTap() {
        likeAction?()
    }
    
    @objc private func handleSeatTap() {
        seatSelectAction?()
    }
}
