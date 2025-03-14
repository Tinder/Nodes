//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Nimble
@testable import NodesGenerator
import SnapshotTesting
import XCTest

final class PresetGeneratorTests: XCTestCase {

    private let fileHeader: String = "\n//  Created by <author> on <date>.\n//"

    func testIsPresetNodeName() {
        expect(Preset.isPresetNodeName("Hello World")) == false
        ["App", "WindowScene", "Window", "Root"].forEach { nodeName in
            expect(Preset.isPresetNodeName(nodeName)) == true
        }
    }

    func testGenerateAppPreset() throws {
        let fileSystem: FileSystemMock = .init()
        let url: URL = .init(fileURLWithPath: "/")
        try PresetGenerator(config: Config(), fileSystem: fileSystem)
            .generate(preset: .app, with: fileHeader, into: url)
        // swiftlint:disable:next large_tuple
        let writes: [(contents: String, path: String, atomically: Bool)] = fileSystem.writes
        writes.forEach { assertSnapshot(of: $0.contents, as: .lines, named: "Contents.\($0.path)") }
        assertSnapshot(of: writes.map { (path: $0.path, atomically: $0.atomically) }, as: .dump, named: "Writes")
        expect(fileSystem.directories).to(beEmpty())
        expect(fileSystem.copies).to(beEmpty())
        expect(fileSystem.deletions).to(beEmpty())
    }

    func testGenerateScenePreset() throws {
        let fileSystem: FileSystemMock = .init()
        let url: URL = .init(fileURLWithPath: "/")
        try PresetGenerator(config: Config(), fileSystem: fileSystem)
            .generate(preset: .scene, with: fileHeader, into: url)
        // swiftlint:disable:next large_tuple
        let writes: [(contents: String, path: String, atomically: Bool)] = fileSystem.writes
        writes.forEach { assertSnapshot(of: $0.contents, as: .lines, named: "Contents.\($0.path)") }
        assertSnapshot(of: writes.map { (path: $0.path, atomically: $0.atomically) }, as: .dump, named: "Writes")
        expect(fileSystem.directories).to(beEmpty())
        expect(fileSystem.copies).to(beEmpty())
        expect(fileSystem.deletions).to(beEmpty())
    }

    func testGenerateWindowPreset() throws {
        let fileSystem: FileSystemMock = .init()
        let url: URL = .init(fileURLWithPath: "/")
        try PresetGenerator(config: Config(), fileSystem: fileSystem)
            .generate(preset: .window, with: fileHeader, into: url)
        // swiftlint:disable:next large_tuple
        let writes: [(contents: String, path: String, atomically: Bool)] = fileSystem.writes
        writes.forEach { assertSnapshot(of: $0.contents, as: .lines, named: "Contents.\($0.path)") }
        assertSnapshot(of: writes.map { (path: $0.path, atomically: $0.atomically) }, as: .dump, named: "Writes")
        expect(fileSystem.directories).to(beEmpty())
        expect(fileSystem.copies).to(beEmpty())
        expect(fileSystem.deletions).to(beEmpty())
    }

    func testGenerateRootPreset() throws {
        let fileSystem: FileSystemMock = .init()
        let url: URL = .init(fileURLWithPath: "/")
        try PresetGenerator(config: Config(), fileSystem: fileSystem)
            .generate(preset: .root, with: fileHeader, into: url)
        // swiftlint:disable:next large_tuple
        let writes: [(contents: String, path: String, atomically: Bool)] = fileSystem.writes
        writes.forEach { assertSnapshot(of: $0.contents, as: .lines, named: "Contents.\($0.path)") }
        assertSnapshot(of: writes.map { (path: $0.path, atomically: $0.atomically) }, as: .dump, named: "Writes")
        expect(fileSystem.directories).to(beEmpty())
        expect(fileSystem.copies).to(beEmpty())
        expect(fileSystem.deletions).to(beEmpty())
    }
}
