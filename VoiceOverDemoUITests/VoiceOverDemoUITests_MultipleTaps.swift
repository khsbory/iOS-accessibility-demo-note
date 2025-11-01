import XCTest

final class VoiceOverDemoUITests_MultipleTaps: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - 과일 여러 번 탭 테스트
    func testMultipleFruitTaps() throws {
        let separator = String(repeating: "=", count: 80)
        print("\n" + separator)
        print("🧪 과일 여러 번 탭 테스트 (확장 → 축소 → 확장 → 축소)")
        print(separator + "\n")

        // 1. Expandable Demo로 이동
        let expandableButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Expandable'")).firstMatch
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

        print("\n초기 항목 수: \(app.staticTexts.count)")

        // 4. 과일 5번 탭
        for i in 1...5 {
            print("\n" + String(repeating: "-", count: 60))
            print("TAP #\(i) - 과일 클릭")
            print(String(repeating: "-", count: 60))

            fruitsText.tap()
            sleep(2)

            let currentCount = app.staticTexts.count
            print("탭 후 항목 수: \(currentCount)")

            // 계절이 보이는지 확인
            let springVisible = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Spring' OR label CONTAINS '봄' OR label CONTAINS '🌸'")).firstMatch.exists
            let summerVisible = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Summer' OR label CONTAINS '여름' OR label CONTAINS '☀️'")).firstMatch.exists

            if springVisible || summerVisible {
                print("📊 상태: EXPANDED (계절들이 보임)")
            } else {
                print("📊 상태: COLLAPSED (계절들이 안 보임)")
            }
        }

        print("\n" + separator)
        print("✅ 테스트 완료!")
        print(separator + "\n")

        // 스크린샷
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "과일_여러번_탭_결과"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
