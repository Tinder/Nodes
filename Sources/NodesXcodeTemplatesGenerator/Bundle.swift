//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Foundation

extension Bundle {

    internal static var moduleRelativeToExecutable: Bundle? {
        guard let url: URL = Bundle.main.executableURL
        else { return nil }
        let name: String = "Nodes_NodesXcodeTemplatesGenerator.bundle"
        return Bundle(url: url.deletingLastPathComponent().appendingPathComponent(name))
    }
}
