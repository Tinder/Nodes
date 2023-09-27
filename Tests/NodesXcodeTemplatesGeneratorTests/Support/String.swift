//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

extension String {

    internal static func mock(with identifier: String, when condition: @autoclosure () -> Bool) -> Self {
        guard condition()
        else { return "" }
        return "<\(identifier)>"
    }
}
