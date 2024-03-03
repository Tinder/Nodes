//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Foundation

#if BAZEL
import PathKit
#endif

internal final class Resources {

    #if BAZEL

    // swiftlint:disable force_unwrapping

    internal func url(forResource resource: String, withExtension extension: String) -> URL {
        // swiftlint:disable:next force_try
        try! Path(Bundle.main.bundleURL.path)
            .children()
            .first { $0.extension == "runfiles" }!
            .recursiveChildren()
            .first { $0.lastComponentWithoutExtension == resource && $0.extension == `extension` }!
            .url
            .resolvingSymlinksInPath()
    }

    // swiftlint:enable force_unwrapping

    #else

    internal func url(forResource resource: String, withExtension extension: String) -> URL {
        let bundle: Bundle = .moduleRelativeToExecutable ?? .module
        // swiftlint:disable:next force_unwrapping
        return bundle.url(forResource: resource, withExtension: `extension`)!
    }

    #endif
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
