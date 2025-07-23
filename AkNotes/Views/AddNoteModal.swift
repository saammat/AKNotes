import SwiftUI

struct AddNoteModal: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: NotesViewModel
    
    @State private var content: String = ""
    @State private var selectedTag: NoteTag = .general
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section("内容") {
                    TextEditor(text: $content)
                        .font(.body)
                        .frame(minHeight: 120)
                        .focused($isTextFieldFocused)
                        .keyboardType(.default)
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
            }
            .navigationTitle("新建笔记")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                DispatchQueue.main.async {
                    isTextFieldFocused = true
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("添加") {
                        addNote()
                    }
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func tagIcon(for tag: NoteTag) -> String {
        switch tag {
        case .todo: return "checkmark.circle"
        case .idea: return "lightbulb"
        case .tools: return "wrench"
        case .general: return "note"
        }
    }
    
    private func addNote() {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newNote = Note(
            content: content.trimmingCharacters(in: .whitespacesAndNewlines),
            tag: selectedTag
        )
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            viewModel.notes.insert(newNote, at: 0)
            viewModel.saveNotes()
            HapticManager.shared.playSuccess()
            dismiss()
        }
    }
}

struct TagSelectionChip: View {
    let tag: NoteTag
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: tagIcon(for: tag))
                    .font(.system(size: 12, weight: .semibold))
                
                Text(tag.displayName)
                    .font(.system(.caption, design: .rounded, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? AnyShapeStyle(iOSDesignSystem.Colors.accent200) : AnyShapeStyle(Color(.tertiarySystemFill)))
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(ScaleButtonStyle())
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

struct AddNoteModal_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteModal(viewModel: NotesViewModel())
    }
}
