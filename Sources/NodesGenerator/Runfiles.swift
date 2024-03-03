//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

#if BAZEL

import Foundation
import PathKit

internal protocol Runfiles {

    func makeResourceURL(
        filename: String,
        extension: String
    ) throws -> URL
}

internal final class RunfilesImp: Runfiles {

    private enum Error: Swift.Error {
        case missingRunfiles(bundlePath: String)
        case missingResource(filename: String, bundlePath: String)
    }

    func makeResourceURL(
        filename: String,
        extension: String
    ) throws -> URL {
        let bundlePath: Path = Path(Bundle.main.bundleURL.path)
        guard let runfilesPath: Path = try bundlePath.children().first(where: { path in
            path.extension == "runfiles"
        }) else {
            throw Error.missingRunfiles(
                bundlePath: bundlePath.string
            )
        }
        guard let resourcePath: Path = try runfilesPath.recursiveChildren().first(where: { path in
            path.lastComponentWithoutExtension == filename
                && path.extension == `extension`
        }) else {
            throw Error.missingResource(
                filename: filename,
                bundlePath: bundlePath.string
            )
        }
        return resourcePath.url
    }
}

#endif
