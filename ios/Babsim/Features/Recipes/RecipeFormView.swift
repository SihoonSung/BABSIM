import SwiftUI
import SwiftData
import PhotosUI

struct RecipeFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    /// nil이면 새 레시피 등록, 값이 있으면 수정
    let recipe: Recipe?

    struct IngredientDraft: Identifiable {
        let id = UUID()
        var name = ""
        var amount = ""
        var isOptional = false
    }

    @State private var title = ""
    @State private var category = "Korean"
    @State private var difficulty: Difficulty = .easy
    @State private var cookingTime = 20
    @State private var servings = 2
    @State private var summary = ""
    @State private var instructions = ""
    @State private var source = ""
    @State private var drafts: [IngredientDraft] = [IngredientDraft()]
    @State private var photoItem: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var loaded = false

    private var validDrafts: [IngredientDraft] {
        drafts.filter { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
            && !validDrafts.isEmpty
            && !instructions.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("기본 정보") {
                    TextField("레시피 이름", text: $title)
                    Picker("카테고리", selection: $category) {
                        ForEach(RecipeCategory.known, id: \.key) { item in
                            Text(item.label).tag(item.key)
                        }
                    }
                    Picker("난이도", selection: $difficulty) {
                        ForEach(Difficulty.allCases) { diff in
                            Text(diff.label).tag(diff)
                        }
                    }
                    Stepper("조리 시간: \(cookingTime)분", value: $cookingTime, in: 5...240, step: 5)
                    Stepper("\(servings)인분", value: $servings, in: 1...12)
                    TextField("한 줄 소개 (선택)", text: $summary)
                }

                Section("사진 (선택)") {
                    PhotosPicker(selection: $photoItem, matching: .images) {
                        if let data = photoData, let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            Label("사진 선택", systemImage: "photo.on.rectangle")
                        }
                    }
                    if photoData != nil {
                        Button("사진 제거", role: .destructive) {
                            photoData = nil
                            photoItem = nil
                        }
                    }
                }

                Section {
                    ForEach($drafts) { $draft in
                        VStack(spacing: 6) {
                            HStack {
                                TextField("재료 이름", text: $draft.name)
                                TextField("양 (예: 2큰술)", text: $draft.amount)
                                    .frame(width: 110)
                                    .multilineTextAlignment(.trailing)
                            }
                            Toggle("선택 재료 (없어도 됨)", isOn: $draft.isOptional)
                                .font(.caption)
                                .tint(Color("BabsimAccent"))
                        }
                    }
                    .onDelete { offsets in
                        drafts.remove(atOffsets: offsets)
                        if drafts.isEmpty { drafts = [IngredientDraft()] }
                    }
                    Button {
                        drafts.append(IngredientDraft())
                    } label: {
                        Label("재료 추가", systemImage: "plus.circle.fill")
                    }
                } header: {
                    Text("재료")
                } footer: {
                    Text("재료 이름을 냉장고 재료와 똑같이 쓰면 추천에 정확히 반영돼요.")
                }

                Section("만드는 법") {
                    TextEditor(text: $instructions)
                        .frame(minHeight: 180)
                }

                Section("출처 (선택)") {
                    TextField("예: 엄마 레시피, 유튜브 채널명", text: $source)
                }
            }
            .navigationTitle(recipe == nil ? "레시피 등록" : "레시피 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") { save() }
                        .disabled(!canSave)
                }
            }
            .onAppear(perform: loadIfNeeded)
            .onChange(of: photoItem) {
                Task {
                    if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                        photoData = ImageResizer.resizedJPEG(from: data)
                    }
                }
            }
        }
    }

    private func loadIfNeeded() {
        guard !loaded, let recipe else {
            loaded = true
            return
        }
        loaded = true
        title = recipe.title
        category = recipe.category
        difficulty = recipe.difficulty
        cookingTime = max(recipe.cookingTimeMinutes, 5)
        servings = max(recipe.servingSize, 1)
        summary = recipe.summary
        instructions = recipe.instructions
        source = recipe.source
        photoData = recipe.imageData
        let existing = recipe.sortedIngredients.map {
            IngredientDraft(name: $0.name, amount: $0.amount, isOptional: $0.isOptional)
        }
        drafts = existing.isEmpty ? [IngredientDraft()] : existing
    }

    private func save() {
        let target: Recipe
        if let recipe {
            target = recipe
        } else {
            target = Recipe(title: "", isCustom: true)
            context.insert(target)
        }

        target.title = title.trimmingCharacters(in: .whitespaces)
        target.category = category
        target.difficulty = difficulty
        target.cookingTimeMinutes = cookingTime
        target.servingSize = servings
        target.summary = summary.trimmingCharacters(in: .whitespaces)
        target.instructions = instructions.trimmingCharacters(in: .whitespacesAndNewlines)
        target.source = source.trimmingCharacters(in: .whitespaces)
        target.imageData = photoData

        for old in target.ingredients ?? [] {
            context.delete(old)
        }
        for (index, draft) in validDrafts.enumerated() {
            let item = RecipeIngredient(
                name: draft.name.trimmingCharacters(in: .whitespaces),
                amount: draft.amount.trimmingCharacters(in: .whitespaces),
                isOptional: draft.isOptional,
                orderIndex: index
            )
            item.recipe = target
            context.insert(item)
        }

        try? context.save()
        dismiss()
    }
}
