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
}

// MARK: - Bundle Tests

extension SFNetKitTests {
    
    func testBundleBaseURLNotNil() {
        let result: String? = try? frameworkBundle?.getValue(for: .baseURL)
        XCTAssertNotNil(result)
    }
    
    func testBundleBaseURLNotEmpty() {
        let result: String = (try? frameworkBundle?.getValue(for: .baseURL)) ?? ""
        XCTAssertFalse(result.isEmpty)
    }
    
    func testBundleBaseURLValidation() {
        let reality: String = (try? frameworkBundle?.getValue(for: .baseURL)) ?? ""
        let expected = "bin.arnastofnun.is"
        XCTAssert(reality == expected)
    }
    
    func testBundleBaseAPINotNil() {
        let result: String? = try? frameworkBundle?.getValue(for: .basePath)
        XCTAssertNotNil(result)
    }
    
    func testBundleBaseAPINotEmpty() {
        let result: String = (try? frameworkBundle?.getValue(for: .basePath)) ?? ""
        XCTAssertFalse(result.isEmpty)
    }
    
    func testBundleBaseAPIValidation() {
        let reality: String = (try? frameworkBundle?.getValue(for: .basePath)) ?? ""
        let expected = "api"
        XCTAssert(reality == expected)
    }
    
    func testBundleAPIWordNotNil() {
        let result: String? = try? frameworkBundle?.getValue(for: .baseWord)
        XCTAssertNotNil(result)
    }
    
    func testBundleAPIWordAPINotEmpty() {
        let result: String = (try? frameworkBundle?.getValue(for: .baseWord)) ?? ""
        XCTAssertFalse(result.isEmpty)
    }
    
    func testBundleAPIWordValidation() {
        let reality: String = (try? frameworkBundle?.getValue(for: .baseWord)) ?? ""
        let expected = "ord"
        XCTAssert(reality == expected)
    }
}

// MARK: - Request Builder Tests

extension SFNetKitTests {
    
    private func requestConfiguration(for word: String) -> RequestConfiguration {
        let host: String = (try? frameworkBundle?.getValue(for: .baseURL)) ?? ""
        return RequestConfigurationImpl(host: host, path: .word(word))
    }
    
    func testRequestBuilderRequestNotNil() {
        let word = "skilja"
        let configuration = requestConfiguration(for: word)
        let request = RequestBuilder.shared.build(with: configuration)
        XCTAssertNotNil(request)
    }
    
    func testRequestBuilderURLCorrection() {
        let word = "skilja"
        let configuration = requestConfiguration(for: word)
        let request = RequestBuilder.shared.build(with: configuration)
        let expected = "https://bin.arnastofnun.is/api/ord/\(word)"
        let reality = request?.url?.absoluteString ?? ""
        XCTAssert(reality == expected, "\(reality) vs \(expected)")
    }
}

// MARK: - Request Tests

extension SFNetKitTests {
    
    func testRequestForGoodSession() {
        let expectation = XCTestExpectation(description: "\(#function)")
        let word = "skilja"
        let publisher: AnyPublisher<TestResponse, NetworkError> = {
            return netKit.request(path: .word(word))
        }()
        publisher.sink(receiveCompletion: { completion in
            XCTAssert(completion == .finished)
            expectation.fulfill()
        }, receiveValue: { _ in }).store(in: &cancellableSet)
        wait(for: [expectation], timeout: 10)
    }
}

// MARK: - Network Equatable Conformance Tests

extension SFNetKitTests {
    
    func testEqualNetworkErrors() {
        XCTAssertTrue(.badInternet == .badInternet)
    }
    
    func testNotEqualNetworkErrors() {
        XCTAssertTrue(.badRequest != .badInternet)
    }
}

// MARK: - Error Mapper Tests

extension SFNetKitTests {
    
    func testErrorMapper() {
        let urlError = URLError.init(.badServerResponse)
        let reality = ErrorMapper.shared.map(urlError: urlError)
        XCTAssertTrue(reality == .badResponse)
    }
}

// MARK: - Test Response

private extension SFNetKitTests {
    struct TestResponse: Decodable, CustomDebugStringConvertible {
        var debugDescription: String { .init(describing: Self.self) }
    }
}
