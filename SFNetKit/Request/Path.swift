import Foundation

public enum Path {
    case word(String)
    case wordId(String)
    
    var string: String {
        switch self {
        case .word(let value), .wordId(let value):
            return apiPath(by: [basePath, baseWord, value])
        }
    }
    
    // MARK: - API Parts
    
    private var basePath: String {
        do {
            guard let bundle = frameworkBundle else {
                debugPrint(self, #function, #line, Bundle.ConfigError.missingBundle.rawValue)
                return String()
            }
            return try bundle.getValue(for: .basePath)
        } catch let error as Bundle.ConfigError {
            debugPrint(self, #function, #line, error.rawValue)
            return String()
        } catch {
            debugPrint(self, #function, #line, error.localizedDescription)
            return String()
        }
    }
    
    private var baseWord: String {
        do {
            guard let bundle = frameworkBundle else {
                debugPrint(self, #function, #line, Bundle.ConfigError.missingBundle.rawValue)
                return String()
            }
            return try bundle.getValue(for: .baseWord)
        } catch let error as Bundle.ConfigError {
            debugPrint(self, #function, #line, error.rawValue)
            return String()
        } catch {
            debugPrint(self, #function, #line, error.localizedDescription)
            return String()
        }
    }
    
    // MARK: - Helpers
    
    private func apiPath(by strings: [String]) -> String {
        return "/" + strings.joined(separator: "/")
    }
    
    private var frameworkBundle: Bundle? {
        let identifier = "io.shokuroff.SFNetKit"
        return .init(identifier: identifier)
    }
}
