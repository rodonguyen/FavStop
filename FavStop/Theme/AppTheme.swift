import SwiftUI

// MARK: - App Theme
struct AppTheme {
    
    // MARK: - Colors
    struct Colors {
        // Brand Colors - using fallbacks since assets don't exist
        static let primary = Color(red: 0.16, green: 0.65, blue: 0.37) // #28A55F (green)
        static let secondary = Color(.systemBlue)
        
        // Custom Background Colors - using system colors
        static let background = Color(.systemBackground)
        static let surface = Color(.secondarySystemBackground)
        static let textPrimary = Color(.label)
        static let textSecondary = Color(.secondaryLabel)
        
        // Status Colors
        static let success = Color.green
        static let error = Color.red
        static let warning = Color.orange
        
        // Fallback colors with custom dark background
        static let primaryFallback = Color(red: 0.16, green: 0.65, blue: 0.37) // #28A55F
        static let backgroundFallback = Color(.systemBackground)
        static let surfaceFallback = Color(.secondarySystemBackground)
        static let textPrimaryFallback = Color(.label)
        static let textSecondaryFallback = Color(.secondaryLabel)
        
        // Custom smoky black background
        static let smokyBlack = Color(red: 0.05, green: 0.05, blue: 0.05) // #0D0D0D
        static let smokyBlackSurface = Color(red: 0.08, green: 0.08, blue: 0.08) // #141414
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.system(size: 40, weight: .bold, design: .rounded)
        static let title1 = Font.system(size: 32, weight: .bold)
        static let title2 = Font.system(size: 24, weight: .semibold)
        static let title3 = Font.system(size: 20, weight: .semibold)
        static let headline = Font.system(size: 18, weight: .semibold)
        static let body = Font.system(size: 16, weight: .regular)
        static let bodyBold = Font.system(size: 16, weight: .semibold)
        static let caption = Font.system(size: 14, weight: .regular)
        static let caption2 = Font.system(size: 12, weight: .regular)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 40
        static let xxxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }
    
    // MARK: - Shadow
    struct Shadow {
        static let small = Color.black.opacity(0.1)
        static let medium = Color.black.opacity(0.15)
        static let large = Color.black.opacity(0.2)
    }
}

// MARK: - Environment-aware colors
extension AppTheme.Colors {
    static func adaptiveBackground(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return smokyBlack
        case .light:
            return .white
        @unknown default:
            return Color(.systemBackground)
        }
    }
    
    static func adaptiveSurface(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return smokyBlackSurface
        case .light:
            return Color(.secondarySystemBackground)
        @unknown default:
            return Color(.secondarySystemBackground)
        }
    }
}

// MARK: - View Extensions for Styling
extension View {
    
    // Button Styles
    func primaryButton() -> some View {
        self
            .font(AppTheme.Typography.headline)
            .foregroundColor(.white)
            .padding(.vertical, AppTheme.Spacing.md)
            .padding(.horizontal, AppTheme.Spacing.xl)
            .background(AppTheme.Colors.primary)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .shadow(color: AppTheme.Shadow.small, radius: 2, x: 0, y: 1)
    }
    
    func secondaryButton() -> some View {
        self
            .font(AppTheme.Typography.headline)
            .foregroundColor(AppTheme.Colors.primary)
            .padding(.vertical, AppTheme.Spacing.md)
            .padding(.horizontal, AppTheme.Spacing.xl)
            .background(AppTheme.Colors.surface)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .stroke(AppTheme.Colors.primary, lineWidth: 1)
            )
    }
    
    // Card Style
    func cardStyle() -> some View {
        self
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.CornerRadius.large)
            .shadow(color: AppTheme.Shadow.small, radius: 4, x: 0, y: 2)
    }
    
    // Section Spacing
    func sectionSpacing() -> some View {
        self.padding(.vertical, AppTheme.Spacing.lg)
    }
}

// MARK: - Theme-aware modifiers
extension Text {
    func themedTitle() -> some View {
        self
            .font(AppTheme.Typography.largeTitle)
            .foregroundColor(AppTheme.Colors.textPrimary)
    }
    
    func themedHeadline() -> some View {
        self
            .font(AppTheme.Typography.headline)
            .foregroundColor(AppTheme.Colors.textPrimary)
    }
    
    func themedBody() -> some View {
        self
            .font(AppTheme.Typography.body)
            .foregroundColor(AppTheme.Colors.textSecondary)
    }
} 