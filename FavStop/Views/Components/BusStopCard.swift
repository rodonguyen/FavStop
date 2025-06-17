import SwiftUI

struct BusStopCard: View {
    @Environment(\.colorScheme) var colorScheme
    let busStop: BusStopResponse
    let onRemove: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            // Stop Header
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(busStop.name)
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(Color.primary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Button(action: onRemove) {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.red)
                }
                .padding(AppTheme.Spacing.sm)
                .background(AppTheme.Colors.adaptiveSurface(for: colorScheme))
                .cornerRadius(AppTheme.CornerRadius.small)
            }
            
            // Departure Table (limited to 5 rows)
            DepartureTable(departures: Array(busStop.departures.prefix(5)))
            
            // Service alerts
            if !busStop.serviceAlerts.current.isEmpty {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Service Alerts")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(.orange)
                    
                    ForEach(busStop.serviceAlerts.current, id: \.self) { alert in
                        Text(alert)
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(.orange)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(.top, AppTheme.Spacing.xs)
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.adaptiveSurface(for: colorScheme))
        .cornerRadius(AppTheme.CornerRadius.large)
    }
}

#Preview {
    BusStopCard(
        busStop: BusStopResponse(
            id: "SI:000876",
            name: "Kelvin Grove Rd near Prospect Tce, stop 13, Kelvin Grove",
            zone: "1",
            position: Position(lat: -27.451532, lng: 153.010804),
            routes: [],
            departures: [
                Departure(
                    id: "mock1",
                    routeId: "T:Bus:390",
                    headsign: "390",
                    direction: "Outbound",
                    scheduledDepartureUtc: "2025-06-16T01:58:00Z",
                    departureDescription: "4 min",
                    canBoardDebark: "Both",
                    realtime: Realtime(
                        expectedDepartureUtc: "2025-06-16T01:59:06.613Z",
                        isExtra: false,
                        isSkipped: false,
                        isCancelled: false
                    )
                )
            ],
            serviceAlerts: ServiceAlerts(at: "2025-06-16T00:00:00", current: [], upcoming: [])
        ),
        onRemove: {}
    )
    .padding()
} 