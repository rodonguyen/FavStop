import Foundation

// MARK: - Bus Stop Response Models
struct BusStopResponse: Codable, Identifiable {
    let id: String
    let name: String
    let zone: String
    let position: Position
    let routes: [Route]
    let departures: [Departure]
    let serviceAlerts: ServiceAlerts
}

struct Position: Codable {
    let lat: Double
    let lng: Double
}

struct Route: Codable, Identifiable {
    let regionName: String
    let id: String
    let name: String
    let headSign: String
    let direction: String
}

struct Departure: Codable, Identifiable {
    let id: String
    let routeId: String
    let headsign: String
    let direction: String
    let scheduledDepartureUtc: String
    let departureDescription: String
    let canBoardDebark: String
    let realtime: Realtime?
    
    // Computed properties for UI
    var isRealtime: Bool {
        return realtime != nil
    }
    
    var isLate: Bool {
        guard let realtime = realtime else { return false }
        let scheduled = ISO8601DateFormatter().date(from: scheduledDepartureUtc) ?? Date()
        let expected = ISO8601DateFormatter().date(from: realtime.expectedDepartureUtc) ?? Date()
        return expected > scheduled
    }
    
    var delayMinutes: Int {
        guard let realtime = realtime else { return 0 }
        let scheduled = ISO8601DateFormatter().date(from: scheduledDepartureUtc) ?? Date()
        let expected = ISO8601DateFormatter().date(from: realtime.expectedDepartureUtc) ?? Date()
        return Int(expected.timeIntervalSince(scheduled) / 60)
    }
    
    var statusText: String {
        if let realtime = realtime {
            if realtime.isCancelled {
                return "Cancelled"
            } else if isLate {
                return "Late (\(delayMinutes) min)"
            } else {
                return "On time"
            }
        } else {
            return "Scheduled"
        }
    }
    
    var statusColor: String {
        if let realtime = realtime {
            if realtime.isCancelled {
                return "error"
            } else if isLate {
                return "warning"
            } else {
                return "success"
            }
        } else {
            return "secondary"
        }
    }
}

struct Realtime: Codable {
    let expectedDepartureUtc: String
    let isExtra: Bool
    let isSkipped: Bool
    let isCancelled: Bool
}

struct ServiceAlerts: Codable {
    let at: String
    let current: [String]
    let upcoming: [String]
}

// MARK: - Bus Stop Data Loader
class BusStopDataLoader: ObservableObject {
    @Published var busStops: [BusStopResponse] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let api = TranslinkApi.shared
    private let defaultStopIds = ["000876", "000635"] // Real Brisbane stop IDs
    
    // MARK: - Public Methods
    
    /// Load bus stop data from the Translink API
    func loadData(stopIds: [String] = []) async {
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
        let idsToLoad = stopIds.isEmpty ? defaultStopIds : stopIds
        
        do {
            let stops = try await api.getMultipleStopTimetables(stopIds: idsToLoad)
            await MainActor.run {
                self.busStops = stops
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = "Failed to load departure data: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    /// Refresh data for existing stops
    func refreshData() async {
        let currentStopIds = busStops.map { $0.id }
        await loadData(stopIds: currentStopIds.isEmpty ? defaultStopIds : currentStopIds)
    }
    
    /// Add a new stop by ID
    func addStop(stopId: String) async {
        await MainActor.run {
            self.error = nil
        }
        
        do {
            let stop = try await api.getStopTimetable(stopId: stopId)
            await MainActor.run {
                self.busStops.append(stop)
            }
        } catch {
            await MainActor.run {
                self.error = "Failed to add stop \(stopId): \(error.localizedDescription)"
            }
        }
    }
    
    /// Remove a stop by ID
    func removeStop(stopId: String) {
        busStops.removeAll { $0.id == stopId }
    }
} 