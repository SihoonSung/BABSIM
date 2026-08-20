import SwiftUI
import SwiftData

struct FridgeView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \FridgeItem.name) private var items: [FridgeItem]
    @State private var showAddSheet = false

    private var grouped: [(category: String, items: [FridgeItem])] {
        let dict = Dictionary(grouping: items, by: \.category)
        return IngredientCatalog.categories
            .compactMap { cat in
                guard let list = dict[cat], !list.isEmpty else { return nil }
                return (cat, list)
            }
    }

    var body: some View {
        NavigationStack {
            Group {
                if items.isEmpty {
                    ContentUnavailableView(
                        "냉장고가 비어있어요",
                        systemImage: "refrigerator",
                        description: Text("오른쪽 위 + 버튼으로 재료를 추가하세요.")
                    )
                } else {
                    List {
                        ForEach(grouped, id: \.category) { group in
                            Section(group.category) {
                                ForEach(group.items) { item in
                                    HStack {
                                        Text(item.name)
                                        Spacer()
                                        if !item.memo.isEmpty {
                                            Text(item.memo)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                                .onDelete { offsets in
                                    delete(offsets, in: group.items)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("냉장고")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddIngredientSheet()
            }
        }
    }

    private func delete(_ offsets: IndexSet, in groupItems: [FridgeItem]) {
        for index in offsets {
            context.delete(groupItems[index])
        }
        try? context.save()
    }
}
