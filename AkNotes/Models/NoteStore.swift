import Foundation

class NoteStore: ObservableObject {
    @Published var notes: [Note] = []
    
    init() {
        // Load sample data for testing
        loadSampleData()
    }
    
    func add(_ note: Note) {
        notes.append(note)
        notes.sort { $0.createdAt > $1.createdAt }
    }
    
    func delete(_ note: Note) {
        notes.removeAll { $0.id == note.id }
    }
    
    func update(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            notes.sort { $0.createdAt > $1.createdAt }
        }
    }
    
    private func loadSampleData() {
        let sampleNotes = [
            Note(
                id: UUID(),
                content: "今天完成了项目的第一阶段，包括用户界面设计和基本功能实现。",
                tag: .todo,
                createdAt: Date().addingTimeInterval(-3600)
            ),
            Note(
                id: UUID(),
                content: "想到了一个新的应用创意：一个基于AI的个人助手应用。",
                tag: .idea,
                createdAt: Date().addingTimeInterval(-7200)
            ),
            Note(
                id: UUID(),
                content: "学习了SwiftUI的新特性，特别是ScrollView和LazyVStack的使用。",
                tag: .tools,
                createdAt: Date().addingTimeInterval(-86400)
            ),
            Note(
                id: UUID(),
                content: "明天需要完成的工作：修复bug，优化性能，准备发布。",
                tag: .general,
                createdAt: Date().addingTimeInterval(-90000)
            )
        ]
        notes = sampleNotes
    }
}