import SwiftUI
import SwiftData
import PhotosUI

struct CookLogSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    let recipe: Recipe

    @State private var note = ""
    @State private var photoItem: PhotosPickerItem?
    @State private var photoData: Data?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text(recipe.title)
                        .font(.headline)
                }
                Section("한 줄 메모 (선택)") {
                    TextField("예: 고추장 반 큰술 줄이는 게 낫다", text: $note, axis: .vertical)
                }
                Section("사진 (선택)") {
                    PhotosPicker(selection: $photoItem, matching: .images) {
                        if let data = photoData, let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 160)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            Label("사진 선택", systemImage: "photo.on.rectangle")
                        }
                    }
                }
            }
            .navigationTitle("요리 기록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") { save() }
                }
            }
            .onChange(of: photoItem) {
                Task {
                    if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                        photoData = ImageResizer.resizedJPEG(from: data)
                    }
                }
            }
        }
    }

    private func save() {
        let log = CookLog(note: note.trimmingCharacters(in: .whitespacesAndNewlines))
        log.photoData = photoData
        log.recipe = recipe
        context.insert(log)
        try? context.save()
        dismiss()
    }
}

enum ImageResizer {
    /// SwiftData에 원본 사진을 그대로 넣지 않도록 긴 변 1200px, JPEG 0.75로 줄인다.
    static func resizedJPEG(from data: Data, maxDimension: CGFloat = 1200) -> Data? {
        guard let image = UIImage(data: data) else { return nil }
        let size = image.size
        let longest = max(size.width, size.height)
        guard longest > maxDimension else {
            return image.jpegData(compressionQuality: 0.75)
        }
        let scale = maxDimension / longest
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resized = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return resized.jpegData(compressionQuality: 0.75)
    }
}
