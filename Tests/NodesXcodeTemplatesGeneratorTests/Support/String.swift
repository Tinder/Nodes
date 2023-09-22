//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

extension String {

    internal static func mock(with identifier: String, count: Int) -> Self {
        guard count > 0
        else { return "" }
        return "<\(identifier)>"
    }
}
