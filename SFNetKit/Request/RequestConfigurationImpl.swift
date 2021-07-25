import Foundation

struct RequestConfigurationImpl: RequestConfiguration {
    
    // MARK: - Properties
    
    let scheme: String
    let host: String
    let path: String
    let method: String
    
    // MARK: - Initialization
    
    init(scheme: Scheme = .https, host: String, path: Path, method: Method = .get) {
        self.scheme = scheme.rawValue
        self.host = host
        self.path = path.string
        self.method = method.rawValue
    }
}
