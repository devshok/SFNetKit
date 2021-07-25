import Foundation
import Combine

public struct NetKit {
    
    // MARK: - Client
    
    private let client: Client
    
    // MARK: - Initialization
    
    public init(configuration: ClientConfiguration) {
        self.client = ClientImpl(configuration: configuration)
    }
    
    // MARK: - Request
    
    public func request<T>(
        _ method: Method = .get,
        path: Path
    ) -> AnyPublisher<T, NetworkError> where T: Decodable {
        
        guard !host.isEmpty else {
            debugPrint(self, #function, #line)
            return Fail(error: NetworkError.badURL).eraseToAnyPublisher()
        }
        let configuration = RequestConfigurationImpl(host: host, path: path, method: method)
        let request = RequestBuilder.shared.build(with: configuration)
        return client.get(T.self, using: request)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Helpers
    
    private var host: String {
        do {
            return try Bundle.main.getValue(for: .baseURL)
        } catch let configError as Bundle.ConfigError {
            debugPrint(self, #function, #line, configError.rawValue)
            return String()
        } catch {
            debugPrint(self, #function, #line, error.localizedDescription)
            return String()
        }
    }
}
