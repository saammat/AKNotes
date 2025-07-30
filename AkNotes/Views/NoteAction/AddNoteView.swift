import SwiftUI

struct AddNoteView: View {
    let onSave: (Note) -> Void
    let onCancel: () -> Void
    
    @State private var content = ""
    @State private var selectedTag: NoteTag = .general
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("笔记内容")) {
                    TextEditor(text: $content)
                        .frame(minHeight: 150)
                }
                
                Section(header: Text("标签")) {
                    Picker("选择标签", selection: $selectedTag) {
                        ForEach(NoteTag.allCases, id: \.self) { tag in
                            HStack {
                                Image(systemName: tagIcon(for: tag))
                                    .foregroundColor(tagColor(for: tag))
                                Text(tag.displayName)
                            }
                            .tag(tag)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("添加笔记")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        onCancel()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        let newNote = Note(
                            id: UUID(),
                            content: content,
                            tag: selectedTag,
                            createdAt: Date()
                        )
                        onSave(newNote)
                    }
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func tagIcon(for tag: NoteTag) -> String {
        switch tag {
        case .todo: return "checkmark.circle.fill"
        case .idea: return "lightbulb.fill"
        case .tools: return "wrench.fill"
        case .general: return "note"
        }
    }
    
    private func tagColor(for tag: NoteTag) -> Color {
        switch tag {
        case .todo: return .systemRed
        case .idea: return .systemGreen
        case .tools: return .systemBlue
        case .general: return .systemGray
        }
    }
}