//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import NodesGenerator
import XCTest

final class XcodeTemplateGeneratorTests: XCTestCase {

    func testGenerateWithIdentifier() throws {
        let fileSystem: FileSystemMock = .init()
        try XcodeTemplates(config: givenConfig(), fileSystem: fileSystem).generate(identifier: "identifier")
        // swiftlint:disable:next large_tuple
        let writes: [(contents: String, path: String, atomically: Bool)] = fileSystem.writes
        writes.forEach { assertSnapshot(of: $0.contents, as: .lines, named: "Contents.\(name(from: $0.path))") }
        assertSnapshot(of: writes.map { (path: $0.path, atomically: $0.atomically) }, as: .dump, named: "Writes")
        assertSnapshot(of: fileSystem.directories, as: .dump, named: "Directories")
        assertSnapshot(of: sanitize(fileSystem.copies), as: .dump, named: "Copies")
        assertSnapshot(of: fileSystem.deletions, as: .dump, named: "Deletions")
    }

    func testGenerateWithURL() throws {
        let fileSystem: FileSystemMock = .init()
        let url: URL = .init(fileURLWithPath: "/", isDirectory: true)
        try XcodeTemplates(config: givenConfig(), fileSystem: fileSystem).generate(into: url)
        // swiftlint:disable:next large_tuple
        let writes: [(contents: String, path: String, atomically: Bool)] = fileSystem.writes
        writes.forEach { assertSnapshot(of: $0.contents, as: .lines, named: "Contents.\(name(from: $0.path))") }
        assertSnapshot(of: writes.map { (path: $0.path, atomically: $0.atomically) }, as: .dump, named: "Writes")
        assertSnapshot(of: fileSystem.directories, as: .dump, named: "Directories")
        assertSnapshot(of: sanitize(fileSystem.copies), as: .dump, named: "Copies")
        assertSnapshot(of: fileSystem.deletions, as: .dump, named: "Deletions")
    }

    private func name(from path: String) -> String {
        path
            .split(separator: "/")
            .reversed()[0...1]
            .reversed()
            .joined(separator: "-")
            .replacingOccurrences(of: [".xctemplate", "___FILEBASENAME___", ".swift", ".plist"], with: "")
    }

    private func sanitize(_ copies: [(from: String, to: String)]) -> [(from: String, to: String)] {
        // swiftlint:disable:next identifier_name
        copies.map { from, to in
            let from: String = from.replacingOccurrences(of: "/Contents/Resources", with: "")
            #if BAZEL
            let bundle: String = "NodesGeneratorTests-macOS.xctest"
            return (from: ".bundle\(from.components(separatedBy: bundle).last!)", to: to)
            #else
            let bundle: String = "Nodes_NodesGenerator"
            return (from: from.components(separatedBy: bundle).last!, to: to)
            #endif
        }
    }

    private func givenConfig() -> Config {
        var config: Config = .init()
        config.uiFrameworks = [
            UIFramework(framework: .appKit),
            UIFramework(framework: .uiKit),
            UIFramework(framework: .uiKitSwiftUI),
            UIFramework(framework: .custom(name: "Custom",
                                           import: "CustomFramework",
                                           viewControllerType: "CustomViewController",
                                           viewControllerSuperParameters: "<viewControllerSuperParameters>",
                                           viewControllerMethods: "<viewControllerMethods>"))
        ]
        return config
    }
}
