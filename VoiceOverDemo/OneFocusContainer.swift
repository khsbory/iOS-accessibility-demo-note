import UIKit

/// 상위 요소 하나만 포커스되도록 만들고,
/// 하위 자식들의 텍스트/레이블을 자동 집계하여 상위 accessibilityLabel에 넣는 컨테이너.
/// - 접근성 Traits 기본값: .button
/// - 범용 유틸(집계/시그니처) 포함
final class OneFocusContainer: UIView {
    
    // MARK: - Tunables (팀 컨벤션에 맞춰 조정)
    private let throttleInterval: CFTimeInterval = 0.10
    private let separator: String = ", "
    private let ignoreMarker: String = "a11y-ignore"  // 정확 일치 or 접두사로만 인식
    private let minAlphaVisible: CGFloat = 0.01
    
    // MARK: - Statics for Optimization
    /// 정규식 객체를 매번 생성하지 않도록 static 상수로 캐싱
    private static let spaceRegex: NSRegularExpression? = try? NSRegularExpression(pattern: "\\s+")
    
    // MARK: - State
    private var cachedLabel: String = ""
    private var lastUpdateTime: CFTimeInterval = 0
    private var contentSignature: Int = 0
    
    // 선택/토글 상태를 반영하고 싶은 경우 공개 API로 노출
    var isToggled: Bool = false {
        didSet { updateTraits() }
    }
    var isSelectedForA11y: Bool = false {
        didSet { updateTraits() }
    }
    
    // MARK: - Lifecycle
    override func didMoveToWindow() {
        super.didMoveToWindow()
        // 상위만 포커스
        isAccessibilityElement = true
        updateTraits()
        rebuildAccessibilityIfNeeded(force: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rebuildAccessibilityIfNeeded()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Dynamic Type/Size Category 변화 등으로 레이아웃/텍스트가 달라질 수 있음
        rebuildAccessibilityIfNeeded()
    }
    
    // 공개 훅: 내부 텍스트/상태가 바뀌었을 때 호출
    func contentDidChange() {
        rebuildAccessibilityIfNeeded(force: true)
    }
    
    // MARK: - Core
    private func updateTraits() {
        // 기본 버튼 트레잇 + 선택/토글 상태를 반영
        var t: UIAccessibilityTraits = [.button]
        if isToggled { t.insert(.selected) }
        if isSelectedForA11y { t.insert(.selected) }
        accessibilityTraits = t
    }
    
    private func rebuildAccessibilityIfNeeded(force: Bool = false) {
        guard window != nil else { return }  // 오프스크린이면 스킵
        
        // 메인 스레드 보장
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in self?.rebuildAccessibilityIfNeeded(force: force) }
            return
        }
        
        // 변경 감지(레이아웃/가시성/텍스트) 시그니처
        let sig = calculateContentSignature()
        if !force, sig == contentSignature {
            // 내용이 안 바뀌었으면 스로틀만 적용하고 종료
            let now = CFAbsoluteTimeGetCurrent()
            guard now - lastUpdateTime > throttleInterval else { return }
            lastUpdateTime = now
            return
        }
        
        // 스로틀: 계산 자체를 제한
        let now = CFAbsoluteTimeGetCurrent()
        guard force || (now - lastUpdateTime > throttleInterval) else { return }
        lastUpdateTime = now
        
        contentSignature = sig
        let newLabel = Self.aggregateA11yText(in: self,
                                                separator: separator,
                                                ignoreMarker: ignoreMarker,
                                                minAlpha: minAlphaVisible)
        guard newLabel != cachedLabel else { return }
        
        cachedLabel = newLabel
        accessibilityLabel = newLabel
        
