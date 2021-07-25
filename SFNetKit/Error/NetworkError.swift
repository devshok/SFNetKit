import Foundation

public enum NetworkError: Error {    
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
}
