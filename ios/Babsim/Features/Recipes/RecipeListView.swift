import SwiftUI
import SwiftData

struct RecipeListView: View {
    @Query(sort: \Recipe.title) private var recipes: [Recipe]

    @State private var query = ""
    @State private var selectedCategory: String? = nil
    @State private var selectedDifficulty: Difficulty? = nil
    @State private var onlyMine = false
    @State private var showForm = false

    private var filtered: [Recipe] {
        recipes.filter { recipe in
            if onlyMine && !recipe.isCustom { return false }
            if let cat = selectedCategory, recipe.category != cat { return false }
            if let diff = selectedDifficulty, recipe.difficulty != diff { return false }
            if !query.isEmpty {
                let inTitle = recipe.title.localizedCaseInsensitiveContains(query)
                let inIngredients = (recipe.ingredients ?? [])
                    .contains { $0.name.localizedCaseInsensitiveContains(query) }
                if !inTitle && !inIngredients { return false }
            }
            return true
        }
    }

    private var usedCategories: [String] {
        var seen = Set<String>()
        var ordered: [String] = []
        for key in RecipeCategory.known.map(\.key) where recipes.contains(where: { $0.category == key }) {
            if seen.insert(key).inserted { ordered.append(key) }
        }
        for recipe in recipes where !seen.contains(recipe.category) {
            seen.insert(recipe.category)
            ordered.append(recipe.category)
        }
        return ordered
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterBar
                List {
                    ForEach(filtered) { recipe in
                        NavigationLink {
                            RecipeDetailView(recipe: recipe)
                        } label: {
                            RecipeRow(recipe: recipe)
                        }
                    }
                }
                .listStyle(.plain)
                .overlay {
                    if filtered.isEmpty {
                        ContentUnavailableView(
                            "레시피가 없어요",
                            systemImage: "book",
                            description: Text("검색어나 필터를 바꾸거나\n+ 버튼으로 새 레시피를 등록해보세요.")
                        )
                    }
                }
            }
            .searchable(text: $query, prompt: "레시피 이름 또는 재료")
            .navigationTitle("레시피")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showForm) {
                RecipeFormView(recipe: nil)
            }
        }
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "내 레시피", isOn: onlyMine) {
                    onlyMine.toggle()
                }
                ForEach(usedCategories, id: \.self) { cat in
                    FilterChip(title: RecipeCategory.label(for: cat), isOn: selectedCategory == cat) {
                        selectedCategory = selectedCategory == cat ? nil : cat
                    }
                }
                ForEach(Difficulty.allCases) { diff in
                    FilterChip(title: diff.label, isOn: selectedDifficulty == diff) {
                        selectedDifficulty = selectedDifficulty == diff ? nil : diff
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isOn ? Color("BabsimAccent") : Color(.secondarySystemFill))
                .foregroundStyle(isOn ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
