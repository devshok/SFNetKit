import Foundation
import Combine

class CombineObject {
    
    // MARK: - Subscriptions
    
    var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Life Cycle
    
    init() {}
    
    deinit {
        subscriptions.forEach {
            $0.cancel()
        }
    }
}
