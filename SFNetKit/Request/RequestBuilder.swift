import Foundation

struct RequestBuilder {
    
    // MARK: - Singleton
    
    static let shared = RequestBuilder()
    
    // MARK: - Builder
    
    func build(with configuration: RequestConfiguration) -> URLRequest? {
        let components: URLComponents = {
            var c = URLComponents()
            c.scheme = configuration.scheme
            c.host = configuration.host
            c.path = configuration.path
            return c
        }()
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        request.httpMethod = configuration.method
        return request
    }
}
