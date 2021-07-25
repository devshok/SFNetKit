import Foundation

public protocol ClientConfiguration {
    init(session: URLSession, attemptsPerRequest: Int, jsonDecoder: JSONDecoder)
    
    var session: URLSession { get }
    var attemptsPerRequest: Int { get }
    var jsonDecoder: JSONDecoder { get }
}
