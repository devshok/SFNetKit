import Foundation
import Combine

protocol Client: AnyObject {
    init(configuration: ClientConfiguration)
    var bytesCachePublisher: PassthroughSubject<Int, Never> { get }
    func get<T>(_ T: T.Type, using someRequest: URLRequest?) -> AnyPublisher<T, NetworkError> where T: Decodable
}
