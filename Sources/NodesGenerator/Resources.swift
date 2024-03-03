//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Foundation

internal protocol Resources {

    func makeURL(
        filename: String,
        extension: String
    ) throws -> URL
}

internal final class ResourcesImp: Resources {

    private enum Error: Swift.Error {
        case missingExecutableURL
        case missingBundle(path: String)
        case missingResource(bundlePath: String, filename: String, extension: String)
    }

    func makeURL(
        filename: String,
        extension: String
    ) throws -> URL {
        #if BAZEL
        return try makeRunfilesURL(
            filename: filename,
            extension: `extension`
        )
        #else
        return try makeBundleURL(
            filename: filename,
            extension: `extension`
        )
        #endif
    }

    #if BAZEL
    private func makeRunfilesURL(
        filename: String,
        extension: String
    ) throws -> URL {
        try RunfilesImp().makeResourceURL(
            filename: filename,
            extension: `extension`
        )
    }

    #else

    private func makeBundleURL(
        filename: String,
        extension: String
    ) throws -> URL {
        guard let executableURL: URL = Bundle.main.executableURL else {
            throw Error.missingExecutableURL
        }
        let bundleURL: URL = executableURL
            .deletingLastPathComponent()
            .appendingPathComponent("Nodes_NodesGenerator.bundle")
        guard let bundle: Bundle = .init(url: bundleURL) else {
            throw Error.missingBundle(
                path: bundleURL.path
            )
        }
        guard let resourceURL: URL = bundle.url(
            forResource: filename,
            withExtension: `extension`
        ) else {
            throw Error.missingResource(
                bundlePath: bundleURL.path,
                filename: filename,
                extension: `extension`
            )
        }
        return resourceURL
    }
    #endif
}
