//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

import Foundation

extension String {

    internal func replacingOccurrences(
        of targets: [String],
        with replacement: String
    ) -> String {
        targets.reduce(self) { partialResult, target in
            partialResult.replacingOccurrences(of: target, with: replacement)
        }
    }
}
