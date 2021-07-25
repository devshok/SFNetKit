import Combine
import XCTest
@testable import SFNetKit

class SFNetKitTests: XCTestCase {
    
    // MARK: - Properties
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private lazy var frameworkBundle: Bundle? = {
        let identifier = "io.shokuroff.SFNetKit"
        return .init(identifier: identifier)
    }()
    
    private lazy var sessionConfiguration: URLSessionConfiguration = {
        let c = URLSessionConfiguration.default
        c.timeoutIntervalForRequest = 5
        c.waitsForConnectivity = true
        c.allowsCellularAccess = true
        c.urlCache = {
            let cache = URLCache()
            cache.memoryCapacity = 3_000_000 // 3 megabytes.
            cache.diskCapacity = 40_000_000 // 40 megabytes.
            return cache
        }()
        return c
    }()
    
    private lazy var sessionQueue: OperationQueue = {
        let q = OperationQueue()
        q.qualityOfService = .userInitiated
        return q
    }()
    
    private lazy var session: URLSession = {
        return .init(configuration: sessionConfiguration,
                     delegate: nil,
                     delegateQueue: sessionQueue)
    }()
    
    private lazy var clientConfiguration: ClientConfiguration = {
        return ClientConfigurationImpl(session: session,
                                       attemptsPerRequest: 3)
    }()
    
    private lazy var netKit: NetKit = {
        return .init(configuration: clientConfiguration)
    }()
    
    private var publisher: AnyPublisher<TestResponse, NetworkError>?

    // MARK: - Cycles
    
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {
        self.cancellableSet.forEach {
            $0.cancel()
        }
        self.cancellableSet.removeAll()
        self.publisher = nil
    }
    
    // MARK: - Tests
    
    func testBaseURLNotNil() {
        let result: String? = try? frameworkBundle?.getValue(for: .baseURL)
        XCTAssertNotNil(result)
    }
    
    func testBaseURLNotEmpty() {
        let result: String = (try? frameworkBundle?.getValue(for: .baseURL)) ?? ""
        XCTAssertFalse(result.isEmpty)
    }
    
    func testBaseURLCorrection() {
        let reality: String = (try? frameworkBundle?.getValue(for: .baseURL)) ?? ""
        let expected = "bin.arnastofnun.is"
        XCTAssert(reality == expected)
    }
    
    func testBaseAPINotNil() {
        let result: String? = try? frameworkBundle?.getValue(for: .basePath)
        XCTAssertNotNil(result)
    }
    
    func testBaseAPINotEmpty() {
        let result: String = (try? frameworkBundle?.getValue(for: .basePath)) ?? ""
        XCTAssertFalse(result.isEmpty)
    }
    
    func testBaseAPICorrection() {
        let reality: String = (try? frameworkBundle?.getValue(for: .basePath)) ?? ""
        let expected = "api"
        XCTAssert(reality == expected)
    }
    
    func testAPIWordNotNil() {
        let result: String? = try? frameworkBundle?.getValue(for: .baseWord)
        XCTAssertNotNil(result)
    }
    
    func testAPIWordAPINotEmpty() {
        let result: String = (try? frameworkBundle?.getValue(for: .baseWord)) ?? ""
        XCTAssertFalse(result.isEmpty)
    }
    
    func testAPIWordCorrection() {
        let reality: String = (try? frameworkBundle?.getValue(for: .baseWord)) ?? ""
        let expected = "ord"
        XCTAssert(reality == expected)
    }
}

// MARK: - Test Response

private extension SFNetKitTests {
    struct TestResponse: Decodable {}
}
