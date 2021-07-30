import Foundation

extension Dictionary {
    var noSearchResults: Bool {
        if count == 1 {
            if let firstKey = keys.first as? String, firstKey == "0" {
                if let firstValue = values.first as? String, firstValue.isEmpty {
                    return true
                }
            }
        }
        return false
    }
}
