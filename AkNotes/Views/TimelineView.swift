import SwiftUI

struct TimelineView: View {
    let notes: [Note]
    let onDelete: (Note) -> Void
    let onEdit: (Note) -> Void
    
    private var groupedNotes: [(String, [Note])] {
        let grouped = Dictionary(grouping: notes) { note in
            note.createdAt.formatted(date: .abbreviated, time: .omitted)
        }
        return grouped.sorted { $0.key > $1.key }.map { ($0.key, $0.value) }
    }
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .leading) {
                // Continuous vertical timeline line
                timelineBackgroundLine
                
                // Content with timeline dots
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    ForEach(groupedNotes, id: \.0) { dateString, dayNotes in
                        TimelineSection(
                            dateString: dateString,
                            notes: dayNotes,
                            onDelete: onDelete,
                            onEdit: onEdit
                        )
                    }
                }
                .padding(.horizontal, 0)
                .padding(.top, AppSpacing.md)
                .padding(.bottom, AppSpacing.xl)
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var timelineBackgroundLine: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color(.separator))
                .frame(width: 1)
                .frame(height: max(geometry.size.height, 100))
                .position(x: 20, y: geometry.size.height / 2)
        }
        .frame(width: 40)
    }
}

struct TimelineSection: View {
    let dateString: String
    let notes: [Note]
    let onDelete: (Note) -> Void
    let onEdit: (Note) -> Void
    
    var body: some View {
        Section {
            ForEach(Array(notes.enumerated()), id: \.element.id) { index, note in
                TimelineRow(
                    note: note,
                    onDelete: onDelete,
                    onEdit: onEdit
                )
            }
        } header: {
            TimelineHeader(dateString: dateString)
        }
        .padding(.bottom, AppSpacing.lg)
    }
}

struct TimelineHeader: View {
    let dateString: String
    
    var body: some View {
        HStack {
            Text(formattedDate(dateString))
                .font(AppTypography.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(dayOfWeek)
                .font(AppTypography.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color(.secondarySystemBackground))
    }
    
    private var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            let weekdayFormatter = DateFormatter()
            weekdayFormatter.dateFormat = "EEE"
            weekdayFormatter.locale = Locale(identifier: "zh_CN")
            return weekdayFormatter.string(from: date)
        }
        return ""
    }
    
    private func formattedDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MM月dd日"
            return displayFormatter.string(from: date)
        }
        return dateString
    }
}

struct TimelineRow: View {
    let note: Note
    let onDelete: (Note) -> Void
    let onEdit: (Note) -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // Timeline dot (aligned with continuous background line)
            timelineIndicator
                .padding(.leading, 14) // Align with background line position
            
            // Note card
            noteCard
                .padding(.leading, AppSpacing.md)
                .padding(.trailing, AppSpacing.md)
        }
        .padding(.vertical, AppSpacing.xs)
    }
    
    private var timelineIndicator: some View {
        // iOS-style dot
        Circle()
            .fill(tagColor)
            .frame(width: 10, height: 10)
            .overlay(
                Circle()
                    .stroke(Color(.systemBackground), lineWidth: 2)
            )
            .padding(.top, 8)
    }
    
    private var tagColor: Color {
        switch note.tag {
        case .todo: return .systemRed
        case .idea: return .systemGreen
        case .tools: return .systemBlue
        case .general: return .systemGray
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
                            colors: [Color(hex: "667eea").opacity(0.2), Color(hex: "764ba2").opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "timeline.selection")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(Color(hex: "667eea"))
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
