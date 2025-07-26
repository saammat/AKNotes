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
                    TimelineRow(
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

struct TimelineRow: View {
    let note: Note
    let shouldShowDate: Bool
    let date: Date
    let isEarliestOfDay: Bool
    let isFirstNote: Bool
    let onDelete: (Note) -> Void
    let onEdit: (Note) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Add extra spacing before the earliest note of each day
            if shouldShowDate {
                if !isFirstNote {
                    Spacer()
                        .frame(height: AppSpacing.md) // Significant day separation
                }
            }
            
            HStack(alignment: .top, spacing: 0) {
                // Date display aligned with top of note card
                if shouldShowDate {
                    VStack(spacing: 2) {
                        let components = Calendar.current.dateComponents([.month, .day, .year], from: date)
                        let monthSymbols = Calendar.current.shortMonthSymbols
                        let month = monthSymbols[components.month! - 1]
                        let day = String(components.day!)
                        let year = String(components.year!)
                        
                        Text(month)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                        Text(day)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        Text(year)
                            .font(.system(size: 11, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(
                        Calendar.current.isDateInToday(date) ?
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1) :
                        RoundedRectangle(cornerRadius: 8)
                            .fill(iOSDesignSystem.Colors.bg200)
                            .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.separator).opacity(0.2), lineWidth: 0.5)
                    )
                    .padding(.leading, 8)
                } else {
                    // Empty spacer for alignment
                    Color.clear
                        .frame(width: 52) // Same width as date display
                }
                
                // Note card
                noteCard
                    .padding(.leading, AppSpacing.sm)
                    .padding(.trailing, AppSpacing.md)
            }
            .padding(.vertical, AppSpacing.xs)
        }
    }
    
    private var tagColor: Color {
        switch note.tag {
        case .todo: return iOSDesignSystem.Colors.todo
        case .idea: return iOSDesignSystem.Colors.idea
        case .tools: return iOSDesignSystem.Colors.tools
        case .general: return iOSDesignSystem.Colors.general
        }
    }
    
    private var noteCard: some View {
        TimelineNoteCard(
            note: note,
            onDelete: onDelete,
            onEdit: { onEdit(note) }
        )
        .transition(.scale.combined(with: .opacity))
    }
    
    private var noteGradient: LinearGradient {
        switch note.tag {
        case .todo: return AppColors.todoGradient
        case .idea: return AppColors.ideaGradient
        case .tools: return AppColors.toolsGradient
        case .general: return AppColors.generalGradient
        }
    }
    
    private var cardShadowColor: Color {
        switch note.tag {
        case .todo: return Color(hex: "FF6B6B").opacity(0.3)
        case .idea: return Color(hex: "4ECDC4").opacity(0.3)
        case .tools: return Color(hex: "667eea").opacity(0.3)
        case .general: return Color(hex: "8E8E93").opacity(0.3)
        }
    }
}

struct EmptyTimelineView: View {
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [iOSDesignSystem.Colors.primary100.opacity(0.2), iOSDesignSystem.Colors.primary200.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "timeline.selection")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(iOSDesignSystem.Colors.primary100)
            }
            
            VStack(spacing: AppSpacing.sm) {
                Text("开始你的时间线")
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("每次记录都会在这里形成时间线")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, AppSpacing.xl)
            
            Spacer()
            Spacer()
        }
    }
}
