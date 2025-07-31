import SwiftUI

struct EditNoteView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: NotesViewModel
    
    let note: Note
    let customTags: [CustomTag]
    
    @State private var content: String
    @State private var selectedTag: NoteTag
    @State private var selectedCustomTag: CustomTag?
    @State private var selectedDate: Date
    
    init(viewModel: NotesViewModel, note: Note, customTags: [CustomTag] = []) {
        self.viewModel = viewModel
        self.note = note
        self.customTags = customTags
        self._content = State(initialValue: note.content)
        self._selectedTag = State(initialValue: note.tag)
        self._selectedCustomTag = State(initialValue: note.customTag)
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
                    
                    if !customTags.isEmpty {
                        Picker("自定义标签", selection: $selectedCustomTag) {
                            Text("无").tag(nil as CustomTag?)
                            ForEach(customTags, id: \.id) { customTag in
                                HStack {
                                    Image(systemName: customTag.icon)
                                        .foregroundColor(customTag.tagColor)
                                    Text(customTag.name)
                                }
                                .tag(customTag as CustomTag?)
                            }
                        }
                        .pickerStyle(.menu)
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
                            customTag: selectedCustomTag,
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
                    .foregroundColor(iOSDesignSystem.Colors.primary200)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveChanges()
                    }
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .foregroundColor(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : iOSDesignSystem.Colors.primary200)
                }
            }
        }
    }
    
    private func saveChanges() {
        viewModel.updateNote(
            note,
            newContent: content.trimmingCharacters(in: .whitespacesAndNewlines),
            newTag: selectedTag,
            newCustomTag: selectedCustomTag,
            newDate: selectedDate
        )
        dismiss()
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

struct EditNoteView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = NotesViewModel()
        let note = Note(content: "测试笔记", tag: .idea)
        return EditNoteView(viewModel: viewModel, note: note)
    }
}
