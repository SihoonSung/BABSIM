import SwiftUI

struct RecipeThumbnail: View {
    let recipe: Recipe
    var size: CGFloat = 56

    var body: some View {
        Group {
            if let data = recipe.imageData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    Text(emoji)
                        .font(.system(size: size * 0.45))
                }
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: size * 0.22, style: .continuous))
    }

    private var emoji: String {
        switch recipe.category {
        case "Korean": return "🍚"
        case "Japanese": return "🍜"
        case "Italian": return "🍝"
        case "Western": return "🍳"
        default: return "🥘"
        }
    }

    private var gradientColors: [Color] {
        switch recipe.category {
        case "Korean": return [Color(red: 1.0, green: 0.62, blue: 0.42), Color(red: 0.95, green: 0.40, blue: 0.30)]
        case "Japanese": return [Color(red: 0.55, green: 0.70, blue: 0.95), Color(red: 0.35, green: 0.50, blue: 0.85)]
        case "Italian": return [Color(red: 0.95, green: 0.75, blue: 0.40), Color(red: 0.88, green: 0.55, blue: 0.25)]
        case "Western": return [Color(red: 0.60, green: 0.82, blue: 0.60), Color(red: 0.38, green: 0.65, blue: 0.45)]
        default: return [Color.gray.opacity(0.5), Color.gray]
        }
    }
}

struct DifficultyBadge: View {
    let difficulty: Difficulty

    var body: some View {
        Text(difficulty.label)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }

    private var color: Color {
        switch difficulty {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
}

struct RecipeMetaLine: View {
    let recipe: Recipe

    var body: some View {
        HStack(spacing: 8) {
            DifficultyBadge(difficulty: recipe.difficulty)
            if recipe.cookingTimeMinutes > 0 {
                Label("\(recipe.cookingTimeMinutes)분", systemImage: "clock")
            }
            if recipe.servingSize > 0 {
                Label("\(recipe.servingSize)인분", systemImage: "person.2")
            }
            if recipe.isCustom {
                Text("내 레시피")
                    .font(.caption2.weight(.semibold))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(Color("BabsimAccent").opacity(0.15))
                    .foregroundStyle(Color("BabsimAccent"))
                    .clipShape(Capsule())
            }
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }
}

struct RecipeRow: View {
    let recipe: Recipe

    var body: some View {
        HStack(spacing: 12) {
            RecipeThumbnail(recipe: recipe)
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(recipe.title)
                        .font(.headline)
                        .lineLimit(1)
                    if recipe.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
                RecipeMetaLine(recipe: recipe)
            }
            Spacer()
        }
        .contentShape(Rectangle())
    }
}

struct MatchScoreBadge: View {
    let score: Double

    var body: some View {
        Text(score >= 1.0 ? "지금 가능" : "\(Int(score * 100))%")
            .font(.caption.weight(.bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(score >= 1.0 ? Color.green.opacity(0.15) : Color.orange.opacity(0.15))
            .foregroundStyle(score >= 1.0 ? Color.green : Color.orange)
            .clipShape(Capsule())
    }
}
