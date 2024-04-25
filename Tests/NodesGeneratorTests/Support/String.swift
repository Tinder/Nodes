//
//  Copyright © 2023 Tinder (Match Group, LLC)
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
