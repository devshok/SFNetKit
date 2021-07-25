import Foundation

struct ErrorMapper {
    
    // MARK: - Singleton
    
    static let shared = ErrorMapper()
    
    // MARK: - Mapping
    
    func map(urlError: URLError) -> NetworkError {
        defer {
            debugPrint(self, #function, #line, urlError.localizedDescription)
        }
        switch urlError.code {
        case .unknown:
            return .unknown
        case .cancelled, .callIsActive:
            return .cancelledRequest
        case .badURL, .unsupportedURL:
            return .badURL
        case .timedOut:
            return .timedOut
        case .cannotFindHost, .cannotConnectToHost:
            return .serverUnavailable
        case .networkConnectionLost, .notConnectedToInternet:
            return .noInternet
        case .cannotLoadFromNetwork:
            return .badInternet
        case .resourceUnavailable:
            return .notFound
        case .badServerResponse,
             .cannotDecodeRawData,
             .cannotDecodeContentData,
             .cannotParseResponse:
            return .badResponse
        default:
            return .other(
                localizedDescription: urlError.localizedDescription
            )
        }
    }
    
    func map(decodingError: Error) -> NetworkError {
        defer {
            debugPrint(self, #function, #line, decodingError.localizedDescription)
        }
        switch decodingError {
        case is DecodingError:
            return .badResponse
        case let urlError as URLError:
            return map(urlError: urlError)
        default:
            return .other(
                localizedDescription: decodingError.localizedDescription
            )
        }
    }
}
