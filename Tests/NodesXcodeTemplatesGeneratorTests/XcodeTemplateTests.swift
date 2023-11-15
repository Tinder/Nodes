//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

@testable import NodesXcodeTemplatesGenerator
import SnapshotTesting
import XCTest

final class XcodeTemplateTests: XCTestCase, TestFactories {

    func testNodeXcodeTemplate() throws {
        try UIFramework.Kind.allCases.forEach { kind in
            try assertSnapshot(matching: NodeXcodeTemplate(for: kind, config: givenConfig()),
                               as: .dump,
                               named: kind.rawValue)
        }
    }

    func testNodeViewInjectedXcodeTemplate() {
        assertSnapshot(matching: NodeViewInjectedXcodeTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testPluginListNodeXcodeTemplate() {
        assertSnapshot(matching: PluginListNodeXcodeTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testPluginNodeXcodeTemplate() {
        assertSnapshot(matching: PluginNodeXcodeTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testPluginXcodeTemplate() {
        assertSnapshot(matching: PluginXcodeTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testWorkerXcodeTemplate() {
        assertSnapshot(matching: WorkerXcodeTemplate(config: givenConfig()),
                       as: .dump)
    }
}
