import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var recipes: [Recipe]
    @Query(sort: \FridgeItem.addedAt, order: .reverse) private var fridgeItems: [FridgeItem]
    @State private var showFridgeSheet = false

    private var matches: [RecipeMatch] {
        Recommender.match(recipes: recipes, fridgeNames: fridgeItems.map(\.name))
    }

    private var readyNow: [RecipeMatch] {
        matches.filter { $0.score >= 1.0 }
    }

    private var almostReady: [RecipeMatch] {
        matches.filter { $0.score >= 0.5 && $0.score < 1.0 }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    fridgeSummary

                    if fridgeItems.isEmpty {
                        ContentUnavailableView(
                            "냉장고가 비어있어요",
                            systemImage: "refrigerator",
                            description: Text("냉장고 탭에서 가지고 있는 재료를 넣으면\n지금 만들 수 있는 요리를 추천해드려요.")
                        )
                        .padding(.top, 40)
                    } else {
                        if !readyNow.isEmpty {
                            section(title: "지금 바로 만들 수 있어요 🔥", items: readyNow)
                        }
                        if !almostReady.isEmpty {
                            section(title: "재료 몇 개만 더 있으면 돼요", items: Array(almostReady.prefix(10)))
                        }
                        if readyNow.isEmpty && almostReady.isEmpty {
                            ContentUnavailableView(
                                "아직 만들 수 있는 요리가 없어요",
                                systemImage: "frying.pan",
                                description: Text("재료를 더 추가하거나, 레시피 탭에서\n내 레시피를 직접 등록해보세요.")
                            )
                            .padding(.top, 40)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("밥심")
            .sheet(isPresented: $showFridgeSheet) {
                AddIngredientSheet()
            }
        }
    }

    private var fridgeSummary: some View {
        Button {
            showFridgeSheet = true
        } label: {
            HStack {
                Image(systemName: "refrigerator.fill")
                    .font(.title2)
                    .foregroundStyle(Color("BabsimAccent"))
                VStack(alignment: .leading, spacing: 2) {
                    Text("내 냉장고")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text(fridgeItems.isEmpty
                         ? "재료를 추가해보세요"
                         : "\(fridgeItems.count)개 재료 보유 중")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
                    .foregroundStyle(Color("BabsimAccent"))
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func section(title: String, items: [RecipeMatch]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.weight(.bold))

            ForEach(items) { match in
                NavigationLink {
                    RecipeDetailView(recipe: match.recipe)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            RecipeRow(recipe: match.recipe)
                            MatchScoreBadge(score: match.score)
                        }
                        if !match.missing.isEmpty {
                            Text("부족한 재료: \(match.missing.joined(separator: ", "))")
                                .font(.caption)
                                .foregroundStyle(.orange)
                                .lineLimit(2)
                        }
                    }
                    .padding(12)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
