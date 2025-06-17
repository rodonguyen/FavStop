import SwiftUI

struct DashboardView: View {
    @StateObject private var dataLoader = BusStopDataLoader()
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    if dataLoader.isLoading {
                        LoadingView()
                    } else if let error = dataLoader.error {
                        ErrorView(message: error) {
                            Task {
                                await dataLoader.refreshData()
                            }
                        }
                    } else if dataLoader.busStops.isEmpty {
                        EmptyStateView()
                    } else {
                        ForEach(dataLoader.busStops) { stop in
                            BusStopCard(
                                busStop: stop,
                                onRemove: {}
                            )
                            .transition(.opacity.combined(with: .move(edge: .leading)))
                        }
                    }
                }
                .padding()
            }
            .refreshable {
                await dataLoader.refreshData()
            }
            .navigationTitle("Your Favorite Stops")
            .navigationBarItems(
                trailing: Button(action: {
                    // Add stop action
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.green)
                }
            )
        }
        .task {
            await dataLoader.loadData()
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .padding()
            Text("Loading stops...")
                .font(AppTheme.Typography.body)
                .foregroundColor(.secondary)
        }
    }
}

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.red)
            
            Text("Error loading stops")
                .font(AppTheme.Typography.headline)
            
            Text(message)
                .font(AppTheme.Typography.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Retry", action: onRetry)
                .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "bus.fill")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            
            Text("No stops added yet")
                .font(AppTheme.Typography.headline)
            
            Text("Add your favorite bus stops to track their departures")
                .font(AppTheme.Typography.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    DashboardView()
}
