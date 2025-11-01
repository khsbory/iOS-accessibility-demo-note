import Foundation

// MARK: - Expandable Item Types
enum ExpandableItemType {
    case category      // Level 1: 과일, 채소
    case season       // Level 2: 봄, 여름, 가을, 겨울
    case item         // Level 3: 실제 과일/채소
}

// MARK: - Expandable Item Model
struct ExpandableItem {
    let id: String
    let type: ExpandableItemType
    let title: String
    let emoji: String
    var isExpanded: Bool
    let level: Int
    var children: [ExpandableItem]?

    init(id: String, type: ExpandableItemType, title: String, emoji: String, level: Int, isExpanded: Bool = false, children: [ExpandableItem]? = nil) {
        self.id = id
        self.type = type
        self.title = title
        self.emoji = emoji
        self.level = level
        self.isExpanded = isExpanded
        self.children = children
    }
}

// MARK: - Expandable Data Provider
class ExpandableDataProvider {

    static func createInitialData() -> [ExpandableItem] {
        return [
            createFruitsCategory(),
            createVegetablesCategory()
        ]
    }

    // MARK: - 과일 카테고리
    private static func createFruitsCategory() -> ExpandableItem {
        let seasons = [
            createSeason(
                id: "fruits.spring",
                emoji: "🌸",
                titleKey: "season.spring.fruits",
                items: [
                    ("food.strawberry", "🍓"),
                    ("food.cherry", "🍒"),
                    ("food.apricot", "🍑"),
                    ("food.plum", "🫒"),
                    ("food.lemon", "🍋")
                ]
            ),
            createSeason(
                id: "fruits.summer",
                emoji: "☀️",
                titleKey: "season.summer.fruits",
                items: [
                    ("food.watermelon", "🍉"),
                    ("food.peach", "🍑"),
                    ("food.grapes", "🍇"),
                    ("food.melon", "🍈"),
                    ("food.blueberry", "🫐")
                ]
            ),
            createSeason(
                id: "fruits.fall",
                emoji: "🍂",
                titleKey: "season.fall.fruits",
                items: [
                    ("food.apple", "🍎"),
                    ("food.pear", "🍐"),
                    ("food.persimmon", "🍊"),
                    ("food.mango", "🥭"),
                    ("food.kiwi", "🥝")
                ]
            ),
            createSeason(
                id: "fruits.winter",
                emoji: "❄️",
                titleKey: "season.winter.fruits",
                items: [
                    ("food.orange", "🍊"),
                    ("food.banana", "🍌"),
                    ("food.pineapple", "🍍"),
                    ("food.coconut", "🥥"),
                    ("food.lime", "🍋")
                ]
            )
        ]

        return ExpandableItem(
            id: "fruits",
            type: .category,
            title: "category.fruits",
            emoji: "🍎",
            level: 0,
            children: seasons
        )
    }

    // MARK: - 채소 카테고리
    private static func createVegetablesCategory() -> ExpandableItem {
        let seasons = [
            createSeason(
                id: "vegetables.spring",
                emoji: "🌸",
                titleKey: "season.spring.vegetables",
                items: [
                    ("food.spinach", "🥬"),
                    ("food.lettuce", "🥬"),
                    ("food.greenOnion", "🧅"),
                    ("food.cabbage", "🥬"),
                    ("food.radish", "🥕")
                ]
            ),
            createSeason(
                id: "vegetables.summer",
                emoji: "☀️",
                titleKey: "season.summer.vegetables",
                items: [
                    ("food.tomato", "🍅"),
                    ("food.cucumber", "🥒"),
                    ("food.eggplant", "🍆"),
                    ("food.corn", "🌽"),
                    ("food.chili", "🌶️")
                ]
            ),
            createSeason(
                id: "vegetables.fall",
                emoji: "🍂",
                titleKey: "season.fall.vegetables",
                items: [
                    ("food.pumpkin", "🎃"),
                    ("food.sweetPotato", "🍠"),
                    ("food.mushroom", "🍄"),
                    ("food.carrot", "🥕"),
                    ("food.potato", "🥔")
                ]
            ),
            createSeason(
                id: "vegetables.winter",
                emoji: "❄️",
                titleKey: "season.winter.vegetables",
                items: [
                    ("food.broccoli", "🥦"),
                    ("food.onion", "🧅"),
                    ("food.garlic", "🧄"),
                    ("food.bellPepper", "🫑"),
                    ("food.celery", "🥬")
                ]
            )
        ]

        return ExpandableItem(
            id: "vegetables",
            type: .category,
            title: "category.vegetables",
            emoji: "🥬",
            level: 0,
            children: seasons
        )
    }

    // MARK: - Helper: 계절 생성
    private static func createSeason(id: String, emoji: String, titleKey: String, items: [(String, String)]) -> ExpandableItem {
        let foodItems = items.map { (nameKey, emoji) in
            ExpandableItem(
                id: "\(id).\(nameKey)",
                type: .item,
                title: nameKey,
                emoji: emoji,
                level: 2
            )
        }

        return ExpandableItem(
            id: id,
            type: .season,
            title: titleKey,
            emoji: emoji,
            level: 1,
            children: foodItems
        )
    }
}
