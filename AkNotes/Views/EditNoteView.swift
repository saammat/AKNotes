import SwiftUI

struct EditNoteView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: NotesViewModel
    
    let note: Note
    
    @State private var content: String
    @State private var selectedTag: NoteTag
    @State private var selectedDate: Date
    
    init(viewModel: NotesViewModel, note: Note) {
        self.viewModel = viewModel
        self.note = note
        self._content = State(initialValue: note.content)
        self._selectedTag = State(initialValue: note.tag)
        self._selectedDate = State(initialValue: note.createdAt)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("内容") {
                    TextField("笔记内容", text: $content, axis: .vertical)
                        .lineLimit(3...6)
                        .font(.system(.body, design: .rounded))
                }
                
                Section("标签") {
                    HStack(spacing: 8) {
                        ForEach(NoteTag.allCases, id: \.self) { tag in
                            CompactTagChip(
                                tag: tag,
                                isSelected: selectedTag == tag,
                                action: {
                                    selectedTag = tag
                                }
                            )
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                
                Section("时间") {
                    DatePicker("日期", selection: $selectedDate, displayedComponents: [.date])
                    
                    DatePicker("时间", selection: $selectedDate, displayedComponents: [.hourAndMinute])
                }
                
                Section("预览") {
                    TimelineNoteCard(
                        note: Note(
                            content: content,
                            tag: selectedTag,
                            createdAt: selectedDate
                        ),
                        onDelete: { _ in },
                        onEdit: {}
                    )
                    .padding(.horizontal, 0)
                }
            }
            .navigationTitle("编辑笔记")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveChanges()
                    }
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func saveChanges() {
        viewModel.updateNote(
            note,
            newContent: content.trimmingCharacters(in: .whitespacesAndNewlines),
            newTag: selectedTag,
            newDate: selectedDate
        )
        dismiss()
    }
    
    private func tagIcon(for tag: NoteTag) -> String {
        switch tag {
        case .todo: return "checkmark.circle"
        case .idea: return "lightbulb"
        case .tools: return "wrench"
        case .general: return "note"
        }
    }
}

struct EditNoteView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = NotesViewModel()
        let note = Note(content: "测试笔记", tag: .idea)
        return EditNoteView(viewModel: viewModel, note: note)
    }
}
