import SwiftUI
import SwiftData

struct AddIngredientSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query private var existing: [FridgeItem]

    @State private var query = ""
    @State private var customCategory = "기타"

    private var ownedNames: Set<String> { Set(existing.map(\.name)) }

    private var results: [CatalogIngredient] {
        IngredientCatalog.shared.search(query)
    }

    private var groupedResults: [(category: String, items: [CatalogIngredient])] {
        let dict = Dictionary(grouping: results, by: \.category)
        return IngredientCatalog.categories.compactMap { cat in
            guard let list = dict[cat], !list.isEmpty else { return nil }
            return (cat, list)
        }
    }

    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespaces)
    }

    private var canAddCustom: Bool {
        !trimmedQuery.isEmpty
            && !ownedNames.contains(trimmedQuery)
            && !results.contains { $0.name == trimmedQuery }
    }

    var body: some View {
        NavigationStack {
            List {
                // 나중에 on-device 사진 인식(CoreML/Vision) 붙일 자리
                Section {
                    Label("사진으로 재료 인식 — 준비 중", systemImage: "camera.viewfinder")
                        .foregroundStyle(.tertiary)
                }

                if canAddCustom {
                    Section("직접 추가") {
                        HStack {
                            Text("\"\(trimmedQuery)\" 추가")
                            Spacer()
                            Picker("", selection: $customCategory) {
                                ForEach(IngredientCatalog.categories, id: \.self) { Text($0) }
                            }
                            .labelsHidden()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            add(name: trimmedQuery, category: customCategory)
                        }
                    }
                }

                ForEach(groupedResults, id: \.category) { group in
                    Section(group.category) {
                        ForEach(group.items) { ingredient in
                            Button {
                                toggle(ingredient)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(ingredient.name)
                                            .foregroundStyle(.primary)
                                        Text(ingredient.nameEn)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    if ownedNames.contains(ingredient.name) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(Color("BabsimAccent"))
                                    } else {
                                        Image(systemName: "plus.circle")
                                            .foregroundStyle(.tertiary)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "재료 이름 (한글/영어)")
            .navigationTitle("재료 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("완료") { dismiss() }
                }
            }
        }
    }

    private func toggle(_ ingredient: CatalogIngredient) {
        if let item = existing.first(where: { $0.name == ingredient.name }) {
            context.delete(item)
        } else {
            context.insert(FridgeItem(name: ingredient.name, category: ingredient.category))
        }
        try? context.save()
    }

    private func add(name: String, category: String) {
        guard !ownedNames.contains(name) else { return }
        context.insert(FridgeItem(name: name, category: category))
        try? context.save()
        query = ""
    }
}
