//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesGenerator
import XCTest

final class XcodeTemplatePermutationTests: XCTestCase, TestFactories {

    func testNodeXcodeTemplateV2Permutation() throws {
        let config: Config = givenConfig()
        config.uiFrameworks.forEach { framework in
            [true, false].forEach { usePluginList in
                let permutation: NodeXcodeTemplateV2Permutation = .init(
                    usePluginList: usePluginList,
                    for: framework,
                    config: config
                )
                assertSnapshot(
                    of: permutation,
                    as: .dump,
                    named: "\(framework.kind.rawValue)\(usePluginList ? "-UsePluginList" : "")"
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
