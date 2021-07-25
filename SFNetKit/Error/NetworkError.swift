import Foundation

public enum NetworkError: Error, Equatable {
    case unknown
    case cancelledRequest
    case badRequest
    case badURL
    case timedOut
    case serverUnavailable
    case noInternet
    case badInternet
    case notFound
    case badResponse
    case other(localizedDescription: String)
    
    private var identifier: Int {
        switch self {
        case .unknown:
            return 1
        case .cancelledRequest:
            return 2
        case .badRequest:
            return 3
        case .badURL:
            return 4
        case .timedOut:
            return 5
        case .serverUnavailable:
            return 6
        case .noInternet:
            return 7
        case .badInternet:
            return 8
        case .notFound:
            return 9
        case .badResponse:
            return 10
        case .other:
            return 11
        }
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    public static func != (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier != rhs.identifier
    }
}
