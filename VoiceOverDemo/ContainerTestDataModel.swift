import Foundation

// MARK: - Container Test Item
struct ContainerTestItem {
    let id: String
    let title: String
    let emoji: String
    var items: [String]
}

// MARK: - Container Test Data Provider
class ContainerTestDataProvider {
    static func createTestData() -> [ContainerTestItem] {
        return [
            ContainerTestItem(
                id: "fruits",
                title: "category.fruits",
                emoji: "🍎",
                items: ["🍓", "🍎", "🍇", "🍌"]
            ),
            ContainerTestItem(
                id: "vegetables",
                title: "category.vegetables",
                emoji: "🥬",
                items: ["🍅", "🥒", "🥕", "🥦"]
            )
        ]
    }
}
