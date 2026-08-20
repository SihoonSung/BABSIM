import Foundation
import SwiftData

struct SeedIngredient: Decodable {
    let name: String
    let nameEn: String
    let category: String
}

struct SeedRecipeIngredient: Decodable {
    let name: String
    let amount: String
    let isOptional: Bool
}

struct SeedRecipe: Decodable {
    let title: String
    let slug: String
    let category: String
    let description: String
    let difficulty: String
    let mealType: String
    let dietaryTags: [String]
    let cookingTimeMinutes: Int
    let servingSize: Int
    let instructions: String
    let instructionsEn: String
    let source: String
    let ingredients: [SeedRecipeIngredient]
}

struct SeedData: Decodable {
    let version: Int
    let ingredients: [SeedIngredient]
    let recipes: [SeedRecipe]
}

enum SeedImporter {
    private static let seedVersionKey = "babsim.seedVersion"

    static func load() -> SeedData? {
        guard let url = Bundle.main.url(forResource: "seed_data", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let seed = try? JSONDecoder().decode(SeedData.self, from: data)
        else { return nil }
        return seed
    }

    /// 최초 실행 시 번들 레시피를 SwiftData에 넣는다. 이미 넣었으면 건너뜀.
    static func importIfNeeded(context: ModelContext) {
        let imported = UserDefaults.standard.integer(forKey: seedVersionKey)
        guard let seed = load(), imported < seed.version else { return }

        let existing = (try? context.fetch(FetchDescriptor<Recipe>())) ?? []
        let existingTitles = Set(existing.map(\.title))

        for r in seed.recipes where !existingTitles.contains(r.title) {
            let recipe = Recipe(
                title: r.title,
                category: r.category,
                summary: r.description,
                difficulty: Difficulty(rawValue: r.difficulty) ?? .easy,
                mealType: r.mealType,
                dietaryTags: r.dietaryTags,
                cookingTimeMinutes: r.cookingTimeMinutes,
                servingSize: r.servingSize,
                instructions: r.instructions,
                instructionsEn: r.instructionsEn,
                source: r.source,
                isCustom: false
            )
            context.insert(recipe)
            for (index, ing) in r.ingredients.enumerated() {
                let item = RecipeIngredient(
                    name: ing.name,
                    amount: ing.amount,
                    isOptional: ing.isOptional,
                    orderIndex: index
                )
                item.recipe = recipe
                context.insert(item)
            }
        }

        try? context.save()
        UserDefaults.standard.set(seed.version, forKey: seedVersionKey)
    }
}
