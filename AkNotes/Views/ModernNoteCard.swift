import SwiftUI

struct ModernNoteCard: View {
    let note: Note
    let onDelete: () -> Void
    let onTap: () -> Void
    
    @State private var isPressed = false
    @State private var showDeleteConfirmation = false
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    
    var body: some View {
        ZStack {
            // Background with gradient based on tag
            cardBackground
            
            // Content
            cardContent
                .offset(x: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if value.translation.width < 0 {
                                    dragOffset = value.translation.width
                                    isDragging = true
                                }
                            }
                        }
                        .onEnded { value in
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if value.translation.width < -80 {
                                    showDeleteConfirmation = true
                                }
                                dragOffset = 0
                                isDragging = false
                            }
                        }
                )
            
            // Delete action overlay
            if dragOffset < -40 {
                deleteActionOverlay
                    .transition(.opacity)
            }
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
        .confirmationDialog("删除笔记", isPresented: $showDeleteConfirmation) {
            Button("删除", role: .destructive) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    onDelete()
                }
            }
            Button("取消", role: .cancel) { }
        }
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: AppCornerRadius.xl)
            .fill(cardGradient)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.xl)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(
                color: cardShadowColor,
                radius: isDragging ? 12 : 8,
                x: 0,
                y: isDragging ? 8 : 4
            )
    }
    
    private var cardContent: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                // Tag indicator
                tagIndicator
                
                Spacer()
                
                // Time
                Text(note.createdAt, style: .time)
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // Content
            Text(note.content)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.white)
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
        }
        .padding(AppSpacing.md)
    }
    
    private var tagIndicator: some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: tagIcon)
                .font(.system(size: 14, weight: .semibold))
            
            Text(note.tag.displayName)
                .font(.system(.caption, design: .rounded, weight: .bold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xs)
        .background(Color.white.opacity(0.2))
        .clipShape(Capsule())
    }
    
    private var deleteActionOverlay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppCornerRadius.xl)
                .fill(Color.red.opacity(0.9))
            
            Image(systemName: "trash.fill")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
        }
    }
    
    private var tagIcon: String {
        switch note.tag {
        case .todo: return "checkmark.circle.fill"
        case .idea: return "lightbulb.fill"
        case .tools: return "wrench.fill"
        case .general: return "note.text"
        }
    }
    
    private var cardGradient: LinearGradient {
        switch note.tag {
        case .todo:
            return LinearGradient(
                colors: [Color(hex: "FF6B6B"), Color(hex: "FF8787")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .idea:
            return LinearGradient(
                colors: [Color(hex: "4ECDC4"), Color(hex: "44A08D")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .tools:
            return LinearGradient(
                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .general:
            return LinearGradient(
                colors: [Color(hex: "8E8E93"), Color(hex: "AEAEB2")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
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

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
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
                
                Image(systemName: "note.text")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(Color(hex: "667eea"))
            }
            
            VStack(spacing: AppSpacing.sm) {
                Text("开始记录你的第一个想法")
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("选择标签，输入内容，轻点发送")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, AppSpacing.xl)
        .padding(.top, 60)
    }
}

// MARK: - Animations
extension Animation {
    static let smoothSpring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let gentleSpring = Animation.spring(response: 0.4, dampingFraction: 0.8)
}