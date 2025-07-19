import Foundation
import SwiftUI

@MainActor
class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var newContent: String = ""
    @Published var selectedTag: NoteTag = .general
    
    private let saveKey = "saved_notes"
    
    init() {
        loadNotes()
    }
    
    func addNote() {
        guard !newContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newNote = Note(content: newContent.trimmingCharacters(in: .whitespacesAndNewlines), tag: selectedTag)
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            notes.insert(newNote, at: 0) // Add to top (newest first)
            newContent = ""
            HapticManager.shared.playSuccess()
            saveNotes()
        }
    }
    
    func deleteNote(at indexSet: IndexSet) {
        notes.remove(atOffsets: indexSet)
        saveNotes()
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
    
    func updateNote(_ note: Note, newContent: String?, newTag: NoteTag?, newDate: Date?) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            let updatedContent = newContent ?? note.content
            let updatedTag = newTag ?? note.tag
            let updatedDate = newDate ?? note.createdAt
            
            let updatedNote = Note(
                id: note.id,
                content: updatedContent,
                tag: updatedTag,
                createdAt: updatedDate
            )
            
            notes[index] = updatedNote
            saveNotes()
            HapticManager.shared.playSuccess()
        }
    }
    
    func clearAllNotes() {
        notes.removeAll()
        saveNotes()
        HapticManager.shared.playSuccess()
    }
    
    func filterNotes(by tag: NoteTag?) -> [Note] {
        guard let tag = tag else { return notes }
        return notes.filter { $0.tag == tag }
    }
    
    func saveNotes() {
        DispatchQueue.global(qos: .background).async {
            if let encoded = try? JSONEncoder().encode(self.notes) {
                UserDefaults.standard.set(encoded, forKey: self.saveKey)
            }
        }
    }
    
    private func loadNotes() {
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = UserDefaults.standard.data(forKey: self.saveKey) {
                if let decoded = try? JSONDecoder().decode([Note].self, from: data) {
                    DispatchQueue.main.async {
                        self.notes = decoded
                    }
                }
            }
        }
    }
}
