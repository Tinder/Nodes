//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

import Foundation

internal class PathComponent: CustomStringConvertible {

    internal let description: String

    internal init<T>(for type: T.Type) {
        description = "\(T.self)"
            .components(separatedBy: ".")
            .reversed()[0]
    }
}
