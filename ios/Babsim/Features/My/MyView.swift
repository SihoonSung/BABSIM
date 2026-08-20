import SwiftUI
import SwiftData

struct MyView: View {
    @Query private var recipes: [Recipe]
    @Query(sort: \CookLog.cookedAt, order: .reverse) private var cookLogs: [CookLog]

    private var favorites: [Recipe] {
        recipes.filter(\.isFavorite).sorted { $0.title < $1.title }
    }

    private var myRecipes: [Recipe] {
        recipes.filter(\.isCustom).sorted { $0.createdAt > $1.createdAt }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        stat(count: recipes.count, label: "전체 레시피")
                        Divider()
                        stat(count: myRecipes.count, label: "내 레시피")
                        Divider()
                        stat(count: cookLogs.count, label: "요리 횟수")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                }

                if !favorites.isEmpty {
                    Section("즐겨찾기") {
                        ForEach(favorites) { recipe in
                            NavigationLink {
                                RecipeDetailView(recipe: recipe)
                            } label: {
                                RecipeRow(recipe: recipe)
                            }
                        }
                    }
                }

                if !myRecipes.isEmpty {
                    Section("내가 등록한 레시피") {
                        ForEach(myRecipes) { recipe in
                            NavigationLink {
                                RecipeDetailView(recipe: recipe)
                            } label: {
                                RecipeRow(recipe: recipe)
                            }
                        }
                    }
                }

                if !cookLogs.isEmpty {
                    Section("최근 요리 기록") {
                        ForEach(cookLogs.prefix(15)) { log in
                            HStack(spacing: 10) {
                                if let data = log.photoData, let image = UIImage(data: data) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 44, height: 44)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(log.recipe?.title ?? "삭제된 레시피")
                                        .font(.subheadline.weight(.medium))
                                    Text(log.cookedAt, style: .date)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("마이")
        }
    }

    private func stat(count: Int, label: String) -> some View {
        VStack(spacing: 2) {
            Text("\(count)")
                .font(.title2.weight(.bold))
                .foregroundStyle(Color("BabsimAccent"))
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
