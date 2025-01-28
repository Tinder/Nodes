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

final class XcodeTemplatePermutationTests: XCTestCase, TestFactories {

    func testNodeXcodeTemplatePermutation() throws {
        let config: Config = givenConfig()
        config.uiFrameworks.forEach { framework in
            [true, false].forEach { createdForPluginList in
                let permutation: NodeXcodeTemplatePermutation = .init(
                    for: framework,
                    createdForPluginList: createdForPluginList,
                    config: config
                )
                assertSnapshot(
                    of: permutation,
                    as: .dump,
                    named: permutation.name
                )
            }
        }
    }

    func testNodeViewInjectedXcodeTemplatePermutation() throws {
        let permutation: NodeViewInjectedXcodeTemplatePermutation = .init(name: "<name>", config: givenConfig())
        assertSnapshot(of: permutation, as: .dump)
    }

    func testPluginListXcodeTemplatePermutation() throws {
        let permutation: PluginListXcodeTemplatePermutation = .init(name: "<name>", config: givenConfig())
        assertSnapshot(of: permutation, as: .dump)
    }

    func testPluginXcodeTemplatePermutation() {
        let permutation: PluginXcodeTemplatePermutation = .init(name: "<name>", config: givenConfig())
        assertSnapshot(of: permutation, as: .dump)
    }

    func testWorkerXcodeTemplatePermutation() {
        let permutation: WorkerXcodeTemplatePermutation = .init(name: "<name>", config: givenConfig())
        assertSnapshot(of: permutation, as: .dump)
    }
}
