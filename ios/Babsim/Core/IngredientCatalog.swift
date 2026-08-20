import Foundation

/// 번들 seed_data.json의 재료 마스터. 냉장고 재료 추가 시 자동완성에 쓴다.
struct CatalogIngredient: Identifiable, Hashable {
    var id: String { name }
    let name: String
    let nameEn: String
    let category: String
}

final class IngredientCatalog {
    static let shared = IngredientCatalog()

    static let categories = [
        "곡물", "육류", "해산물", "채소", "과일",
        "유제품/계란", "두부/콩류", "양념", "기타",
    ]

    let all: [CatalogIngredient]
    private let byName: [String: CatalogIngredient]

    private init() {
        let seed = SeedImporter.load()
        all = (seed?.ingredients ?? []).map {
            CatalogIngredient(name: $0.name, nameEn: $0.nameEn, category: $0.category)
        }
        byName = Dictionary(uniqueKeysWithValues: all.map { ($0.name, $0) })
    }

    func category(for name: String) -> String {
        byName[name]?.category ?? "기타"
    }

    func search(_ query: String) -> [CatalogIngredient] {
        let q = query.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return all }
        let lower = q.lowercased()
        return all.filter {
            $0.name.localizedCaseInsensitiveContains(q)
                || $0.nameEn.lowercased().contains(lower)
        }
    }
}
