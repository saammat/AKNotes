import SwiftUI

struct TimelineNoteCard: View {
    let note: Note
    let onDelete: (Note) -> Void
    let onEdit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Tag and time row
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: tagIcon)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(tagColor)
                    
                    Text(note.tag.displayName)
                        .font(.system(.caption, weight: .medium))
                        .foregroundColor(tagColor)
                }
                
                Spacer()
                
                Text(note.createdAt, style: .time)
                    .font(.system(.caption, weight: .regular))
                    .foregroundColor(.secondary)
            }
            
            // Content
            Text(note.content)
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(2)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .background(iOSDesignSystem.Colors.bg200)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(iOSDesignSystem.Colors.accent200.opacity(0.1), lineWidth: 1)
        )
        .contextMenu {
            Button(role: .destructive) {
                onDelete(note)
            } label: {
                Label("删除", systemImage: "trash")
            }
        }
        .onTapGesture {
            onEdit()
        }
    }
    
    private var tagIcon: String {
        switch note.tag {
        case .todo: return "checkmark.circle.fill"
        case .idea: return "lightbulb.fill"
        case .tools: return "wrench.fill"
        case .general: return "note"
        }
    }
    
    private var tagColor: Color {
        switch note.tag {
        case .todo: return .systemRed
        case .idea: return .systemGreen
        case .tools: return .systemBlue
        case .general: return .systemGray
        }
    }
}
