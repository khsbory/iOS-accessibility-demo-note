import XCTest

final class VoiceOverDemoUITests_FruitSpringFlow: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - 과일 → 봄 → 과일 아이템 클릭 테스트
    func testFruitSpringItemFlow() throws {
        let separator = String(repeating: "=", count: 60)
        print("\n" + separator)
        print("과일 → 봄 → 과일 아이템 자동화 테스트")
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
        print("표시된 항목:")
        for (index, text) in initialTexts.prefix(10).enumerated() {
            print("  \(index + 1). \(text)")
        }

        // 4. 과일 헤더 찾기 및 클릭 (1단계)
        print("\n[1단계: 과일 헤더 클릭]")
        let fruitsText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Fruits' OR label CONTAINS '과일'")).firstMatch
        XCTAssertTrue(fruitsText.waitForExistence(timeout: 3), "과일 헤더를 찾을 수 없음")

        let fruitsFrame = fruitsText.frame
        print("과일 헤더 위치: X=\(fruitsFrame.origin.x), Y=\(fruitsFrame.origin.y)")
        print("과일 헤더 크기: W=\(fruitsFrame.width), H=\(fruitsFrame.height)")

        fruitsText.tap()
        print("✓ 과일 헤더 클릭 완료")
        sleep(2)  // 확장 애니메이션 대기

        // 5. 확장 후 상태 확인
        let afterFruitsExpand = app.staticTexts.allElementsBoundByIndex.map { $0.label }
        print("\n[과일 확장 후 상태]")
        print("표시된 항목:")
        for (index, text) in afterFruitsExpand.prefix(15).enumerated() {
            print("  \(index + 1). \(text)")
        }

        // 6. 봄 헤더 찾기 및 클릭 (2단계)
        print("\n[2단계: 봄 헤더 클릭]")

        // 봄 텍스트를 직접 찾기
        let springText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Spring' OR label CONTAINS '봄' OR label CONTAINS '🌸'")).firstMatch

        if springText.exists {
            print("✓ 봄 헤더 발견: \(springText.label)")
            let springFrame = springText.frame
            print("봄 헤더 위치: X=\(springFrame.origin.x), Y=\(springFrame.origin.y)")

            springText.tap()
            print("✓ 봄 헤더 클릭 완료")
            sleep(2)  // 확장 애니메이션 대기
        } else {
            print("⚠️ 봄 헤더를 찾을 수 없음 - 좌표로 시도")

            // 과일 헤더 바로 아래 영역 클릭 (봄이 있을 위치)
            let springY = fruitsFrame.maxY + fruitsFrame.height * 0.5
            let springPoint = CGPoint(x: fruitsFrame.midX, y: springY)

            print("봄 예상 위치로 클릭: X=\(springPoint.x), Y=\(springPoint.y)")

            let springCoordinate = app.coordinate(withNormalizedOffset: .zero)
                .withOffset(CGVector(dx: springPoint.x, dy: springPoint.y))
            springCoordinate.tap()
            print("✓ 봄 위치 클릭 완료")
            sleep(2)
        }

        // 7. 봄 확장 후 상태 확인
        let afterSpringExpand = app.staticTexts.allElementsBoundByIndex.map { $0.label }
        print("\n[봄 확장 후 상태]")
        print("표시된 항목:")
        for (index, text) in afterSpringExpand.prefix(20).enumerated() {
            print("  \(index + 1). \(text)")
        }

        // 8. 과일 아이템 찾기 및 클릭 (3단계)
        print("\n[3단계: 과일 아이템 클릭]")

        // 딸기, 체리 등의 과일 아이템 찾기
        let fruitEmojis = ["🍓", "🍒", "🍑", "🍉"]
        var foundFruit = false

        for emoji in fruitEmojis {
            let fruitText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", emoji)).firstMatch
            if fruitText.exists {
                print("✓ 과일 아이템 발견: \(fruitText.label)")
                let fruitFrame = fruitText.frame
                print("과일 아이템 위치: X=\(fruitFrame.origin.x), Y=\(fruitFrame.origin.y)")

                fruitText.tap()
                print("✓ 과일 아이템 클릭 완료")
                print("→ 예상 동작: 토스트 메시지 '\(fruitText.label)' 표시")
                foundFruit = true
                sleep(2)
                break
            }
        }

        if !foundFruit {
            print("⚠️ 과일 아이템을 직접 찾을 수 없음 - 좌표로 시도")

            // 봄 헤더를 다시 찾아서 그 아래 클릭
            let springText2 = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Spring' OR label CONTAINS '봄' OR label CONTAINS '🌸'")).firstMatch

            if springText2.exists {
                let springFrame2 = springText2.frame
                let fruitItemY = springFrame2.maxY + springFrame2.height * 0.5
                let fruitItemPoint = CGPoint(x: springFrame2.midX, y: fruitItemY)

                print("과일 아이템 예상 위치로 클릭: X=\(fruitItemPoint.x), Y=\(fruitItemPoint.y)")

                let fruitCoordinate = app.coordinate(withNormalizedOffset: .zero)
                    .withOffset(CGVector(dx: fruitItemPoint.x, dy: fruitItemY))
                fruitCoordinate.tap()
                print("✓ 과일 아이템 위치 클릭 완료")
                sleep(2)
            } else {
                // 마지막 방법: 과일 헤더 아래 두 칸 내려간 위치
                let fruitItemY = fruitsFrame.maxY + fruitsFrame.height * 2.5
                let fruitItemPoint = CGPoint(x: fruitsFrame.midX, y: fruitItemY)

                print("계산된 과일 아이템 위치로 클릭: X=\(fruitItemPoint.x), Y=\(fruitItemPoint.y)")

                let fruitCoordinate = app.coordinate(withNormalizedOffset: .zero)
                    .withOffset(CGVector(dx: fruitItemPoint.x, dy: fruitItemY))
                fruitCoordinate.tap()
                print("✓ 계산된 위치 클릭 완료")
                sleep(2)
            }
        }

        // 9. 최종 스크린샷
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "과일_봄_아이템_플로우_완료"
        attachment.lifetime = .keepAlways
        add(attachment)
        print("\n✓ 스크린샷 저장")

        print("\n" + separator)
        print("✅ 과일 → 봄 → 과일 아이템 플로우 완료!")
        print(separator + "\n")
    }

    // MARK: - 상세 로깅 버전
    func testDetailedFruitFlow() throws {
        print("\n========================================")
        print("상세 로깅 버전: 과일 플로우 테스트")
        print("========================================\n")

        // 1. 앱 실행 및 이동
        let expandableButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Expandable'")).firstMatch
        expandableButton.waitForExistence(timeout: 5)
        expandableButton.tap()
        sleep(1)

        app.buttons["Not Applied"].tap()
        sleep(1)

        // 2. 모든 텍스트 출력
        print("[초기 화면의 모든 텍스트]")
        let allTexts = app.staticTexts.allElementsBoundByIndex
        for (index, element) in allTexts.enumerated() {
            let frame = element.frame
            print("\(index). '\(element.label)' - X:\(frame.origin.x), Y:\(frame.origin.y), W:\(frame.width), H:\(frame.height)")
        }

        // 3. 과일 클릭
        print("\n[과일 클릭]")
        let fruits = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '과일' OR label CONTAINS 'Fruits'")).firstMatch
        if fruits.exists {
            print("과일 발견: \(fruits.label)")
            fruits.tap()
            sleep(2)
        }

        // 4. 확장 후 모든 텍스트 출력
        print("\n[과일 확장 후 모든 텍스트]")
        let allTexts2 = app.staticTexts.allElementsBoundByIndex
        for (index, element) in allTexts2.enumerated() {
            let frame = element.frame
            print("\(index). '\(element.label)' - X:\(frame.origin.x), Y:\(frame.origin.y)")
        }

        // 5. 봄 찾기 및 클릭
        print("\n[봄 찾기]")
        let spring = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '봄' OR label CONTAINS 'Spring' OR label CONTAINS '🌸'")).firstMatch
        if spring.exists {
            print("봄 발견: \(spring.label)")
            spring.tap()
            sleep(2)
        } else {
            print("봄을 찾을 수 없음")
        }

        // 6. 봄 확장 후 모든 텍스트 출력
        print("\n[봄 확장 후 모든 텍스트]")
        let allTexts3 = app.staticTexts.allElementsBoundByIndex
        for (index, element) in allTexts3.enumerated() {
            let frame = element.frame
            print("\(index). '\(element.label)' - X:\(frame.origin.x), Y:\(frame.origin.y)")
        }

        // 7. 과일 아이템 찾기
        print("\n[과일 아이템 찾기]")
        let strawberry = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '딸기' OR label CONTAINS 'Strawberry' OR label CONTAINS '🍓'")).firstMatch
        if strawberry.exists {
            print("딸기 발견: \(strawberry.label)")
            strawberry.tap()
            sleep(2)
        } else {
            print("딸기를 찾을 수 없음")
        }

        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "상세_로깅_결과"
        attachment.lifetime = .keepAlways
        add(attachment)

        print("\n========================================")
        print("상세 로깅 완료")
        print("========================================\n")
    }
}
