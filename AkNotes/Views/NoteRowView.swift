import SwiftUI

struct NoteRowView: View {
    let note: Note
    let onDelete: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Tag indicator
            Circle()
                .fill(note.tag.color)
                .frame(width: 12, height: 12)
                .padding(.top, 4)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(note.formattedContent)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                
                Text(note.createdAt, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Delete button
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(.system(size: 16))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
    }
}