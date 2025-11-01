import XCTest

final class VoiceOverDemoUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - 접근성 미적용 탭에서 과일 버튼 클릭 테스트
    func testNonAccessibleFruitButtonClick() throws {
        print("========================================")
        print("테스트 시작: 접근성 미적용 과일 버튼 클릭")
        print("========================================")

        // 1. 앱 실행 대기
        sleep(2)
        print("✓ 앱 실행 완료")

        // 2. "Expandable Demo" 버튼 찾기 및 클릭
        let expandableButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Expandable' OR label CONTAINS '확장'")).firstMatch
        XCTAssertTrue(expandableButton.waitForExistence(timeout: 5), "Expandable Demo 버튼을 찾을 수 없음")
        expandableButton.tap()
        print("✓ 'Expandable Demo' 버튼 클릭")

        sleep(1)

        // 3. "Not Applied" 탭 클릭
        let notAppliedButton = app.buttons["Not Applied"]
        if notAppliedButton.waitForExistence(timeout: 3) {
            notAppliedButton.tap()
            print("✓ 'Not Applied' 탭 클릭")
            sleep(1)
        } else {
            print("⚠ 'Not Applied' 탭을 찾을 수 없음 - 이미 선택되어 있을 수 있음")
        }

        // 4. UIKit 기반 테이블 요소 찾기
        let scrollViews = app.scrollViews
        let cells = app.cells
        let staticTexts = app.staticTexts

        print("ScrollViews: \(scrollViews.count)")
        print("Cells: \(cells.count)")
        print("Static Texts: \(staticTexts.count)")

        // 5. "Fruits" 또는 "과일" 텍스트 찾아서 탭
        let fruitsText = staticTexts.matching(NSPredicate(format: "label CONTAINS 'Fruits' OR label CONTAINS '과일' OR label CONTAINS '🍎'")).firstMatch
        if fruitsText.waitForExistence(timeout: 3) {
            fruitsText.tap()
            print("✓ '과일' 헤더 클릭 (확장)")
            sleep(1)
        } else {
            print("⚠ '과일' 헤더를 찾을 수 없음")
            // 모든 static texts 출력
            for (index, text) in staticTexts.allElementsBoundByIndex.prefix(20).enumerated() {
                print("  Static Text \(index): \(text.label)")
            }
        }

        // 6. "봄" 헤더 클릭
        let springText = staticTexts.matching(NSPredicate(format: "label CONTAINS 'Spring' OR label CONTAINS '봄' OR label CONTAINS '🌸'")).firstMatch
        if springText.waitForExistence(timeout: 3) {
            springText.tap()
            print("✓ '봄' 헤더 클릭 (확장)")
            sleep(1)
        }

        // 7. "딸기" 아이템 클릭
        let strawberryText = staticTexts.matching(NSPredicate(format: "label CONTAINS 'Strawberry' OR label CONTAINS '딸기' OR label CONTAINS '🍓'")).firstMatch
        if strawberryText.waitForExistence(timeout: 3) {
            strawberryText.tap()
            print("✓ '딸기' 아이템 클릭")
            print("→ 예상 동작: 토스트 메시지 표시 '🍓 딸기'")
            sleep(2)
        } else {
            print("⚠ '딸기' 아이템을 찾을 수 없음")
        }

        // 8. 스크린샷 캡처
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "과일_버튼_클릭_후"
        attachment.lifetime = .keepAlways
        add(attachment)
        print("✓ 스크린샷 저장")

        print("========================================")
        print("테스트 완료")
        print("========================================")
    }

    // MARK: - UI 계층 구조 탐색 테스트 (디버깅용)
    func testExploreUIHierarchy() throws {
        print("\n========================================")
        print("UI 계층 구조 탐색")
        print("========================================\n")

        sleep(2)

        // TabBar 확인
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists {
            print("✓ TabBar 발견")
            print("  탭 버튼 개수: \(tabBar.buttons.count)")
            for (index, button) in tabBar.buttons.allElementsBoundByIndex.enumerated() {
                print("  - 탭 \(index): \(button.label)")
            }
        }

        // Not Applied 탭으로 이동
        let notAppliedTab = tabBar.buttons["Not Applied"]
        if notAppliedTab.exists {
            notAppliedTab.tap()
            print("\n✓ 'Not Applied' 탭으로 전환")
            sleep(1)
        }

        // 테이블 확인
        let tables = app.tables
        print("\n테이블 개수: \(tables.count)")

        if tables.count > 0 {
            let table = tables.firstMatch
            print("셀 개수: \(table.cells.count)")

            print("\n📋 테이블 셀 목록:")
            for (index, cell) in table.cells.allElementsBoundByIndex.enumerated() {
                let staticTexts = cell.staticTexts.allElementsBoundByIndex
                if staticTexts.count > 0 {
                    print("  \(index). \(staticTexts.first!.label)")
                }
            }
        }

        // 스크린샷
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "UI_계층_구조"
        attachment.lifetime = .keepAlways
        add(attachment)

        print("\n========================================")
        print("UI 탐색 완료")
        print("========================================\n")
    }
}
