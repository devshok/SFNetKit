import Foundation

struct ClientConfigurationImpl: ClientConfiguration {
    
    // MARK: - Properties
    
    let session: URLSession
    let attemptsPerRequest: Int
    let jsonDecoder: JSONDecoder
    
    // MARK: - Initialization
    
    init(session: URLSession,
         attemptsPerRequest: Int = 1,
         jsonDecoder: JSONDecoder = .init()
    ) {
        self.session = session
        self.attemptsPerRequest = attemptsPerRequest
        self.jsonDecoder = jsonDecoder
    }
}
