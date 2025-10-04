import Foundation

struct FoodItem {
    let name: String
    let emoji: String
}

class FoodData {
    static let fruits: [FoodItem] = [
        FoodItem(name: "사과", emoji: "🍎"),
        FoodItem(name: "바나나", emoji: "🍌"),
        FoodItem(name: "오렌지", emoji: "🍊"),
        FoodItem(name: "포도", emoji: "🍇"),
        FoodItem(name: "수박", emoji: "🍉"),
        FoodItem(name: "딸기", emoji: "🍓"),
        FoodItem(name: "체리", emoji: "🍒"),
        FoodItem(name: "복숭아", emoji: "🍑"),
        FoodItem(name: "파인애플", emoji: "🍍"),
        FoodItem(name: "키위", emoji: "🥝"),
        FoodItem(name: "레몬", emoji: "🍋"),
        FoodItem(name: "배", emoji: "🍐"),
        FoodItem(name: "망고", emoji: "🥭"),
        FoodItem(name: "코코넛", emoji: "🥥"),
        FoodItem(name: "블루베리", emoji: "🫐"),
        FoodItem(name: "멜론", emoji: "🍈"),
        FoodItem(name: "자두", emoji: "🫒"),
        FoodItem(name: "살구", emoji: "🍑"),
        FoodItem(name: "감", emoji: "🍊"),
        FoodItem(name: "라임", emoji: "🍋")
    ]

    static let vegetables: [FoodItem] = [
        FoodItem(name: "토마토", emoji: "🍅"),
        FoodItem(name: "가지", emoji: "🍆"),
        FoodItem(name: "당근", emoji: "🥕"),
        FoodItem(name: "옥수수", emoji: "🌽"),
        FoodItem(name: "고추", emoji: "🌶️"),
        FoodItem(name: "오이", emoji: "🥒"),
        FoodItem(name: "브로콜리", emoji: "🥦"),
        FoodItem(name: "양상추", emoji: "🥬"),
        FoodItem(name: "감자", emoji: "🥔"),
        FoodItem(name: "고구마", emoji: "🍠"),
        FoodItem(name: "양파", emoji: "🧅"),
        FoodItem(name: "마늘", emoji: "🧄"),
        FoodItem(name: "버섯", emoji: "🍄"),
        FoodItem(name: "호박", emoji: "🎃"),
        FoodItem(name: "피망", emoji: "🫑"),
        FoodItem(name: "무", emoji: "🥕"),
        FoodItem(name: "배추", emoji: "🥬"),
        FoodItem(name: "시금치", emoji: "🥬"),
        FoodItem(name: "파", emoji: "🧅"),
        FoodItem(name: "셀러리", emoji: "🥬")
    ]
}
