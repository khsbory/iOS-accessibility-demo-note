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


---

## 📌 심화: 리스트(List) 아이템 전체에 초점 맞추기

단순 버튼이 아니라, 여러 텍스트와 이미지가 섞인 **복잡한 리스트 행(Row)** 자체를 버튼처럼 동작하게 하고 초점을 복구하는 방법입니다.

### 1. 컨테이너를 하나의 요소로 만들기
`.accessibilityElement(children: .combine)`을 사용하여 내부 요소들을 하나로 묶고, 행 전체에 초점 식별자를 부여합니다.

```swift
struct PostRowView: View {
    let post: Post
    
    var body: some View {
        VStack {
            Text(post.title)
            Text(post.content)
        }
        // ✅ 1. VoiceOver가 내부 자식들을 따로 읽지 않고 덩어리로 인식하게 함
        .accessibilityElement(children: .combine)
        // ✅ 2. 버튼 특성 부여 ("~ 버튼" 이라고 읽어줌)
        .accessibilityAddTraits(.isButton)
    }
}
```

### 2. ForEach에서 초점 연결하기
`List`나 `ForEach`를 사용할 때는 데이터 모델(`Identifiable`)의 ID를 식별자로 사용하면 편리합니다. 모델은 반드시 `Hashable` 프로토콜을 준수해야 합니다.

```swift
// 모델이 Hashable이어야 함 (Int, String ID 등)
struct Post: Identifiable, Hashable { ... }

// 뷰 구현
ForEach(posts) { post in
    PostRowView(post: post)
        // ✅ 행(Container) 전체에 초점 연결
        .accessibilityFocused($focus, equals: post.id)
}
```

### 주의사항
컨테이너에 `.accessibilityElement(children: .combine)`을 적용하면 내부의 개별 버튼(좋아요, 상세보기 등)으로 VoiceOver 초점이 이동하지 않을 수 있습니다. 
만약 내부 버튼도 개별적으로 선택되어야 한다면 `.combine` 대신 `.contain`을 사용하거나, 커스텀 액션(`accessibilityAction`)으로 기능을 구현해야 합니다.

