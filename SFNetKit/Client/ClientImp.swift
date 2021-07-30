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
        #if DEBUG
        let urlString = request.url?.absoluteString ?? ""
        print(self, #function, #line, "sending request.. 👉 \(urlString)")
        #endif
        return configuration.session.dataTaskPublisher(for: request)
            .retry(configuration.attemptsPerRequest)
            .mapError { urlError -> NetworkError in
                return ErrorMapper.shared.map(urlError: urlError)
            }
            .map { $0.data }
            .flatMap { data -> AnyPublisher<T, NetworkError> in
                if let emptyResponse = try? self.configuration.jsonDecoder.decode(EmptyResponse.self, from: data), emptyResponse.empty {
                    return Fail(error: NetworkError.noSearchResults).eraseToAnyPublisher()
                } else {
                    do {
                        let response = try self.configuration.jsonDecoder.decode(T.self, from: data)
                        return Just(response)
                            .setFailureType(to: NetworkError.self)
                            .eraseToAnyPublisher()
                    } catch let decodingError {
                        return Fail(error: ErrorMapper.shared.map(decodingError: decodingError)).eraseToAnyPublisher()
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
