import SwiftUI

// MARK: - iOS Native Design System
struct iOSDesignSystem {
    // MARK: - Colors
    struct Colors {
        // Subtle gradient background colors - light gray to light blue
        static let backgroundGradient = LinearGradient(
            colors: [
                Color(.systemGray6).opacity(0.8),
                Color(.systemBlue).opacity(0.15)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let appBackground = Color(.systemGray6)
        static let secondaryBackground = Color(.secondarySystemBackground)
        static let tertiaryBackground = Color(.tertiarySystemBackground)
        
        static let primaryText = Color(.label)
        static let secondaryText = Color(.secondaryLabel)
        static let tertiaryText = Color(.tertiaryLabel)
        
        // Brand blue accent for interactive elements
        static let brandBlue = Color(red: 0.2, green: 0.4, blue: 0.9)
        static let brandBlueLight = Color(red: 0.3, green: 0.5, blue: 1.0)
        static let brandBlueSuperLight = Color(red: 0.89, green: 0.93, blue: 0.99)
        
        // Tag colors using system colors
        static let todo = Color.systemRed
        static let idea = Color.systemGreen
        static let tools = Color.systemBlue
        static let general = Color.systemGray
        
        static let separator = Color(.separator)
        static let accent = Color.accentColor
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.largeTitle
        static let title1 = Font.title
        static let title2 = Font.title2
        static let title3 = Font.title3
        static let headline = Font.headline
        static let body = Font.body
        static let callout = Font.callout
        static let subheadline = Font.subheadline
        static let footnote = Font.footnote
        static let caption1 = Font.caption
        static let caption2 = Font.caption2
    }
    
    // MARK: - Spacing (iOS 16pt grid)
    struct Spacing {
        static let xxs: CGFloat = 2
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
    }
    
    // MARK: - Corner Radius (iOS standard)
    struct CornerRadius {
        static let button: CGFloat = 8
        static let card: CGFloat = 10
        static let large: CGFloat = 12
        static let pill: CGFloat = 20
    }
    
    // MARK: - Shadows (iOS subtle)
    struct Shadows {
        static let card = ShadowStyle(
            color: Color.black.opacity(0.05),
            radius: 2,
            x: 0,
            y: 1
        )
        
        static let elevated = ShadowStyle(
            color: Color.black.opacity(0.08),
            radius: 4,
            x: 0,
            y: 2
        )
    }
}

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Color Extensions for iOS
extension Color {
    static let systemRed = Color(.systemRed)
    static let systemGreen = Color(.systemGreen)
    static let systemBlue = Color(.systemBlue)
    static let systemOrange = Color(.systemOrange)
    static let systemYellow = Color(.systemYellow)
    static let systemPink = Color(.systemPink)
    static let systemPurple = Color(.systemPurple)
    static let systemGray = Color(.systemGray)
    static let systemGray2 = Color(.systemGray2)
    static let systemGray3 = Color(.systemGray3)
    static let systemGray4 = Color(.systemGray4)
    static let systemGray5 = Color(.systemGray5)
    static let systemGray6 = Color(.systemGray6)
}

// MARK: - View Extensions
extension View {
    /// Applies iOS-style card styling
    func iOSCardStyle() -> some View {
        self
            .background(Color(.systemBackground))
            .cornerRadius(iOSDesignSystem.CornerRadius.card)
            .shadow(
                color: Color.black.opacity(0.05),
                radius: 2,
                x: 0,
                y: 1
            )
    }
    
    /// Applies iOS-style button styling
    func iOSButtonStyle() -> some View {
        self
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(iOSDesignSystem.CornerRadius.button)
    }
    
    /// Standard iOS padding
    func standardPadding() -> some View {
        self.padding(iOSDesignSystem.Spacing.lg)
    }
}
