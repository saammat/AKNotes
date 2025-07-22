import SwiftUI

// MARK: - iOS Native Design System
struct iOSDesignSystem {
    // MARK: - Colors
    struct Colors {
        // Light Mode Colors
        static let lightPrimary100 = Color(red: 0.545, green: 0.373, blue: 0.749) // #8B5FBF
        static let lightPrimary200 = Color(red: 0.380, green: 0.224, blue: 0.561) // #61398F
        static let lightPrimary300 = Color.white // #FFFFFF
        
        static let lightAccent100 = Color(red: 0.839, green: 0.776, blue: 0.882) // #D6C6E1
        static let lightAccent200 = Color(red: 0.604, green: 0.451, blue: 0.710) // #9A73B5
        
        static let lightText100 = Color(red: 0.290, green: 0.290, blue: 0.290) // #4A4A4A
        static let lightText200 = Color(red: 0.529, green: 0.529, blue: 0.529) // #878787
        
        static let lightBg100 = Color(red: 0.961, green: 0.953, blue: 0.969) // #F5F3F7
        static let lightBg200 = Color(red: 0.914, green: 0.894, blue: 0.929) // #E9E4ED
        static let lightBg300 = Color.white // #FFFFFF
        
        // Dark Mode Colors
        static let darkPrimary100 = Color(red: 0.671, green: 0.537, blue: 0.831) // #AB89D4
        static let darkPrimary200 = Color(red: 0.545, green: 0.373, blue: 0.749) // #8B5FBF
        static let darkPrimary300 = Color(red: 0.118, green: 0.110, blue: 0.129) // #1E1C21
        
        static let darkAccent100 = Color(red: 0.545, green: 0.373, blue: 0.749) // #8B5FBF
        static let darkAccent200 = Color(red: 0.671, green: 0.537, blue: 0.831) // #AB89D4
        
        static let darkText100 = Color(red: 0.933, green: 0.933, blue: 0.933) // #EEEEEE
        static let darkText200 = Color(red: 0.733, green: 0.733, blue: 0.733) // #BBBBBB
        
        static let darkBg100 = Color(red: 0.118, green: 0.110, blue: 0.129) // #1E1C21
        static let darkBg200 = Color(red: 0.161, green: 0.149, blue: 0.188) // #292630
        static let darkBg300 = Color(red: 0.220, green: 0.204, blue: 0.251) // #383440
        
        // Adaptive Colors
        static let primary100: Color = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(darkPrimary100) : UIColor(lightPrimary100)
        })
        
        static let primary200: Color = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(darkPrimary200) : UIColor(lightPrimary200)
        })
        
        static let primary300: Color = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(darkPrimary300) : UIColor(lightPrimary300)
        })
        
        static let accent100: Color = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(darkAccent100) : UIColor(lightAccent100)
        })
        
        static let accent200: Color = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(darkAccent200) : UIColor(lightAccent200)
        })
        
        static let text100: Color = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(darkText100) : UIColor(lightText100)
        })
        
        static let text200: Color = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(darkText200) : UIColor(lightText200)
        })
        
        static let bg100: Color = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(darkBg100) : UIColor(lightBg100)
        })
        
        static let bg200: Color = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(darkBg200) : UIColor(lightBg200)
        })
        
        static let bg300: Color = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(darkBg300) : UIColor(lightBg300)
        })
        
        // Light Mode Gradients
        static let primaryGradient = LinearGradient(
            colors: [primary100, primary200],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let accentGradient = LinearGradient(
            colors: [accent100, accent200],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let backgroundGradient = LinearGradient(
            colors: [bg100, bg200],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Dark Mode Gradients
        static let darkPrimaryGradient = LinearGradient(
            colors: [primary100, primary200],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Tag Colors - Adaptive
        static let todo = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(red: 0.671, green: 0.537, blue: 0.831, alpha: 1.0) : UIColor(red: 0.545, green: 0.373, blue: 0.749, alpha: 1.0)
        })
        
        static let idea = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(red: 0.545, green: 0.373, blue: 0.749, alpha: 1.0) : UIColor(red: 0.380, green: 0.224, blue: 0.561, alpha: 1.0)
        })
        
        static let tools = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(red: 0.545, green: 0.373, blue: 0.749, alpha: 1.0) : UIColor(red: 0.839, green: 0.776, blue: 0.882, alpha: 1.0)
        })
        
        static let general = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(red: 0.671, green: 0.537, blue: 0.831, alpha: 1.0) : UIColor(red: 0.604, green: 0.451, blue: 0.710, alpha: 1.0)
        })
        
        // System Colors (fallback)
        static let background = Color(.systemBackground)
        static let secondaryBackground = Color(.secondarySystemBackground)
        static let tertiaryBackground = Color(.tertiarySystemBackground)
        
        static let primaryText = text100
        static let secondaryText = text200
        
        static let separator = Color(.separator)
        
        // Brand Colors (for backward compatibility)
        static let brandBlue = primary100
        static let brandBlueLight = accent100
        
        // Tag Gradients
        static let todoGradient = LinearGradient(
            colors: [todo, Color(red: 0.380, green: 0.224, blue: 0.561)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let ideaGradient = LinearGradient(
            colors: [idea, Color(red: 0.839, green: 0.776, blue: 0.882)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let toolsGradient = LinearGradient(
            colors: [tools, Color(red: 0.604, green: 0.451, blue: 0.710)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let generalGradient = LinearGradient(
            colors: [general, Color(red: 0.545, green: 0.373, blue: 0.749)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let allGradient = LinearGradient(
            colors: [primary100, accent200],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
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
