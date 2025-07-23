//
//  CompactTagChip.swift
//  AkNotes
//
//  Created by 徐 on 2025/7/19.
//
import SwiftUI

struct CompactTagChip: View {
    let tag: NoteTag
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: tagIcon(for: tag))
                    .font(.system(size: 11, weight: .semibold))
                
                Text(tag.displayName)
                    .font(.system(.caption, design: .rounded, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? AnyShapeStyle(iOSDesignSystem.Colors.accent200) : AnyShapeStyle(Color(.tertiarySystemFill)))
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
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
