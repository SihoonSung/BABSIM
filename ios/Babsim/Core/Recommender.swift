import Foundation
import SwiftData

struct RecipeMatch: Identifiable {
    let recipe: Recipe
    let score: Double          // 필수 재료 중 보유 비율 0.0 ~ 1.0
    let matched: [String]
    let missing: [String]      // 부족한 필수 재료

    var id: PersistentIdentifier { recipe.persistentModelID }
}

enum Recommender {
    /// 냉장고 재료 이름 기준으로 레시피 매칭 점수를 계산한다.
    static func match(recipes: [Recipe], fridgeNames: [String]) -> [RecipeMatch] {
        let fridge = Set(fridgeNames.map(normalize))

        var results: [RecipeMatch] = []
        for recipe in recipes {
            let required = recipe.requiredIngredientNames
            guard !required.isEmpty else { continue }

            var matched: [String] = []
            var missing: [String] = []
            for name in required {
                if fridge.contains(normalize(name)) {
                    matched.append(name)
                } else {
                    missing.append(name)
                }
            }
            let score = Double(matched.count) / Double(required.count)
            results.append(RecipeMatch(recipe: recipe, score: score, matched: matched, missing: missing))
        }

        return results.sorted {
            if $0.score != $1.score { return $0.score > $1.score }
            return $0.recipe.title < $1.recipe.title
        }
    }

    private static func normalize(_ name: String) -> String {
        name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}
