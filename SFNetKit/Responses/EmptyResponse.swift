import Foundation

struct EmptyResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case singleKey = "0"
    }
    
    private let value: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(String.self, forKey: .singleKey)
    }
    
    var empty: Bool {
        value.isEmpty
    }
}
