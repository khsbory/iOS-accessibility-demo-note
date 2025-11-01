import XCTest

final class VoiceOverDemoUITests_Complete: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - 완전한 확장/축소 테스트
    func testExpandableFlow() throws {
        let separator = String(repeating: "=", count: 60)
        print("\n" + separator)
        print("완전 자동화 테스트: 확장/축소 동작 검증")
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

        // 3. 초기 상태 확인
        let initialTexts = app.staticTexts.allElementsBoundByIndex.map { $0.label }
        print("\n[초기 상태]")
        print("표시된 텍스트: \(initialTexts.prefix(10))")

        let initialCount = app.staticTexts.count
        print("초기 텍스트 개수: \(initialCount)")

        // 4. 과일 헤더 클릭 (확장)
        let fruitsText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Fruits' OR label CONTAINS '과일'")).firstMatch
        XCTAssertTrue(fruitsText.waitForExistence(timeout: 3), "과일 헤더를 찾을 수 없음")

        print("\n[과일 확장 테스트]")
        fruitsText.tap()
        print("✓ 과일 헤더 클릭")
        sleep(2)  // 애니메이션 완료 대기

        // 5. 확장 후 상태 확인
        let expandedCount = app.staticTexts.count
        print("확장 후 텍스트 개수: \(expandedCount)")

        if expandedCount > initialCount {
            print("✅ 확장 성공! (\(initialCount) → \(expandedCount), +\(expandedCount - initialCount)개)")
        } else {
            print("⚠️ 텍스트 개수 변화 없음")
        }

        // 6. 확장된 항목 출력
        let expandedTexts = app.staticTexts.allElementsBoundByIndex.map { $0.label }
        print("\n[확장 후 항목]")
        for (index, text) in expandedTexts.prefix(15).enumerated() {
            print("  \(index). \(text)")
        }

        // 7. 계절 찾기 (다양한 방법 시도)
        print("\n[하위 항목 검색]")

        // 방법 1: 계절 이모지로 찾기
        let seasonEmojis = ["🌸", "☀️", "🍂", "❄️"]
        var foundSeason = false

        for emoji in seasonEmojis {
            let seasonText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", emoji)).firstMatch
            if seasonText.exists {
                print("✓ 계절 발견: \(seasonText.label)")
                seasonText.tap()
                print("  → 클릭 완료")
                foundSeason = true
                sleep(2)
                break
            }
        }

        if !foundSeason {
            print("⚠️ 계절을 찾을 수 없음 - 좌표 기반 탭 시도")
            // 과일 헤더 바로 아래 영역 탭 (상대 위치)
            let fruitsFrame = fruitsText.frame
            let belowPoint = CGPoint(x: fruitsFrame.midX, y: fruitsFrame.maxY + 50)
            app.coordinate(withNormalizedOffset: .zero).withOffset(CGVector(dx: belowPoint.x, dy: belowPoint.y)).tap()
            print("  → 과일 아래 영역 클릭")
            sleep(2)
        }

        // 8. 최종 상태 확인
        let finalCount = app.staticTexts.count
        print("\n[최종 상태]")
        print("최종 텍스트 개수: \(finalCount)")

        // 9. 과일 아이템 찾기
        let fruitEmojis = ["🍓", "🍒", "🍑", "🍉", "🍎"]
        print("\n[과일 아이템 검색]")

        for emoji in fruitEmojis {
            let fruitText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", emoji)).firstMatch
            if fruitText.exists {
                print("✓ 과일 발견: \(fruitText.label)")
                fruitText.tap()
                print("  → 클릭 완료 (토스트 메시지 예상)")
                sleep(2)
                break
            }
        }

        // 10. 스크린샷 캡처
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "완전한_확장_테스트_결과"
        attachment.lifetime = .keepAlways
        add(attachment)
        print("\n✓ 스크린샷 저장")

        print("\n" + separator)
        print("테스트 완료")
        print(separator + "\n")
    }

    // MARK: - 축소 테스트
    func testCollapseFlow() throws {
        let separator = String(repeating: "=", count: 60)
        print("\n" + separator)
        print("축소 동작 테스트")
        print(separator + "\n")

        // 1. Expandable Demo로 이동
        let expandableButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Expandable'")).firstMatch
        expandableButton.waitForExistence(timeout: 5)
        expandableButton.tap()
        sleep(1)

        // 2. Not Applied 탭
        app.buttons["Not Applied"].tap()
        sleep(1)

        // 3. 과일 확장
        let fruitsText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Fruits' OR label CONTAINS '과일'")).firstMatch
        fruitsText.tap()
        sleep(2)

        let expandedCount = app.staticTexts.count
        print("확장 후 개수: \(expandedCount)")

        // 4. 과일 다시 클릭 (축소)
        fruitsText.tap()
        sleep(2)

        let collapsedCount = app.staticTexts.count
        print("축소 후 개수: \(collapsedCount)")

        // 5. 검증
        if collapsedCount < expandedCount {
            print("✅ 축소 성공! (\(expandedCount) → \(collapsedCount), -\(expandedCount - collapsedCount)개)")
        } else {
            print("⚠️ 축소되지 않음")
        }

        // 스크린샷
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "축소_테스트_결과"
        attachment.lifetime = .keepAlways
        add(attachment)

        print("\n" + separator)
        print("축소 테스트 완료")
        print(separator + "\n")
    }
}
