import Foundation

class TranslinkApi {
    static let shared = TranslinkApi()
    private let baseUrl = "https://jp.translink.com.au/api"
    
    private init() {}
    
    // MARK: - Generic GET Request
    private func get<T: Codable>(endpoint: String, responseType: T.Type) async throws -> T {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw TranslinkApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw TranslinkApiError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw TranslinkApiError.httpError(statusCode: httpResponse.statusCode, message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
            }
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(responseType, from: data)
            return decodedData
            
        } catch let error as TranslinkApiError {
            throw error
        } catch {
            throw TranslinkApiError.networkError(error.localizedDescription)
        }
    }
    
    // MARK: - Public API Methods
    
    /// Fetches the timetable for a specific bus stop
    /// - Parameter stopId: The ID of the bus stop
    /// - Returns: BusStopResponse containing the timetable data
    /// - Throws: TranslinkApiError if the request fails
    func getStopTimetable(stopId: String) async throws -> BusStopResponse {
        do {
            return try await get(endpoint: "/stop/timetable/\(stopId)", responseType: BusStopResponse.self)
        } catch {
            print("Failed to fetch timetable for stop \(stopId): \(error)")
            throw error
        }
    }
    
    /// Fetches timetables for multiple bus stops
    /// - Parameter stopIds: Array of bus stop IDs
    /// - Returns: Array of BusStopResponse containing timetable data for all stops
    func getMultipleStopTimetables(stopIds: [String]) async throws -> [BusStopResponse] {
        var results: [BusStopResponse] = []
        
        // Execute requests concurrently
        try await withThrowingTaskGroup(of: (String, BusStopResponse).self) { group in
            for stopId in stopIds {
                group.addTask {
                    let timetable = try await self.getStopTimetable(stopId: stopId)
                    return (stopId, timetable)
                }
            }
            
            // Collect results as they complete
            for try await (stopId, timetable) in group {
                results.append(timetable)
            }
        }
        
        return results
    }
}

// MARK: - Error Handling
enum TranslinkApiError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, message: String)
    case networkError(String)
    case decodingError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode, let message):
            return "TransLink API Error: \(statusCode) \(message)"
        case .networkError(let message):
            return "Network error: \(message)"
        case .decodingError(let message):
            return "Failed to decode response: \(message)"
        }
    }
} 