        // 필요 시: accessibilityHint / accessibilityCustomContent 추가 가능
    }
    
    // MARK: - Signature (텍스트+가시성+프레임 기반)
    private func calculateContentSignature() -> Int {
        var hasher = Hasher()
        func walk(_ v: UIView) {
            hasher.combine(ObjectIdentifier(type(of: v)))
            hasher.combine(v.isHidden)
            hasher.combine(v.alpha)
            if let id = v.accessibilityIdentifier { hasher.combine(id) }
            
            let f = v.convert(v.bounds, to: self)
            hasher.combine(f.origin.x)
            hasher.combine(f.origin.y)
            hasher.combine(f.size.width)
            hasher.combine(f.size.height)
            
            if let text = Self.extractText(from: v) { hasher.combine(text) }
            v.subviews.forEach(walk)
        }
        subviews.forEach(walk)
        return hasher.finalize()
    }
    
    // MARK: - Aggregation Utility (범용)
    /// 하위 자식들의 텍스트/레이블을 화면 순서(위→아래, 좌→우)로 집계
    static func aggregateA11yText(
        in root: UIView,
        separator: String = ", ",
        ignoreMarker: String = "a11y-ignore",
        minAlpha: CGFloat = 0.01
    ) -> String {
        guard !root.subviews.isEmpty else { return "" }
        
        var bag: [(CGPoint, String)] = []
        bag.reserveCapacity(root.subviews.count * 2)
        
        func shouldIgnore(_ v: UIView) -> Bool {
            guard let id = v.accessibilityIdentifier else { return false }
            // 팀 컨벤션: 정확 일치 또는 접두사로만 무시
            return id == ignoreMarker || id.hasPrefix(ignoreMarker + ".")
        }
        
        func grab(_ v: UIView, container: UIView) {
            if v.isHidden || v.alpha < minAlpha { return }
            if shouldIgnore(v) { return }
            
            if let t = extractText(from: v)?
                .trimmingCharacters(in: .whitespacesAndNewlines),
               !t.isEmpty
            {
                let p = v.convert(v.bounds, to: container).origin
                bag.append((p, t))
            }
            v.subviews.forEach { grab($0, container: container) }
        }
        
        root.subviews.forEach { grab($0, container: root) }
        
        // 화면 순서 정렬(위→아래, 좌→우)
        bag.sort { (a, b) in
            if abs(a.0.y - b.0.y) > 1 { return a.0.y < b.0.y }
            return a.0.x < b.0.x
        }
        
        // 1. 텍스트 추출 및 정제
        let rawTexts = bag.map { normalizeSpaces($0.1) }
            .filter { !$0.isEmpty }
        
        // 2. 포함 관계 기반 중복 제거 (Dedup Logic Upgrade)
        // "50,000"이 "가격 50,000"에 포함되면 제거
        var uniqueTexts: [String] = []
        
        for text in rawTexts {
            // 현재 텍스트가 다른 텍스트에 포함되어 있는지 검사 (자신은 제외)
            let isContained = rawTexts.contains { other in
                return other != text && other.contains(text)
            }
            
            // 어디에도 포함되지 않는 '고유한' 정보이거나 가장 긴 정보라면 추가
            if !isContained {
                // 완전히 동일한 중복이 있을 수 있으므로 한 번 더 체크
                if !uniqueTexts.contains(text) {
                    uniqueTexts.append(text)
                }
            }
        }
        
        return uniqueTexts.joined(separator: separator)
    }
    
    /// 개별 뷰에서 접근성 텍스트 추출(우선순위 일관)
    static func extractText(from v: UIView) -> String? {
        if let attr = v.accessibilityAttributedLabel, attr.length > 0 { return attr.string }
        if let l = v.accessibilityLabel, !l.isEmpty { return l }
        if let val = v.accessibilityValue, !val.isEmpty { return val }
        switch v {
        case let lbl as UILabel: return lbl.text
        case let btn as UIButton: return (btn.accessibilityLabel?.isEmpty == false) ? btn.accessibilityLabel : btn.title(for: .normal)
        case let tf as UITextField: return tf.accessibilityLabel ?? tf.text
        case let tv as UITextView: return tv.text
        default: return nil
        }
    }
    
    private static func normalizeSpaces(_ s: String) -> String {
        guard let regex = spaceRegex else { return s }
        let range = NSRange(location: 0, length: s.utf16.count)
        return regex.stringByReplacingMatches(in: s, options: [], range: range, withTemplate: " ")
    }
    
    // MARK: - (선택) 디버깅 도구
    #if DEBUG
    func debugAccessibilityInfo() {
        print("=== OneFocusContainer Debug ===")
        print("Cached Label: \(cachedLabel)")
        let live = Self.aggregateA11yText(in: self, separator: separator, ignoreMarker: ignoreMarker, minAlpha: minAlphaVisible)
        print("Live Label: \(live)")
        print("Subviews: \(subviews.count)")
        print("Signature: \(contentSignature)")
    }
    #endif
}
