//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Foundation

internal final class Resources {

    internal func url(forResource resource: String, withExtension extension: String) -> URL? {
        let bundle: Bundle = .moduleRelativeToExecutable ?? .module
        return bundle.url(forResource: resource, withExtension: `extension`)
    }
}

extension Bundle {

    // swiftlint:disable:next strict_fileprivate
    fileprivate static var moduleRelativeToExecutable: Bundle? {
        guard let url: URL = Bundle.main.executableURL
        else { return nil }
        let name: String = "Nodes_NodesGenerator.bundle"
        return Bundle(url: url.deletingLastPathComponent().appendingPathComponent(name))
    }
}
