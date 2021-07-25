import Foundation
import Combine

final class ClientImpl: Client {
    
    // MARK: - Configuration
    
    private let configuration: ClientConfiguration
    
    // MARK: - Initialization
    
    init(configuration: ClientConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Interface
    
    func get<T>(
        _ T: T.Type, using someRequest: URLRequest?
    ) -> AnyPublisher<T, NetworkError> where T: Decodable {
        
        guard let request = someRequest else {
            debugPrint(self, #function, #line)
            return Fail(error: NetworkError.badRequest)
                .eraseToAnyPublisher()
        }
        return configuration.session.dataTaskPublisher(for: request)
            .retry(configuration.attemptsPerRequest)
            .mapError { urlError -> NetworkError in
                return ErrorMapper.shared.map(urlError: urlError)
            }
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { decodingError in
                return ErrorMapper.shared.map(decodingError: decodingError)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
