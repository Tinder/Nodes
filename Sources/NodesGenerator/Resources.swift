//
//  Copyright © 2021 Tinder (Match Group, LLC)
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
