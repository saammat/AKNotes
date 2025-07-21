import SwiftUI

// MARK: - Shadow Structure
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Color System
struct AppColors {
    // Primary Colors
    static let primary = Color(hex: "007AFF") // iOS Blue
    static let secondary = Color(hex: "34C759") // iOS Green
    static let tertiary = Color(hex: "FF9500") // iOS Orange
    static let quaternary = Color(hex: "AF52DE") // iOS Purple
    
    // Tag Colors
    static let todoGradient = LinearGradient(
        colors: [Color(hex: "FF6B6B"), Color(hex: "FF8787")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let ideaGradient = LinearGradient(
        colors: [Color(hex: "4ECDC4"), Color(hex: "44A08D")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let toolsGradient = LinearGradient(
        colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let generalGradient = LinearGradient(
        colors: [Color(hex: "a8a8a8"), Color(hex: "c9c9c9")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let allGradient = LinearGradient(
        colors: [Color(hex: "D9E4FF"), Color(hex: "2d5be1")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Background Colors
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)

    // Subtle gradient for app backgrounds
    static let appBackgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "F0F4FF"), Color(hex: "D9E4FF")]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Glassmorphic Colors
    static let glassBackground = Color.white.opacity(0.1)
    static let glassBorder = Color.white.opacity(0.2)
    
    // Text Colors
    static let primaryText = Color(.label)
    static let secondaryText = Color(.secondaryLabel)
    static let tertiaryText = Color(.tertiaryLabel)
}

// MARK: - Typography
struct AppTypography {
    static let largeTitle = Font.system(.largeTitle, design: .rounded, weight: .bold)
    static let title = Font.system(.title, design: .rounded, weight: .semibold)
    static let title3 = Font.system(.title3, design: .rounded, weight: .semibold)
    static let headline = Font.system(.headline, design: .rounded, weight: .semibold)
    static let subheadline = Font.system(.subheadline, design: .rounded)
    static let body = Font.system(.body, design: .rounded)
    static let callout = Font.system(.callout, design: .rounded)
    static let caption = Font.system(.caption, design: .rounded, weight: .medium)
    static let footnote = Font.system(.footnote, design: .rounded)
}

// MARK: - Spacing
struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Corner Radius
struct AppCornerRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let circular: CGFloat = 50
}

// MARK: - Shadows
struct AppShadows {
    static let small = Shadow(
        color: Color.black.opacity(0.1),
        radius: 4,
        x: 0,
        y: 2
    )
    
    static let medium = Shadow(
        color: Color.black.opacity(0.15),
        radius: 8,
        x: 0,
        y: 4
    )
    
    static let large = Shadow(
        color: Color.black.opacity(0.2),
        radius: 16,
        x: 0,
        y: 8
    )
}

// MARK: - Extensions
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension View {
    func glassmorphicBackground(cornerRadius: CGFloat = AppCornerRadius.md) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(AppColors.glassBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(AppColors.glassBorder, lineWidth: 1)
                    )
            )
            .background(.ultraThinMaterial)
    }
    
    func modernShadow() -> some View {
        self.shadow(
            color: Color.black.opacity(0.1),
            radius: 10,
            x: 0,
            y: 5
        )
    }
}
