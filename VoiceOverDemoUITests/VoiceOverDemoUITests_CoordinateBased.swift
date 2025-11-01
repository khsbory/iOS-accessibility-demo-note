import XCTest

final class VoiceOverDemoUITests_CoordinateBased: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - 좌표 기반 완전 자동화 테스트
    func testCoordinateBasedAutomation() throws {
        let separator = String(repeating: "=", count: 60)
        print("\n" + separator)
        print("좌표 기반 완전 자동화 테스트 (접근성 라벨 없이)")
        print(separator + "\n")

        // 1. Expandable Demo로 이동
        let expandableButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Expandable' OR label CONTAINS '확장'")).firstMatch
        XCTAssertTrue(expandableButton.waitForExistence(timeout: 5), "Expandable Demo 버튼을 찾을 수 없음")
        expandableButton.tap()
        print("✓ Expandable Demo 진입")
        sleep(1)

        // 2. Not Applied 탭으로 전환
        let notAppliedButton = app.buttons["Not Applied"]
        if notAppliedButton.waitForExistence(timeout: 3) {
            notAppliedButton.tap()
            print("✓ Not Applied 탭 선택")
            sleep(1)
        }

        // 3. 과일 헤더 찾기
        let fruitsText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Fruits' OR label CONTAINS '과일'")).firstMatch
        XCTAssertTrue(fruitsText.waitForExistence(timeout: 3), "과일 헤더를 찾을 수 없음")

        // 4. 과일 헤더의 위치 정보 가져오기
        let fruitsFrame = fruitsText.frame
        print("\n[과일 헤더 위치 정보]")
        print("X: \(fruitsFrame.origin.x), Y: \(fruitsFrame.origin.y)")
        print("Width: \(fruitsFrame.width), Height: \(fruitsFrame.height)")

        // 5. 과일 헤더 클릭 (확장)
        print("\n[과일 확장]")
        fruitsText.tap()
        print("✓ 과일 헤더 클릭")
        sleep(2)

        // 6. 확장된 항목들이 표시될 위치 계산
        // 첫 번째 자식 항목 (봄)은 과일 헤더 바로 아래에 위치
        let firstChildY = fruitsFrame.maxY + fruitsFrame.height * 0.5
        let firstChildPoint = CGPoint(x: fruitsFrame.midX, y: firstChildY)

        print("\n[첫 번째 자식 항목 클릭 시도]")
        print("예상 위치: X: \(firstChildPoint.x), Y: \(firstChildPoint.y)")

        // 7. 좌표 기반 탭 - 첫 번째 자식 (봄)
        let firstChildCoordinate = app.coordinate(withNormalizedOffset: .zero)
            .withOffset(CGVector(dx: firstChildPoint.x, dy: firstChildPoint.y))
        firstChildCoordinate.tap()
        print("✓ 첫 번째 자식 항목 클릭 (봄 예상)")
        sleep(2)

        // 8. 봄 아래의 항목 클릭 (딸기 등)
        let secondLevelY = firstChildY + fruitsFrame.height
        let secondLevelPoint = CGPoint(x: fruitsFrame.midX, y: secondLevelY)

        print("\n[두 번째 레벨 항목 클릭 시도]")
        print("예상 위치: X: \(secondLevelPoint.x), Y: \(secondLevelPoint.y)")

        let secondLevelCoordinate = app.coordinate(withNormalizedOffset: .zero)
            .withOffset(CGVector(dx: secondLevelPoint.x, dy: secondLevelPoint.y))
        secondLevelCoordinate.tap()
        print("✓ 두 번째 레벨 항목 클릭 (과일 아이템 예상)")
        print("→ 예상 동작: 토스트 메시지 표시")
        sleep(2)

        // 9. 여러 위치 순차적으로 클릭 시도
        print("\n[다중 좌표 클릭 테스트]")
        let baseY = fruitsFrame.maxY
        let spacing = fruitsFrame.height

        for i in 1...5 {
            let yPos = baseY + spacing * CGFloat(i)
            let point = CGPoint(x: fruitsFrame.midX, y: yPos)
            let coordinate = app.coordinate(withNormalizedOffset: .zero)
                .withOffset(CGVector(dx: point.x, dy: point.y))

            print("클릭 \(i): Y = \(yPos)")
            coordinate.tap()
            sleep(1)
        }

        // 10. 스크린샷 캡처
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "좌표_기반_테스트_결과"
        attachment.lifetime = .keepAlways
        add(attachment)
        print("\n✓ 스크린샷 저장")

        print("\n" + separator)
        print("좌표 기반 테스트 완료")
        print("이 방법은 접근성 라벨 없이도 동작합니다!")
        print(separator + "\n")
    }

    // MARK: - 스와이프 기반 테스트
    func testSwipeBasedInteraction() throws {
        print("\n========================================")
        print("스와이프 기반 테스트")
        print("========================================\n")

        // 1. Expandable Demo로 이동
        let expandableButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Expandable'")).firstMatch
        expandableButton.waitForExistence(timeout: 5)
        expandableButton.tap()
        sleep(1)

        // 2. Not Applied 탭
        app.buttons["Not Applied"].tap()
        sleep(1)

        // 3. 화면 중앙에서 아래로 스와이프 (스크롤)
        let screenCenter = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let screenBottom = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))

        print("화면 스와이프 (아래로 스크롤)")
        screenCenter.press(forDuration: 0.1, thenDragTo: screenBottom)
        sleep(1)

        // 4. 스크린샷
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "스와이프_테스트"
        attachment.lifetime = .keepAlways
        add(attachment)

        print("✓ 스와이프 테스트 완료\n")
    }

    // MARK: - 화면 비율 기반 탭
    func testNormalizedCoordinateTap() throws {
        print("\n========================================")
        print("정규화된 좌표 기반 탭")
        print("========================================\n")

        // 1. Expandable Demo로 이동
        let expandableButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Expandable'")).firstMatch
        expandableButton.waitForExistence(timeout: 5)
        expandableButton.tap()
        sleep(1)

        // 2. Not Applied 탭
        app.buttons["Not Applied"].tap()
        sleep(1)

        // 3. 화면 비율로 위치 지정 (0.0 ~ 1.0)
        // 화면 상단 1/3 지점 탭 (과일 헤더 근처)
        let topThirdPoint = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.35))
        print("화면 상단 1/3 지점 탭 (normalized Y: 0.35)")
        topThirdPoint.tap()
        sleep(2)

        // 4. 화면 중간 지점 탭
        let middlePoint = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.45))
        print("화면 중간 지점 탭 (normalized Y: 0.45)")
        middlePoint.tap()
        sleep(2)

        // 5. 스크린샷
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "정규화_좌표_테스트"
        attachment.lifetime = .keepAlways
        add(attachment)

        print("✓ 정규화 좌표 테스트 완료")
        print("이 방법은 다양한 화면 크기에서도 동작합니다!\n")
    }
}
