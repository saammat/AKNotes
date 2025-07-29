import SwiftUI

struct TimelineView: View {
    let notes: [Note]
    let onDelete: (Note) -> Void
    let onEdit: (Note) -> Void
    
    private var notesWithDateFlags: [(note: Note, shouldShowDate: Bool, date: Date, isEarliestOfDay: Bool, isFirstNote: Bool)] {
        let groupedByDate = Dictionary(grouping: notes) { note in
            Calendar.current.startOfDay(for: note.createdAt)
        }
        
        let sortedNotes = notes.sorted { $0.createdAt > $1.createdAt }
        
        return sortedNotes.enumerated().map { index, note in
            let dayStart = Calendar.current.startOfDay(for: note.createdAt)
            let dayNotes = groupedByDate[dayStart] ?? []
            let latestNote = dayNotes.max { $0.createdAt < $1.createdAt }
            let earliestNote = dayNotes.min { $0.createdAt < $1.createdAt }
            let firstNote = index == 0
            
            let isEarliestOfDay = note.id == earliestNote?.id
            
            return (
                note: note,
                shouldShowDate: note.id == latestNote?.id,
                date: dayStart,
                isEarliestOfDay: isEarliestOfDay,
                isFirstNote: firstNote
            )
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(notesWithDateFlags, id: \.note.id) { item in
                    TimelineRowView(
                        note: item.note,
                        shouldShowDate: item.shouldShowDate,
                        date: item.date,
                        isEarliestOfDay: item.isEarliestOfDay,
                        isFirstNote: item.isFirstNote,
                        onDelete: onDelete,
                        onEdit: onEdit
                    )
                }
            }
            .padding(.horizontal, 0)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, AppSpacing.xl)
        }
        .scrollIndicators(.hidden)
    }
}
