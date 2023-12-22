//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import NodesXcodeTemplatesGenerator
import XCTest

final class XcodeTemplatesTests: XCTestCase {

    func testGenerateWithIdentifier() throws {
        let fileSystem: FileSystemMock = .init()
        try XcodeTemplates(config: givenConfig()).generate(identifier: "identifier", using: fileSystem)
        // swiftlint:disable:next large_tuple
        let writes: [(contents: String, path: String, atomically: Bool)] = fileSystem.writes
        writes.forEach { assertSnapshot(of: $0.contents, as: .lines, named: "Contents.\(name(from: $0.path))") }
        assertSnapshot(of: writes.map { (path: $0.path, atomically: $0.atomically) }, as: .dump, named: "Writes")
        assertSnapshot(of: fileSystem.directories, as: .dump, named: "Directories")
        assertSnapshot(of: fileSystem.copies, as: .dump, named: "Copies")
        assertSnapshot(of: fileSystem.deletions, as: .dump, named: "Deletions")
    }

    func testGenerateWithURL() throws {
        let fileSystem: FileSystemMock = .init()
        let url: URL = .init(fileURLWithPath: "/")
        try XcodeTemplates(config: givenConfig()).generate(at: url, using: fileSystem)
        // swiftlint:disable:next large_tuple
        let writes: [(contents: String, path: String, atomically: Bool)] = fileSystem.writes
        writes.forEach { assertSnapshot(of: $0.contents, as: .lines, named: "Contents.\(name(from: $0.path))") }
        assertSnapshot(of: writes.map { (path: $0.path, atomically: $0.atomically) }, as: .dump, named: "Writes")
        assertSnapshot(of: fileSystem.directories, as: .dump, named: "Directories")
        assertSnapshot(of: fileSystem.copies, as: .dump, named: "Copies")
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

    private func givenConfig() -> Config {
        var config: Config = .init()
        config.uiFrameworks = [
            UIFramework(framework: .appKit),
            UIFramework(framework: .uiKit),
            UIFramework(framework: .swiftUI),
            UIFramework(framework: .custom(name: "CustomFrameworkName",
                                           import: "CustomFrameworkImport",
                                           viewControllerType: "CustomFrameworkViewControllerType",
                                           viewControllerSuperParameters: ""))
        ]
        return config
    }
}
