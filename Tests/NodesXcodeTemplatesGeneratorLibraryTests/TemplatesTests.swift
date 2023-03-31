//
//  TemplatesTests.swift
//  NodesXcodeTemplatesGeneratorLibraryTests
//
//  Created by Christopher Fuller on 5/31/21.
//

@testable import NodesXcodeTemplatesGeneratorLibrary
import SnapshotTesting
import XCTest

final class TemplatesTests: XCTestCase, TestFactories {

    func testNodeTemplate() throws {
        try UIFramework.Kind.allCases.forEach {
            try assertSnapshot(matching: NodeTemplate(for: $0, config: givenConfig()),
                               as: .dump,
                               named: $0.rawValue)
        }
    }

    func testNodeViewInjectedTemplate() {
        assertSnapshot(matching: NodeViewInjectedTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testPluginListNodeTemplate() {
        assertSnapshot(matching: PluginListNodeTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testPluginNodeTemplate() {
        assertSnapshot(matching: PluginNodeTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testPluginTemplate() {
        assertSnapshot(matching: PluginTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testWorkerTemplate() {
        assertSnapshot(matching: WorkerTemplate(config: givenConfig()),
                       as: .dump)
    }
}
