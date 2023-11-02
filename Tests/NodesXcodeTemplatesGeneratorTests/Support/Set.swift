//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

extension Set where Element == String {

    internal static func mock(with identifier: String, count: Int) -> Self {
        Set([String].mock(with: identifier, count: count))
    }
}
