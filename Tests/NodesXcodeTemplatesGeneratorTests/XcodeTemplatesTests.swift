//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

@testable import NodesXcodeTemplatesGenerator
import SnapshotTesting
import XCTest

final class XcodeTemplatesTests: XCTestCase {

    private struct TestStencilContext: StencilContext {

        let dictionary: [String: Any] = ["key": "value"]
    }

    private struct TestXcodeTemplate: XcodeTemplate {

        let name: String = "name"
        let type: String = "type"
        let stencilTemplates: [StencilTemplate] = []
        let stencilContext: StencilContext = TestStencilContext()
        let propertyList: PropertyList = .init(description: "description", sortOrder: 23) {}
    }

    func testGenerateWithIdentifier() throws {
        let fileSystem: FileSystemMock = .init()
        try XcodeTemplates(config: Config()).generate(identifier: "identifier", using: fileSystem)
        // swiftlint:disable:next large_tuple
        let writes: [(contents: String, path: String, atomically: Bool)] = fileSystem.writes
        writes.forEach { assertSnapshot(matching: $0.contents, as: .lines, named: "Contents.\(name(from: $0.path))") }
        assertSnapshot(matching: writes.map { (path: $0.path, atomically: $0.atomically) }, as: .dump, named: "Writes")
        assertSnapshot(matching: fileSystem.directories, as: .dump, named: "Directories")
        assertSnapshot(matching: fileSystem.copies, as: .dump, named: "Copies")
        assertSnapshot(matching: fileSystem.deletions, as: .dump, named: "Deletions")
    }

    func testGenerateWithURL() throws {
        let fileSystem: FileSystemMock = .init()
        let url: URL = .init(fileURLWithPath: "/")
        try XcodeTemplates(config: Config()).generate(at: url, using: fileSystem)
        // swiftlint:disable:next large_tuple
        let writes: [(contents: String, path: String, atomically: Bool)] = fileSystem.writes
        writes.forEach { assertSnapshot(matching: $0.contents, as: .lines, named: "Contents.\(name(from: $0.path))") }
        assertSnapshot(matching: writes.map { (path: $0.path, atomically: $0.atomically) }, as: .dump, named: "Writes")
        assertSnapshot(matching: fileSystem.directories, as: .dump, named: "Directories")
        assertSnapshot(matching: fileSystem.copies, as: .dump, named: "Copies")
        assertSnapshot(matching: fileSystem.deletions, as: .dump, named: "Deletions")
    }

    private func name(from path: String) -> String {
        path
            .split(separator: "/")
            .reversed()[0...1]
            .reversed()
            .joined(separator: "-")
            .replacingOccurrences(of: [".xctemplate", "___FILEBASENAME___", ".swift", ".plist"], with: "")
    }
}
