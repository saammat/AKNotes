//
//  TimelineRowView.swift
//  AkNotes
//
//  Created by 徐 on 2025/7/29.
//

import SwiftUI

struct TimelineRowView: View {
    let note: Note
    let shouldShowDate: Bool
    let date: Date
    let isEarliestOfDay: Bool
    let isFirstNote: Bool
    let onDelete: (Note) -> Void
    let onEdit: (Note) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            if shouldShowDate {
                if !isFirstNote {
                    Spacer()
                        .frame(height: AppSpacing.md)
                }
            }
            
            HStack(alignment: .top, spacing: 0) {
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
                    Color.clear
                        .frame(width: 52)
                }
                
                TimelineNoteCard(
                    note: note,
                    onDelete: onDelete,
                    onEdit: { onEdit(note) }
                )
                .transition(.scale.combined(with: .opacity))
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
