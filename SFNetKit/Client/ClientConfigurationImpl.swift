import Foundation

public struct ClientConfigurationImpl: ClientConfiguration {
    
    // MARK: - Properties
    
    public let session: URLSession
    public let attemptsPerRequest: Int
    public let jsonDecoder: JSONDecoder
    
    // MARK: - Initialization
    
    public init(session: URLSession,
         attemptsPerRequest: Int = 1,
         jsonDecoder: JSONDecoder = .init()
    ) {
        self.session = session
        self.attemptsPerRequest = attemptsPerRequest
        self.jsonDecoder = jsonDecoder
    }
}
