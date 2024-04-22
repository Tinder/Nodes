//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

import NodesGenerator

extension UIFramework.Kind {

    internal var condensedName: String {
        rawValue.replacingOccurrences(of: " - ", with: "")
    }
}
