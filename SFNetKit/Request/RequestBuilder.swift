import Foundation

struct RequestBuilder {
    
    // MARK: - Singleton
    
    static let shared = RequestBuilder()
    
    // MARK: - Builder
    
    func build(with configuration: RequestConfiguration) -> URLRequest? {
        defer {
            let cache = URLCache.shared
            let memoryKilobytes = Double(cache.memoryCapacity / 1024)
            let memory = "memory capacity: \(memoryKilobytes) KB"
            let diskKilobytes = Double(cache.diskCapacity / 1024)
            let disk = "disk capacity: \(diskKilobytes) KB"
            let currentKilobytes = Double(cache.currentDiskUsage / 1024)
            let current = "current disk usage: \(currentKilobytes) KB"
            debugPrint("RequestBuilder", #function, #line, memory, disk, current)
        }
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
