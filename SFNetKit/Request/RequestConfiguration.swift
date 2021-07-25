import Foundation

protocol RequestConfiguration {
    
    init(scheme: Scheme, host: String, path: Path, method: Method)
    
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: String { get }
}
