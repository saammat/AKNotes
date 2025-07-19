import SwiftUI

struct TagSelectionView: View {
    @Binding var selectedTag: NoteTag
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(NoteTag.allCases, id: \.self) { tag in
                    TagButton(
                        tag: tag,
                        isSelected: selectedTag == tag,
                        action: { selectedTag = tag }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

struct TagButton: View {
    let tag: NoteTag
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag.displayName)
                .font(.subheadline.bold())
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color(tag.colorName) : Color.gray.opacity(0.2))
                )
        }
    }
}