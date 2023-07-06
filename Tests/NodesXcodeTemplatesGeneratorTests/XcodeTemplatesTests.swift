//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

@testable import NodesXcodeTemplatesGenerator
import SnapshotTesting
import XCTest

final class XcodeTemplatesTests: XCTestCase {

    private typealias Config = XcodeTemplates.Config

    private struct TestContext: Context {

        let dictionary: [String: Any] = ["key": "value"]
    }

    private struct TestXcodeTemplate: XcodeTemplate {

        let name: String = "name"
        let type: String = "type"
        let stencils: [StencilTemplate] = []
        let context: Context = TestContext()
        let propertyList: PropertyList = .init(description: "description", sortOrder: 23) {}
    }

    func testGenerateWithIdentifier() throws {
        let fileSystem: FileSystemMock = .init()
        try XcodeTemplates(config: Config()).generate(identifier: "identifier", using: fileSystem)
        assertSnapshot(matching: fileSystem.directories,
                       as: .dump,
                       named: "Directories")
        assertSnapshot(matching: fileSystem.writes.map { ($0.path, $0.atomically) },
                       as: .dump,
                       named: "Writes")
        fileSystem.writes.forEach { write in
            assertSnapshot(matching: write.contents,
                           as: .lines,
                           named: "Contents.\(write.path)")
        }
        assertSnapshot(matching: fileSystem.copies,
                       as: .dump,
                       named: "Copies")
        assertSnapshot(matching: fileSystem.deletions,
                       as: .dump,
                       named: "Deletions")
    }

    func testGenerateWithURL() throws {
        let fileSystem: FileSystemMock = .init()
        let url: URL = .init(fileURLWithPath: "/")
        try XcodeTemplates(config: Config()).generate(at: url, using: fileSystem)
        assertSnapshot(matching: fileSystem.directories,
                       as: .dump,
                       named: "Directories")
        assertSnapshot(matching: fileSystem.writes.map { ($0.path, $0.atomically) },
                       as: .dump,
                       named: "Writes")
        fileSystem.writes.forEach { write in
            assertSnapshot(matching: write.contents,
                           as: .lines,
                           named: "Contents.\(write.path)")
        }
        assertSnapshot(matching: fileSystem.copies,
                       as: .dump,
                       named: "Copies")
        assertSnapshot(matching: fileSystem.deletions,
                       as: .dump,
                       named: "Deletions")
    }
}
