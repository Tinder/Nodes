//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

extension String {

    internal func replacingOccurrences(
        of targets: [String],
        with replacement: String
    ) -> String {
        targets.reduce(self) { $0.replacingOccurrences(of: $1, with: replacement) }
    }
}
