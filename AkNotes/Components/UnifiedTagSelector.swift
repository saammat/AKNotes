import SwiftUI

struct UnifiedTagSelector: View {
    @Binding var selectedTag: NoteTag
    @Binding var selectedCustomTag: CustomTag?
    let customTags: [CustomTag]
    
    var body: some View {
        Section(header: Text("标签")) {
            // 统一的标签选择界面
            VStack(spacing: 0) {
                // 预定义标签选择
                ForEach(NoteTag.allCases, id: \.self) { tag in
                    TagSelectionRow(
                        title: tag.displayName,
                        icon: tagIcon(for: tag),
                        color: tagColor(for: tag),
                        isSelected: selectedTag == tag && selectedCustomTag == nil,
                        action: {
                            selectedTag = tag
                            selectedCustomTag = nil
                        }
                    )
                }
                
                // 自定义标签选择
                if !customTags.isEmpty {
                    Divider()
                    
                    ForEach(customTags, id: \.id) { customTag in
                        TagSelectionRow(
                            title: customTag.name,
                            icon: customTag.icon,
                            color: customTag.tagColor,
                            isSelected: selectedCustomTag?.id == customTag.id,
                            action: {
                                selectedCustomTag = customTag
                            }
                        )
                    }
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

struct TagSelectionRow: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 24)
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 18, weight: .medium))
                }
            }
            .padding(.vertical, 4)
            .background(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}