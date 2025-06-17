import SwiftUI

struct DepartureTable: View {
    let departures: [Departure]
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            if departures.isEmpty {
                Text("No upcoming buses at this stop")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(Color.secondary)
                    .padding(.vertical, AppTheme.Spacing.sm)
            } else {
                // Table Header
                HStack {
                    Text("Route")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Departing In")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Status")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.bottom, 4)
                
                // Table Rows
                ForEach(departures) { departure in
                    DepartureRow(departure: departure)
                    if departure.id != departures.last?.id {
                        Divider()
                    }
                }
            }
        }
    }
}

struct DepartureRow: View {
    let departure: Departure
    
    var body: some View {
        HStack {
            // Route number
            Text(departure.headsign)
                .font(AppTheme.Typography.bodyBold)
                .foregroundColor(Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Departure time
            HStack(spacing: 4) {
                Text(departure.departureDescription)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(Color.primary)
                
                if departure.isRealtime, let realtime = departure.realtime {
                    Text("(\(formatTime(realtime.expectedDepartureUtc)))")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(Color.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Status
            Text(getStatusText(departure: departure))
                .font(AppTheme.Typography.caption)
                .foregroundColor(getStatusColor(departure: departure))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.vertical, 2)
    }
    
    private func getStatusText(departure: Departure) -> String {
        if let realtime = departure.realtime {
            if realtime.isCancelled {
                return "Cancelled"
            } else if realtime.isSkipped {
                return "Skipped"
            }
            
            // Check if it's running late or early by comparing expected vs scheduled
            if let expectedDate = parseDate(realtime.expectedDepartureUtc),
              let scheduledDate = parseDate(departure.scheduledDepartureUtc) {
                let delay = expectedDate.timeIntervalSince(scheduledDate)
                let minutes = Int(round(delay / 60))
                
                if minutes > 0 {
                    return "Late (\(minutes) min)"
                } else if minutes < 0 {
                    return "Early (\(abs(minutes)) min)"
                } else {
                    return "On time"
                }
            }
            
            return "On time"
        }
        
        return "On time"
    }
    
    private func getStatusColor(departure: Departure) -> Color {
        if let realtime = departure.realtime {
            if realtime.isCancelled || realtime.isSkipped {
                return AppTheme.Colors.error
            }
            
            // Check if it's running late or early
            if let expectedDate = parseDate(realtime.expectedDepartureUtc),
               let scheduledDate = parseDate(departure.scheduledDepartureUtc) {
                let delay = expectedDate.timeIntervalSince(scheduledDate)
                let minutes = Int(round(delay / 60))
                
                if minutes > 0 {
                    return AppTheme.Colors.error // Late
                } else if minutes < 0 {
                    return AppTheme.Colors.success // Early
                } else {
                    return AppTheme.Colors.success // On time
                }
            }
        }
        
        return AppTheme.Colors.success
    }
    
    // Helper function to parse dates consistently
    private func parseDate(_ utcString: String) -> Date? {
        // Handle the decimal format in the API response
        let cleanedString = utcString.replacingOccurrences(of: ".\\d+Z$", with: "Z", options: .regularExpression)
        
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: cleanedString) {
            return date
        }
        
        // If ISO8601 fails, try a more flexible approach
        let fallbackFormatter = DateFormatter()
        fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS'Z'"
        fallbackFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let fallbackDate = fallbackFormatter.date(from: utcString) {
            return fallbackDate
        }
        
        // Try without decimal seconds
        let simpleFormatter = DateFormatter()
        simpleFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        simpleFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return simpleFormatter.date(from: utcString)
    }
    
    private func formatTime(_ utcString: String) -> String {
        // Handle the decimal format in the API response
        let cleanedString = utcString.replacingOccurrences(of: ".\\d+Z$", with: "Z", options: .regularExpression)
        
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: cleanedString) else {
            // If ISO8601 fails, try a more flexible approach
            let fallbackFormatter = DateFormatter()
            fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS'Z'"
            fallbackFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            guard let fallbackDate = fallbackFormatter.date(from: utcString) else {
                return ""
            }
            
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "h:mm a"
            displayFormatter.timeZone = TimeZone.current
            return displayFormatter.string(from: fallbackDate)
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "h:mm a"
        displayFormatter.timeZone = TimeZone.current
        return displayFormatter.string(from: date)
    }
}

#Preview {
    DepartureTable(departures: [
        Departure(
            id: "1",
            routeId: "390",
            headsign: "390",
            direction: "Outbound",
            scheduledDepartureUtc: "2025-06-16T01:58:00Z",
            departureDescription: "4 min",
            canBoardDebark: "Both",
            realtime: Realtime(
                expectedDepartureUtc: "2025-06-16T01:55:06.613Z",
                isExtra: false,
                isSkipped: false,
                isCancelled: false
            )
        )
    ])
    .padding()
} 

