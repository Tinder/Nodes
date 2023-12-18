//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Foundation

extension Bundle {

    #if BAZEL

    private class BundleLocator {}

    internal static let module: Bundle = {
        let candidates: [URL] = [
            Bundle.main.resourceURL,
            Bundle(for: BundleLocator.self).resourceURL,
            Bundle.main.bundleURL
        ].compactMap { $0 }
        let bundles: [Bundle] = candidates
            .map { $0.appendingPathComponent(moduleBundleName) }
            .compactMap(Bundle.init)
        guard let module: Bundle = bundles.first
        else { fatalError("Failed to locate bundle: \(moduleBundleName)") }
        return module
    }()

    #endif

    internal static var moduleRelativeToExecutable: Bundle? {
        guard let url: URL = Bundle.main.executableURL
        else { return nil }
        return Bundle(url: url.deletingLastPathComponent().appendingPathComponent(moduleBundleName))
    }

    private static let moduleBundleName: String = "Nodes_NodesXcodeTemplatesGenerator.bundle"
}
