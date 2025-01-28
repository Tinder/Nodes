//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Foundation

extension String {

    internal var sanitized: String {
        String(unicodeScalars.filter(CharacterSet.alphanumerics.contains))
    }

    internal func replacingOccurrences(
        of targets: [String],
        with replacement: String
    ) -> String {
        targets.reduce(self) { $0.replacingOccurrences(of: $1, with: replacement) }
    }
}
