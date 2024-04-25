//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesGenerator
import XCTest

final class XcodeTemplatePermutationTests: XCTestCase, TestFactories {

    func testNodeXcodeTemplatePermutation() throws {
        let customKind: UIFramework.Kind = .custom
        let forPluginListString: String = XcodeTemplateConstants.createdForPluginList
        let config: Config = givenConfig()
        config.uiFrameworks.forEach { framework in
            [true, false].forEach { forPluginList in
                let permutation: NodeXcodeTemplatePermutation = .init(
                    for: framework,
                    createdForPluginList: forPluginList,
                    config: config
                )
                let customName: String = "\(customKind.rawValue)\(forPluginList ? forPluginListString : "")"
                assertSnapshot(
                    of: permutation,
                    as: .dump,
                    named: framework.kind == customKind ? customName : permutation.name
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
