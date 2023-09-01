//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

import Combine

extension Set where Element == AnyCancellable {

    public mutating func cancelAll(keepingCancellables keepCancellables: Bool = false) {
        forEach { cancellable in
            cancellable.cancel()
            LeakDetector.detect(cancellable)
        }
        if !keepCancellables {
            removeAll()
        }
    }
}
