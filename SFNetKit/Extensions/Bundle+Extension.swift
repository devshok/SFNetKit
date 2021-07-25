import Foundation

extension Bundle {
    
    // MARK: - Errors
    
    enum ConfigError: String, Error {
        case missingKey
        case invalidValue
        case missingBundle
    }
    
    // MARK: - Access Keys
    
    enum APIAccessKey: String {
        case baseURL = "API_BASE_URL"
        case basePath = "API_BASE_PATH"
        case baseWord = "API_BASE_WORD"
    }
    
    // MARK: - Straight Access
    
    func getValue<T>(
        for key: APIAccessKey
    ) throws -> T where T: LosslessStringConvertible {
        
        guard let object = object(forInfoDictionaryKey: key.rawValue) else {
            throw ConfigError.missingKey
        }
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else {
                fallthrough
            }
            return value
        default:
            throw ConfigError.invalidValue
        }
    }
}
