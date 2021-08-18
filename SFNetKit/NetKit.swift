import Foundation
import Combine

public final class NetKit: ObservableObject {
    
    // MARK: - Client
    
    private let client: Client
    
    // MARK: - Cache Publisher & Subscriber
    
    @Published
    public var bytesCachePublisher: Int = .zero
    
    private var bytesCacheSubscriber: AnyCancellable?
    
    // MARK: - Initialization
    
    public init(configuration: ClientConfiguration) {
        self.client = ClientImpl(configuration: configuration)
        self.listenEvents()
    }
    
    deinit {
        self.removeEvents()
    }
    
    // MARK: - Helpers
    
    private func listenEvents() {
        bytesCacheSubscriber = client.bytesCachePublisher
            .assign(to: \.bytesCachePublisher, on: self)
        bytesCachePublisher = URLCache.shared.currentDiskUsage
    }
    
    private func removeEvents() {
        bytesCacheSubscriber?.cancel()
        bytesCacheSubscriber = nil
    }
    
    // MARK: - Default Instance
    
    public static var `default`: Self {
        return .init(configuration: defaultConfiguration)
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
            return try frameworkBundle.getValue(for: .baseURL)
        } catch let configError as Bundle.ConfigError {
            debugPrint(self, #function, #line, configError.rawValue)
            return String()
        } catch {
            debugPrint(self, #function, #line, error.localizedDescription)
            return String()
        }
    }
    
    private var frameworkBundle: Bundle {
        Bundle.init(identifier: "io.shokuroff.SFNetKit") ?? .main
    }
    
    private static let defaultConfiguration: ClientConfiguration = {
        return ClientConfigurationImpl(
            session: defaultSession,
            attemptsPerRequest: 3
        )
    }()
    
    private static let defaultSession: URLSession = {
        let s = URLSession(
            configuration: defaultSessionConfiguration,
            delegate: nil,
            delegateQueue: defaultSessionQueue
        )
        return s
    }()
    
    private static let defaultSessionConfiguration: URLSessionConfiguration = {
        let c = URLSessionConfiguration.default
        c.networkServiceType = .responsiveData
        c.timeoutIntervalForRequest = 15
        c.timeoutIntervalForResource = 15
        c.urlCache = {
            let cache = URLCache()
            cache.memoryCapacity = 3_000_000 // 3 megabytes.
            cache.diskCapacity = 40_000_000 // 40 megabytes.
            return cache
        }()
        c.waitsForConnectivity = false
        return c
    }()
    
    private static var defaultSessionQueue: OperationQueue = {
        let q = OperationQueue()
        q.qualityOfService = .userInitiated
        q.maxConcurrentOperationCount = 2
        q.name = "queue.netKit.Snorrify.io.github.shokuroff"
        return q
    }()
}
