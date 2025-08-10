import SwiftUI

struct AddNoteView: View {
    let onSave: (Note) -> Void
    let onCancel: () -> Void
    let customTags: [CustomTag]
    
    @State private var content = ""
    @State private var selectedTag: NoteTag = .general
    @State private var selectedCustomTag: CustomTag? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("笔记内容")) {
                    TextEditor(text: $content)
                        .frame(minHeight: 150)
                }
                
                Section("标签") {
                    Menu {
                        // 预定义标签
                        Section("预定义标签") {
                            ForEach(NoteTag.allCases, id: \.self) { tag in
                                Button(action: {
                                    selectedTag = tag
                                    selectedCustomTag = nil
                                }) {
                                    HStack {
                                        Image(systemName: tagIcon(for: tag))
                                            .foregroundColor(tagColor(for: tag))
                                        Text(tag.displayName)
                                        Spacer()
                                        if selectedTag == tag && selectedCustomTag == nil {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(iOSDesignSystem.Colors.primary200)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // 自定义标签
                        if !customTags.isEmpty {
                            Section("自定义标签") {
                                ForEach(customTags, id: \.id) { customTag in
                                    Button(action: {
                                        selectedTag = .general
                                        selectedCustomTag = customTag
                                    }) {
                                        HStack {
                                            Image(systemName: customTag.icon)
                                                .foregroundColor(customTag.tagColor)
                                            Text(customTag.name)
                                            Spacer()
                                            if selectedCustomTag?.id == customTag.id {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(iOSDesignSystem.Colors.primary200)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text("选择标签")
                                .foregroundColor(iOSDesignSystem.Colors.primary200)
                            Spacer()
                            if let customTag = selectedCustomTag {
                                HStack {
                                    Image(systemName: customTag.icon)
                                        .foregroundColor(customTag.tagColor)
                                    Text(customTag.name)
                                        .foregroundColor(iOSDesignSystem.Colors.primary200)
                                }
                            } else {
                                HStack {
                                    Image(systemName: tagIcon(for: selectedTag))
                                        .foregroundColor(tagColor(for: selectedTag))
                                    Text(selectedTag.displayName)
                                        .foregroundColor(iOSDesignSystem.Colors.primary200)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("添加笔记")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        onCancel()
                    }
                    .foregroundColor(iOSDesignSystem.Colors.primary200)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        let newNote = Note(
                            id: UUID(),
                            content: content,
                            tag: selectedTag,
                            customTag: selectedCustomTag,
                            createdAt: Date()
                        )
                        onSave(newNote)
                    }
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .foregroundColor(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : iOSDesignSystem.Colors.primary200)
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