import SwiftUI

struct TagsListView: View {
    let onAddTag: () -> Void
    let onDeleteTag: (CustomTag) -> Void
    let allTags: [CustomTag]
    let notes: [Note]
    @State private var searchText = ""
    
    var filteredTags: [CustomTag] {
        if searchText.isEmpty {
            return allTags
        } else {
            return allTags.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.top, AppSpacing.md)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredTags, id: \.id) { tag in
                            tagCard(for: tag)
                        }
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.md)
                }
            }
            
            FloatingAddButton {
                onAddTag()
            }
            .padding(.trailing, AppSpacing.md)
            .padding(.bottom, AppSpacing.xl)
        }
        .background(Color.clear)
    }
    
    private func noteCount(for tag: CustomTag) -> Int {
        return notes.filter { note in
            if let customTag = note.customTag {
                return customTag.id == tag.id
            } else {
                // For predefined tags, match by name
                return note.tag.displayName == tag.name
            }
        }.count
    }
    
    private func tagCard(for tag: CustomTag) -> some View {
        HStack(spacing: 16) {
            Image(systemName: tag.icon)
                .foregroundColor(tag.tagColor)
                .font(.system(size: 20, weight: .semibold))
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(tag.tagColor.opacity(0.1))
                )
            
            HStack() {
                Text(tag.name)
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(noteCount(for: tag)) 个笔记")
                    .font(.system(.callout, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .contextMenu {
            // 预定义标签不允许删除
            let predefinedTagNames = NoteTag.allCases.map { $0.displayName }
            if !predefinedTagNames.contains(tag.name) {
                Button(role: .destructive) {
                    onDeleteTag(tag)
                    HapticManager.shared.playSuccess()
                } label: {
                    Label("删除", systemImage: "trash")
                }
            }
        }
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
    let onSave: (CustomTag) -> Void
    let onCancel: () -> Void
    
    @State private var tagName = ""
    @State private var selectedIcon: String = "tag"
    
    private let availableIcons = [
        "star", "heart", "bookmark", "flag", "bell", "tag", "folder", "doc", "paperclip",
        "camera", "music.note", "headphones", "mic", "video", "gamecontroller", "gift",
        "leaf", "flame", "snow", "cloud", "moon", "sun", "rainbow", "bolt",
        "car", "airplane", "train", "bus", "bicycle", "ship", "location", "map",
        "cart", "bag", "creditcard", "dollarsign", "percent", "chart.bar", "chart.pie",
        "book", "graduationcap", "briefcase", "house", "building", "tree", "cup",
        "pencil", "scissors", "paintbrush", "trash", "folder.fill", "doc.fill"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("标签信息")) {
                    TextField("标签名称", text: $tagName)
                        .font(.system(.body, design: .rounded))
                }
                
                Section(header: Text("标签图标")) {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ], spacing: 12) {
                            ForEach(availableIcons, id: \.self) { icon in
                                Button(action: {
                                    selectedIcon = icon
                                }) {
                                    Image(systemName: icon)
                                        .font(.system(size: 20))
                                        .foregroundColor(selectedIcon == icon ? .white : .primary)
                                        .frame(width: 50, height: 50)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(selectedIcon == icon ? iOSDesignSystem.Colors.primary200 : iOSDesignSystem.Colors.bg200)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                    .frame(height: 220)
                }
                
                Section(header: Text("预览")) {
                    HStack {
                        Image(systemName: selectedIcon)
                            .foregroundColor(iOSDesignSystem.Colors.primary200)
                            .font(.system(size: 20))
                        Text(tagName.isEmpty ? "标签名称" : tagName)
                            .font(.system(.body, design: .rounded, weight: .medium))
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding()
                    .background(iOSDesignSystem.Colors.bg200)
                    .cornerRadius(8)
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
                        let customTag = CustomTag(name: tagName, icon: selectedIcon)
                        onSave(customTag)
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
