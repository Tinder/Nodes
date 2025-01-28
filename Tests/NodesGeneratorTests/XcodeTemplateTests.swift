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

final class XcodeTemplateTests: XCTestCase, TestFactories {

    func testNodeXcodeTemplate() throws {
        let config: Config = givenConfig()
        assertSnapshot(of: NodeXcodeTemplate(uiFrameworks: config.uiFrameworks, config: config),
                       as: .dump)
    }

    func testNodeViewInjectedXcodeTemplate() {
        assertSnapshot(of: NodeViewInjectedXcodeTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testPluginListXcodeTemplate() {
        assertSnapshot(of: PluginListXcodeTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testPluginXcodeTemplate() {
        assertSnapshot(of: PluginXcodeTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testWorkerXcodeTemplate() {
        assertSnapshot(of: WorkerXcodeTemplate(config: givenConfig()),
                       as: .dump)
    }
}
