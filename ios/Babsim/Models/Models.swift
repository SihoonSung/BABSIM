import Foundation
import SwiftData

enum Difficulty: String, Codable, CaseIterable, Identifiable {
    case easy, medium, hard

    var id: String { rawValue }

    var label: String {
        switch self {
        case .easy: return "초급"
        case .medium: return "중급"
        case .hard: return "고급"
        }
    }
}

enum RecipeCategory {
    static let known: [(key: String, label: String)] = [
        ("Korean", "한식"),
        ("Japanese", "일식"),
        ("Italian", "이탈리안"),
        ("Western", "양식"),
        ("Other", "기타"),
    ]

    static func label(for key: String) -> String {
        known.first(where: { $0.key == key })?.label ?? key
    }
}

@Model
final class Recipe {
    var title: String = ""
    var category: String = "Korean"
    var summary: String = ""
    var difficultyRaw: String = Difficulty.easy.rawValue
    var mealType: String = ""
    var dietaryTags: [String] = []
    var cookingTimeMinutes: Int = 0
    var servingSize: Int = 1
    var instructions: String = ""
    var instructionsEn: String = ""
    var source: String = ""
    var isCustom: Bool = false
    var isFavorite: Bool = false
    var createdAt: Date = Date()

    @Attribute(.externalStorage)
    var imageData: Data?

    @Relationship(deleteRule: .cascade, inverse: \RecipeIngredient.recipe)
    var ingredients: [RecipeIngredient]? = []

    @Relationship(deleteRule: .cascade, inverse: \CookLog.recipe)
    var cookLogs: [CookLog]? = []

    var difficulty: Difficulty {
        get { Difficulty(rawValue: difficultyRaw) ?? .easy }
        set { difficultyRaw = newValue.rawValue }
    }

    var sortedIngredients: [RecipeIngredient] {
        (ingredients ?? []).sorted { $0.orderIndex < $1.orderIndex }
    }

    var requiredIngredientNames: [String] {
        sortedIngredients.filter { !$0.isOptional }.map(\.name)
    }

    init(
        title: String,
        category: String = "Korean",
        summary: String = "",
        difficulty: Difficulty = .easy,
        mealType: String = "",
        dietaryTags: [String] = [],
        cookingTimeMinutes: Int = 0,
        servingSize: Int = 1,
        instructions: String = "",
        instructionsEn: String = "",
        source: String = "",
        isCustom: Bool = false
    ) {
        self.title = title
        self.category = category
        self.summary = summary
        self.difficultyRaw = difficulty.rawValue
        self.mealType = mealType
        self.dietaryTags = dietaryTags
        self.cookingTimeMinutes = cookingTimeMinutes
        self.servingSize = servingSize
        self.instructions = instructions
        self.instructionsEn = instructionsEn
        self.source = source
        self.isCustom = isCustom
        self.createdAt = Date()
    }
}

@Model
final class RecipeIngredient {
    var name: String = ""
    var amount: String = ""
    var isOptional: Bool = false
    var orderIndex: Int = 0
    var recipe: Recipe?

    init(name: String, amount: String, isOptional: Bool = false, orderIndex: Int = 0) {
        self.name = name
        self.amount = amount
        self.isOptional = isOptional
        self.orderIndex = orderIndex
    }
}

@Model
final class FridgeItem {
    @Attribute(.unique) var name: String = ""
    var category: String = "기타"
    var memo: String = ""
    var addedAt: Date = Date()

    init(name: String, category: String = "기타", memo: String = "") {
        self.name = name
        self.category = category
        self.memo = memo
        self.addedAt = Date()
    }
}

@Model
final class CookLog {
    var cookedAt: Date = Date()
    var note: String = ""
    var recipe: Recipe?

    @Attribute(.externalStorage)
    var photoData: Data?

    init(cookedAt: Date = Date(), note: String = "") {
        self.cookedAt = cookedAt
        self.note = note
    }
}
