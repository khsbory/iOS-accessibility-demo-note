import XCTest

final class VoiceOverDemoUITests_Debug: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - 모든 UI 요소 탐색
    func testExploreAllElements() throws {
        print("\n========================================")
        print("모든 UI 요소 탐색")
        print("========================================\n")

        // 1. Expandable Demo로 이동
        let expandableButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Expandable'")).firstMatch
        expandableButton.waitForExistence(timeout: 5)
        expandableButton.tap()
        sleep(1)

        // 2. Not Applied 탭
        app.buttons["Not Applied"].tap()
        sleep(1)

        // 3. 모든 요소 출력
        print("[Buttons]")
        for (index, button) in app.buttons.allElementsBoundByIndex.enumerated() {
            print("\(index). \(button.label)")
        }

        print("\n[Static Texts]")
        for (index, text) in app.staticTexts.allElementsBoundByIndex.enumerated() {
            let frame = text.frame
            print("\(index). '\(text.label)' - Frame: (\(frame.origin.x), \(frame.origin.y), \(frame.width), \(frame.height))")
        }

        print("\n[Tables]")
        for (index, table) in app.tables.allElementsBoundByIndex.enumerated() {
            print("\(index). Table found")
            print("  Number of cells: \(table.cells.count)")
        }

        print("\n[Cells]")
        for (index, cell) in app.cells.allElementsBoundByIndex.enumerated() {
            let frame = cell.frame
            print("\(index). Cell - Frame: (\(frame.origin.x), \(frame.origin.y), \(frame.width), \(frame.height))")

            let texts = cell.staticTexts.allElementsBoundByIndex
            for (textIndex, text) in texts.enumerated() {
                print("    Text \(textIndex): '\(text.label)'")
            }
        }

        print("\n[Other Elements]")
        for (index, element) in app.otherElements.allElementsBoundByIndex.prefix(10).enumerated() {
            if !element.label.isEmpty {
                print("\(index). \(element.label)")
            }
        }

        // 4. 과일 헤더가 있는 셀 찾기
        print("\n[과일 헤더 셀 찾기]")
        let fruitsCells = app.cells.containing(NSPredicate(format: "label CONTAINS 'Fruits' OR label CONTAINS '과일'"))
        print("Found \(fruitsCells.count) cells containing '과일/Fruits'")

        for (index, cell) in fruitsCells.allElementsBoundByIndex.enumerated() {
            print("\(index). Cell label: '\(cell.label)'")
            print("   Frame: \(cell.frame)")
        }

        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "모든_요소_탐색"
        attachment.lifetime = .keepAlways
        add(attachment)

        print("\n========================================")
        print("탐색 완료")
        print("========================================\n")
    }

    // MARK: - 셀 기반 클릭 테스트
    func testTapCellInsteadOfText() throws {
        print("\n========================================")
        print("셀 기반 클릭 테스트")
        print("========================================\n")

        // 1. Expandable Demo로 이동
        let expandableButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Expandable'")).firstMatch
        expandableButton.waitForExistence(timeout: 5)
        expandableButton.tap()
        sleep(1)

        // 2. Not Applied 탭
        app.buttons["Not Applied"].tap()
        sleep(1)

        // 3. 초기 상태
        let initialCellCount = app.cells.count
        let initialTextCount = app.staticTexts.count
        print("초기 상태:")
        print("  Cells: \(initialCellCount)")
        print("  Static Texts: \(initialTextCount)")

        // 4. 과일 텍스트가 있는 셀 찾기
        print("\n[과일 셀 찾기 - 방법 1: containing]")
        let fruitsCellsContaining = app.cells.containing(NSPredicate(format: "staticTexts.@count > 0 AND ANY staticTexts.label CONTAINS 'Fruits'"))
        print("Found: \(fruitsCellsContaining.count)")

        // 5. 첫 번째 셀 직접 탭
        print("\n[방법 2: 첫 번째 셀 탭]")
        if app.cells.count > 0 {
            let firstCell = app.cells.element(boundBy: 0)
            print("First cell exists: \(firstCell.exists)")
            if firstCell.exists {
                print("First cell frame: \(firstCell.frame)")
                print("First cell texts:")
                for text in firstCell.staticTexts.allElementsBoundByIndex {
                    print("  - \(text.label)")
                }

                print("Tapping first cell...")
                firstCell.tap()
                sleep(2)

                let afterFirstTap = app.cells.count
                let afterFirstTapTexts = app.staticTexts.count
                print("After first cell tap:")
                print("  Cells: \(afterFirstTap)")
                print("  Static Texts: \(afterFirstTapTexts)")

                if afterFirstTapTexts > initialTextCount {
                    print("✅ 확장 성공! (\(initialTextCount) → \(afterFirstTapTexts))")
                } else {
                    print("❌ 확장되지 않음")
                }
            }
        }

        // 6. 좌표 기반 탭
        print("\n[방법 3: 좌표 기반 탭]")
        let fruitsText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Fruits'")).firstMatch
        if fruitsText.exists {
            let frame = fruitsText.frame
            print("Fruits text frame: \(frame)")

            // 텍스트의 왼쪽 영역 탭 (셀의 시작 부분)
            let cellLeftX = 20.0  // 셀의 왼쪽 여백
            let tapPoint = CGPoint(x: cellLeftX, y: frame.midY)

            print("Tapping at coordinate: (\(tapPoint.x), \(tapPoint.y))")
            let coordinate = app.coordinate(withNormalizedOffset: .zero)
                .withOffset(CGVector(dx: tapPoint.x, dy: tapPoint.y))
            coordinate.tap()
            sleep(2)

            let afterCoordTap = app.staticTexts.count
            print("After coordinate tap:")
            print("  Static Texts: \(afterCoordTap)")

            if afterCoordTap > initialTextCount {
                print("✅ 확장 성공! (\(initialTextCount) → \(afterCoordTap))")
            } else {
                print("❌ 확장되지 않음")
            }
        }

        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "셀_클릭_테스트"
        attachment.lifetime = .keepAlways
        add(attachment)

        print("\n========================================")
        print("테스트 완료")
        print("========================================\n")
    }

    // MARK: - 과일 → 여름 → 과일 축소 테스트
    func testFruitSummerCollapse() throws {
        let separator = String(repeating: "=", count: 80)
        print("\n" + separator)
        print("🧪 과일 확장 → 여름 확장 → 과일 축소 테스트")
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

        // 3. 과일 헤더 찾기 및 클릭 (1단계)
        print("\n[STEP 1: 과일 확장]")
        let fruitsText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Fruits' OR label CONTAINS '과일'")).firstMatch
        XCTAssertTrue(fruitsText.waitForExistence(timeout: 3), "과일 헤더를 찾을 수 없음")

        print("📍 과일 클릭 전 상태:")
        printAllTexts(label: "  ")

        fruitsText.tap()
        print("✅ 과일 헤더 클릭 완료")
        sleep(2)

        print("\n📍 과일 확장 후 상태:")
        printAllTexts(label: "  ")

        // 4. 여름 헤더 찾기 및 클릭 (2단계)
        print("\n[STEP 2: 여름 확장]")
        let summerText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Summer' OR label CONTAINS '여름' OR label CONTAINS '☀️'")).firstMatch

        if summerText.exists {
            print("✓ 여름 헤더 발견: \(summerText.label)")

            print("\n📍 여름 클릭 전 상태:")
            printAllTexts(label: "  ")

            summerText.tap()
            print("✅ 여름 헤더 클릭 완료")
            sleep(2)

            print("\n📍 여름 확장 후 상태:")
            printAllTexts(label: "  ")
        } else {
            print("⚠️ 여름 헤더를 찾을 수 없음")
        }

        // 5. 과일 다시 클릭하여 축소 (3단계)
        print("\n[STEP 3: 과일 축소]")
        let fruitsText2 = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Fruits' OR label CONTAINS '과일'")).firstMatch

        if fruitsText2.exists {
            print("✓ 과일 헤더 재발견")

            print("\n📍 과일 축소 전 상태:")
            printAllTexts(label: "  ")

            fruitsText2.tap()
            print("✅ 과일 헤더 클릭 (축소) 완료")
            sleep(2)

            print("\n📍 과일 축소 후 상태:")
            printAllTexts(label: "  ")
        } else {
            print("⚠️ 과일 헤더를 다시 찾을 수 없음")
        }

        // 6. 과일 다시 확장하여 여름 상태 확인 (4단계)
        print("\n[STEP 4: 과일 재확장 (여름이 축소되어 있어야 함)]")
        let fruitsText3 = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Fruits' OR label CONTAINS '과일'")).firstMatch

        if fruitsText3.exists {
            print("\n📍 과일 재확장 전 상태:")
            printAllTexts(label: "  ")

            fruitsText3.tap()
            print("✅ 과일 헤더 클릭 (재확장) 완료")
            sleep(2)

            print("\n📍 과일 재확장 후 상태:")
            printAllTexts(label: "  ")

            // 여름의 자식들이 보이는지 확인
            let watermelonText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '수박' OR label CONTAINS 'Watermelon' OR label CONTAINS '🍉'")).firstMatch

            if watermelonText.exists {
                print("❌ BUG 발견: 여름의 자식(수박)이 여전히 표시됨!")
                print("   예상: 여름은 축소된 상태여야 함")
                print("   실제: 여름이 확장된 상태로 표시됨")
            } else {
                print("✅ PASS: 여름의 자식이 표시되지 않음 (정상)")
            }
        }

        // 7. 스크린샷
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "과일_여름_축소_테스트"
        attachment.lifetime = .keepAlways
        add(attachment)

        print("\n" + separator)
        print("✅ 테스트 완료!")
        print(separator + "\n")
    }

    // Helper: 모든 텍스트 출력
    private func printAllTexts(label prefix: String) {
        let allTexts = app.staticTexts.allElementsBoundByIndex.map { $0.label }
        print("\(prefix)표시된 항목 (\(allTexts.count)개):")
        for (index, text) in allTexts.prefix(25).enumerated() {
            if !text.isEmpty && !text.contains("Back") && !text.contains("Applied") {
                print("\(prefix)  \(index + 1). \(text)")
            }
        }
    }
}
