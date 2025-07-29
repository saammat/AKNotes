import SwiftUI

struct TagsListView: View {
    @State private var tags: [NoteTag] = NoteTag.allCases
    @State private var searchText = ""
    
    var filteredTags: [NoteTag] {
        if searchText.isEmpty {
            return tags
        } else {
            return tags.filter { $0.displayName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.md)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredTags, id: \.self) { tag in
                        tagCard(for: tag)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.md)
            }
        }
        .background(Color.clear)
    }
    
    private func tagCard(for tag: NoteTag) -> some View {
        HStack(spacing: 16) {
            Image(systemName: tagIcon(for: tag))
                .foregroundColor(tagColor(for: tag))
                .font(.system(size: 20, weight: .semibold))
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(tagColor(for: tag).opacity(0.1))
                )
            
            HStack() {
                Text(tag.displayName)
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(noteCount(for: tag)) 个笔记")
                    .font(.system(.callout, design: .rounded))
                    .foregroundColor(.secondary)
                
//                Text("\(noteCount(for: tag))")
//                    .font(.system(.callout, design: .rounded, weight: .semibold))
//                    .foregroundColor(.secondary)
//                    .padding(.horizontal, 12)
//                    .padding(.vertical, 6)
//                    .background(
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(Color(.tertiarySystemFill))
//                            .frame(width: 64, height: 24)
//                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
//        .background(
//            RoundedRectangle(cornerRadius: 12)
//                .fill(Color(.systemBackground))
//                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
//        )
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
        case .todo: return iOSDesignSystem.Colors.todo
        case .idea: return iOSDesignSystem.Colors.idea
        case .tools: return iOSDesignSystem.Colors.tools
        case .general: return iOSDesignSystem.Colors.general
        }
    }
    
    private func noteCount(for tag: NoteTag) -> Int {
        // Placeholder - will be implemented with actual data
        return Int.random(in: 1...20)
    }
}

struct NotesForTagView: View {
    let tag: NoteTag
    
    var body: some View {
        Text("Notes for \(tag.displayName)")
            .navigationTitle(tag.displayName)
    }
}

struct AddTagView: View {
    let onSave: (NoteTag) -> Void
    let onCancel: () -> Void
    
    @State private var tagName = ""
    @State private var selectedTagType: NoteTag = .general
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("标签信息")) {
                    TextField("标签名称", text: $tagName)
                        .font(.system(.body, design: .rounded))
                    
                    Picker("标签类型", selection: $selectedTagType) {
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
            .navigationTitle("添加标签")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        onCancel()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        onSave(selectedTagType)
                    }
                    .disabled(tagName.isEmpty)
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
        case .todo: return iOSDesignSystem.Colors.todo
        case .idea: return iOSDesignSystem.Colors.idea
        case .tools: return iOSDesignSystem.Colors.tools
        case .general: return iOSDesignSystem.Colors.general
        }
    }
}
