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
        mockCounts.forEach { count in
            let config: Config = givenConfig(mockCount: count)
            assertSnapshot(of: NodeXcodeTemplate(uiFrameworks: config.uiFrameworks, config: config),
                           as: .dump)
        }
    }

    func testNodeViewInjectedXcodeTemplate() {
        mockCounts.forEach { count in
            assertSnapshot(of: NodeViewInjectedXcodeTemplate(config: givenConfig(mockCount: count)),
                           as: .dump)
        }
    }

    func testPluginListXcodeTemplate() {
        mockCounts.forEach { count in
            assertSnapshot(of: PluginListXcodeTemplate(config: givenConfig(mockCount: count)),
                           as: .dump)
        }
    }

    func testPluginXcodeTemplate() {
        mockCounts.forEach { count in
            assertSnapshot(of: PluginXcodeTemplate(config: givenConfig(mockCount: count)),
                           as: .dump)
        }
    }

    func testWorkerXcodeTemplate() {
        mockCounts.forEach { count in
            assertSnapshot(of: WorkerXcodeTemplate(config: givenConfig(mockCount: count)),
                           as: .dump)
        }
    }
}
