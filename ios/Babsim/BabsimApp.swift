import SwiftUI
import SwiftData

@main
struct BabsimApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: Recipe.self, RecipeIngredient.self, FridgeItem.self, CookLog.self
            )
            SeedImporter.importIfNeeded(context: container.mainContext)
        } catch {
            fatalError("SwiftData container 초기화 실패: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(container)
    }
}
