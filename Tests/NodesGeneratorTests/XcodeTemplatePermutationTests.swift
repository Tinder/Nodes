//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesGenerator
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
                    named: permutation.name.replacingOccurrences(of: "uiFrameworkName", with: "Custom")
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
