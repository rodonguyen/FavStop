import SwiftUI

struct LandingView: View {
    @Environment(\.colorScheme) var colorScheme
    let onGetStarted: () async -> Void
    
    var body: some View {
        ScrollView {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Hero Section
            VStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: "bus.fill")
                    .font(.system(size: 60))
                    .foregroundColor(AppTheme.Colors.primaryFallback)
                
                Text("One Place for all Your Stops")
                    .font(AppTheme.Typography.largeTitle)
                    .foregroundColor(Color.primary)
                    .multilineTextAlignment(.center)
                
                Text("Keep track of your favorite bus stops and see real-time departure information.")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(Color.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            
            // Get Started Button
            Button {
                Task {
                    await onGetStarted()
                }
            } label: {
                Text("Get Started")
                    .primaryButton()
            }
            
            // Comparison Table
            ComparisonTableView()
                .padding(.top, AppTheme.Spacing.sm)
        }
        .padding(.vertical, AppTheme.Spacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.Colors.adaptiveBackground(for: colorScheme))
        }
    }
}

struct ComparisonTableView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack {
                Text("Other Apps")
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.error)
                
                Spacer()
                
                Text("Fav Stop 🚌")
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.success)
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            
            VStack(spacing: AppTheme.Spacing.sm) {
                ComparisonRow(
                    negative: "Complicated interface",
                    positive: "All you need for your frequent routes"
                )
                
                ComparisonRow(
                    negative: "Laggggg",
                    positive: "Real-time departure info"
                )
                
                ComparisonRow(
                    negative: "Too-many steps",
                    positive: "Know if your bus is 3-minute early"
                )
                
                ComparisonRow(
                    negative: "90% features are untouched when you already know where you want to go",
                    positive: "One dashboard to rule them all!"
                )
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.adaptiveSurface(for: colorScheme))
        .cornerRadius(AppTheme.CornerRadius.medium)
        .padding(.horizontal, AppTheme.Spacing.md)
    }
}

struct ComparisonRow: View {
    let negative: String
    let positive: String
    
    var body: some View {
        HStack(alignment: .top) {
            HStack(alignment: .top, spacing: AppTheme.Spacing.xs) {
                Text("❌")
                Text(negative)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(Color.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(alignment: .top, spacing: AppTheme.Spacing.xs) {
                Text("✅")
                Text(positive)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(Color.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    LandingView(onGetStarted: { })
} 