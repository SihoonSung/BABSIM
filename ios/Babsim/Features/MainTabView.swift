import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("홈", systemImage: "house.fill") }

            FridgeView()
                .tabItem { Label("냉장고", systemImage: "refrigerator.fill") }

            RecipeListView()
                .tabItem { Label("레시피", systemImage: "book.fill") }

            MyView()
                .tabItem { Label("마이", systemImage: "person.fill") }
        }
        .tint(Color("BabsimAccent"))
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [Recipe.self, FridgeItem.self], inMemory: true)
}
