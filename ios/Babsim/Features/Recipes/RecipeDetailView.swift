import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var fridgeItems: [FridgeItem]

    let recipe: Recipe

    @State private var showEditForm = false
    @State private var showDeleteConfirm = false
    @State private var showCookedSheet = false
    @State private var showEnglish = false

    private var fridgeNames: Set<String> {
        Set(fridgeItems.map { $0.name.lowercased() })
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                ingredientSection
                instructionSection
                if !recipe.source.isEmpty {
                    Text("출처: \(recipe.source)")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                cookLogSection
            }
            .padding()
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    recipe.isFavorite.toggle()
                    try? context.save()
                } label: {
                    Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(recipe.isFavorite ? .red : .primary)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        showEditForm = true
                    } label: {
                        Label("수정", systemImage: "pencil")
                    }
                    Button(role: .destructive) {
                        showDeleteConfirm = true
                    } label: {
                        Label("삭제", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                showCookedSheet = true
            } label: {
                Label("요리했어요", systemImage: "frying.pan.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color("BabsimAccent"))
            .padding()
            .background(.ultraThinMaterial)
        }
        .sheet(isPresented: $showEditForm) {
            RecipeFormView(recipe: recipe)
        }
        .sheet(isPresented: $showCookedSheet) {
            CookLogSheet(recipe: recipe)
        }
        .confirmationDialog("이 레시피를 삭제할까요?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("삭제", role: .destructive) {
                context.delete(recipe)
                try? context.save()
                dismiss()
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let data = recipe.imageData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            RecipeMetaLine(recipe: recipe)
            if !recipe.summary.isEmpty {
                Text(recipe.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            if !recipe.dietaryTags.isEmpty {
                HStack(spacing: 6) {
                    ForEach(recipe.dietaryTags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption2)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Color(.secondarySystemFill))
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }

    private var ingredientSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("재료")
                .font(.title3.weight(.bold))
            ForEach(recipe.sortedIngredients) { ingredient in
                HStack {
                    Image(systemName: fridgeNames.contains(ingredient.name.lowercased())
                          ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(fridgeNames.contains(ingredient.name.lowercased())
                                         ? Color("BabsimAccent") : Color(.tertiaryLabel))
                    Text(ingredient.name)
                    if ingredient.isOptional {
                        Text("선택")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(ingredient.amount)
                        .foregroundStyle(.secondary)
                }
                .font(.subheadline)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var instructionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("만드는 법")
                    .font(.title3.weight(.bold))
                Spacer()
                if !recipe.instructionsEn.isEmpty {
                    Button(showEnglish ? "한국어" : "English") {
                        showEnglish.toggle()
                    }
                    .font(.caption)
                }
            }
            Text(showEnglish && !recipe.instructionsEn.isEmpty
                 ? recipe.instructionsEn : recipe.instructions)
                .font(.subheadline)
                .lineSpacing(5)
        }
    }

    private var cookLogSection: some View {
        let logs = (recipe.cookLogs ?? []).sorted { $0.cookedAt > $1.cookedAt }
        return Group {
            if !logs.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("요리 기록 \(logs.count)회")
                        .font(.title3.weight(.bold))
                    ForEach(logs) { log in
                        HStack(alignment: .top, spacing: 10) {
                            if let data = log.photoData, let image = UIImage(data: data) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(log.cookedAt, style: .date)
                                    .font(.caption.weight(.medium))
                                if !log.note.isEmpty {
                                    Text(log.note)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}
