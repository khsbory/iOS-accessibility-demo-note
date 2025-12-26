# SwiftUI VoiceOver 초점 복귀 가이드 (Focus Restoration)

이 문서는 SwiftUI에서 메인 화면에서 상세 화면으로 이동했다가 다시 돌아왔을 때, **VoiceOver 초점을 원래 눌렀던 요소(버튼)로 정확하게 되돌리는 방법**을 설명합니다.

## 📌 개요 (Problem & Solution)

- **문제점**: `NavigationLink`를 타고 들어갔다가 나오면, 때때로 VoiceOver 초점이 리스트의 맨 위로 튀거나 엉뚱한 곳으로 가는 초점 유실 현상이 발생합니다. 특히 커스텀 버튼이나 복잡한 뷰 계층 구조에서 빈번합니다.
- **해결책**:
    1.  각 버튼에 고유 **ID**를 부여합니다.
    2.  네비게이션이 시작되는 순간을 포착하여 **ID를 저장**합니다.
    3.  화면이 다시 나타나면(`onAppear`), **약간의 지연 시간(Delay) 후** 저장된 ID로 초점을 강제로 이동시킵니다.

---

## 🛠 구현 방법

### 1단계: 식별자(ID) 및 상태 변수 정의

각 UI 요소를 구분할 ID 타입(Enum 권장)과, 상태를 저장할 변수를 선언합니다.

```swift
struct MyView: View {
    // 1. 초점을 맞출 대상을 식별하는 ID
    enum ItemID: Hashable {
        case itemA
        case itemB
        case itemC
    }
    
    // 2. 마지막으로 누른 버튼의 ID를 기억할 저장소
    @State private var lastFocusedID: ItemID?
    
    // 3. 실제 VoiceOver 초점을 제어할 상태 변수
    @AccessibilityFocusState private var focus: ItemID?
    
    // ...
}
```

### 2단계: 네비게이션 상태 가로채기 (핵심!)

`simultaneousGesture`(탭 제스처)를 사용하는 방법은 터치 영역 문제로 씹힐 수 있습니다.
가장 확실한 방법은 **`NavigationLink`의 `isActive` 바인딩을 커스텀하여 상태 변경 시점을 가로채는 것**입니다.

```swift
// 바인딩을 생성하는 헬퍼 함수
private func binding(for id: ItemID, destinationIsActive: Binding<Bool>) -> Binding<Bool> {
    Binding(
        get: { destinationIsActive.wrappedValue },
        set: { newValue in
            if newValue {
                // ✅ 화면이 넘어가려는 순간(true), ID를 저장합니다.
                lastFocusedID = id
            }
            // 원래 상태 변수 업데이트
            destinationIsActive.wrappedValue = newValue
        }
    )
}
```

### 3단계: 뷰에 적용하기

`NavigationLink`와 뷰에 위에서 만든 장치들을 연결합니다.

```swift
NavigationLink(
    destination: DetailView(),
    isActive: binding(for: .itemA, destinationIsActive: $showItemA) // 커스텀 바인딩 사용
) {
    Text("A 화면으로 이동")
}
.accessibilityFocused($focus, equals: .itemA) // ✅ VoiceOver 초점 연결
```

### 4단계: 화면 복귀 시 초점 복구

`onAppear`에서 약간의 딜레이를 두고 초점을 다시 맞춥니다. 딜레이가 없으면 화면 전환 애니메이션 중에 초점 요청이 무시될 수 있습니다.

```swift
.onAppear {
    // 저장된 ID가 있다면 복구 시도
    if let lastID = lastFocusedID {
        // 0.5초 ~ 1.0초 정도 딜레이 권장 (애니메이션 시간 고려)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            focus = lastID
        }
    }
}
```

---

## ✅ 요약

1.  **`@AccessibilityFocusState`** 선언
2.  **`lastFocusedID`** 저장 변수 선언
3.  **`Binding<Bool>`** 의 `set` 클로저에서 네비게이션 진입 시 `lastFocusedID` 저장
4.  **`onAppear`** + **`asyncAfter`** 로 복귀 시 초점 강제 이동

이 패턴을 사용하면 사용자가 "뒤로" 버튼을 눌러 돌아왔을 때, 맥락을 잃지 않고 바로 다음 탐색을 이어갈 수 있어 접근성이 크게 향상됩니다.
