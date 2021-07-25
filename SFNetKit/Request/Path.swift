import Foundation

public enum Path {
    case word(String)
    
    var string: String {
        switch self {
        case .word(let value):
            return apiPath(by: [basePath, baseWord, value])
        }
    }
    
    // MARK: - API Parts
    
    private var basePath: String {
        do {
            return try Bundle.main.getValue(for: .basePath)
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
            return try Bundle.main.getValue(for: .baseWord)
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
        return strings.joined(separator: "/")
    }
}
