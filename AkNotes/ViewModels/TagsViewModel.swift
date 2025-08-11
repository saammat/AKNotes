import Foundation
import SwiftUI

@MainActor
class TagsViewModel: ObservableObject {
    @Published var customTags: [CustomTag] = []
    
    private let saveKey = "saved_custom_tags"
    
    init() {
        loadTags()
    }
    
    func addTag(_ tag: CustomTag) {
        customTags.append(tag)
        saveTags()
    }
    
    func deleteTag(_ tag: CustomTag) {
        customTags.removeAll { $0.id == tag.id }
        saveTags()
    }
    
    func updateTag(_ tag: CustomTag) {
        if let index = customTags.firstIndex(where: { $0.id == tag.id }) {
            customTags[index] = tag
            saveTags()
        }
    }
    
    func getTag(by id: UUID) -> CustomTag? {
        return customTags.first { $0.id == id }
    }
    
    func saveTags() {
        DispatchQueue.global(qos: .background).async {
            if let encoded = try? JSONEncoder().encode(self.customTags) {
                UserDefaults.standard.set(encoded, forKey: self.saveKey)
            }
        }
    }
    
    private func loadTags() {
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = UserDefaults.standard.data(forKey: self.saveKey) {
                if let decoded = try? JSONDecoder().decode([CustomTag].self, from: data) {
                    DispatchQueue.main.async {
                        self.customTags = decoded
                    }
                }
            }
        }
    }
}