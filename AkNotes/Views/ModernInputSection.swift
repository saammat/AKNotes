import SwiftUI

struct ModernInputSection: View {
    @ObservedObject var viewModel: NotesViewModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var animateSendButton = false
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            // Floating tag selector
            modernTagSelector
            
            // Glassmorphic input container
            ZStack(alignment: .bottomTrailing) {
                inputContainer
                
                if !viewModel.newContent.isEmpty {
                    FloatingSendButton(
                        animate: $animateSendButton,
                        action: {
                            viewModel.addNote()
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                animateSendButton = true
                            }
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .padding(.horizontal, 0)
        .padding(.vertical, AppSpacing.sm)
    }
    
    private var modernTagSelector: some View {
        HStack(spacing: 6) {
            ForEach(NoteTag.allCases, id: \.self) { tag in
                CompactTagPill(
                    tag: tag,
                    isSelected: viewModel.selectedTag == tag,
                    action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.selectedTag = tag
                        }
                    }
                )
            }
        }
    }
    
    private var inputContainer: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.md)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                )
                .shadow(
                    color: Color.black.opacity(isTextFieldFocused ? 0.15 : 0.05),
                    radius: isTextFieldFocused ? 6 : 2,
                    x: 0,
                    y: isTextFieldFocused ? 2 : 1
                )
            
            modernTextField
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
        }
        .frame(maxHeight: 44)
    }
    
    private var modernTextField: some View {
        TextField("", text: $viewModel.newContent, axis: .vertical)
            .font(.system(.body, design: .rounded))
            .lineLimit(1...3)
            .focused($isTextFieldFocused)
            .overlay(
                Group {
                    if viewModel.newContent.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "pencil.and.scribble")
                                .foregroundColor(.gray.opacity(0.7))
                            Text("输入想法...")
                                .foregroundColor(.gray.opacity(0.7))
                        }
                        .font(.system(.body, design: .rounded))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                    }
                },
                alignment: .leading
            )
    }
}

struct TagPill: View {
    let tag: NoteTag
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: tagIcon)
                    .font(.system(size: 12, weight: .semibold))
                
                Text(tag.displayName)
                    .font(.system(.caption2, design: .rounded, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(isSelected ? AnyShapeStyle(tagGradient) : AnyShapeStyle(Color.gray.opacity(0.2)))
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
    }
    
    private var tagIcon: String {
        switch tag {
        case .todo: return "checkmark.circle"
        case .idea: return "lightbulb"
        case .tools: return "wrench"
        case .general: return "note"
        }
    }
    
    private var tagGradient: LinearGradient {
        switch tag {
        case .todo: return AppColors.todoGradient
        case .idea: return AppColors.ideaGradient
        case .tools: return AppColors.toolsGradient
        case .general: return AppColors.generalGradient
        }
    }
}

struct CompactTagPill: View {
    let tag: NoteTag
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag.displayName.first?.uppercased() ?? "")
                .font(.system(.caption2, design: .rounded, weight: .bold))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(isSelected ? AnyShapeStyle(tagGradient) : AnyShapeStyle(Color.gray.opacity(0.2)))
                )
        }
    }
    
    private var tagGradient: LinearGradient {
        switch tag {
        case .todo: return AppColors.todoGradient
        case .idea: return AppColors.ideaGradient
        case .tools: return AppColors.toolsGradient
        case .general: return AppColors.generalGradient
        }
    }
}

struct FloatingSendButton: View {
    @Binding var animate: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "007AFF"), Color(hex: "5856D6")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "arrow.up")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                )
                .shadow(color: Color(hex: "007AFF").opacity(0.3), radius: 8, x: 0, y: 3)
                .scaleEffect(animate ? 1.2 : 1.0)
                .rotationEffect(.degrees(animate ? 360 : 0))
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(AppSpacing.sm)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}