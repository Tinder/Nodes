//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

#if canImport(Combine)

import Combine

extension Set where Element == AnyCancellable {

    public mutating func cancelAll(keepingCancellables keepCancellables: Bool = false) {
        forEach { cancellable in
            cancellable.cancel()
            if !keepCancellables {
                LeakDetector.detect(cancellable)
            }
        }
        if !keepCancellables {
            removeAll()
        }
    }
}

#endif
