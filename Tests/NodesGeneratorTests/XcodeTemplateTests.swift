//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesGenerator
import XCTest

final class XcodeTemplateTests: XCTestCase, TestFactories {

    func testNodeXcodeTemplate() throws {
        let config: Config = givenConfig()
        config.uiFrameworks.forEach { framework in
            assertSnapshot(of: NodeXcodeTemplate(for: framework, config: config),
                           as: .dump,
                           named: framework.kind.rawValue)
        }
    }

    func testNodeViewInjectedXcodeTemplate() {
        assertSnapshot(of: NodeViewInjectedXcodeTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testPluginListNodeXcodeTemplate() {
        assertSnapshot(of: PluginListNodeXcodeTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testPluginNodeXcodeTemplate() {
        assertSnapshot(of: PluginNodeXcodeTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testPluginXcodeTemplate() {
        assertSnapshot(of: PluginXcodeTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testNodeXcodeTemplateV2() throws {
        let config: Config = givenConfig()
        assertSnapshot(of: NodeXcodeTemplateV2(uiFrameworks: config.uiFrameworks, config: config),
                       as: .dump)
    }

    func testWorkerXcodeTemplate() {
        assertSnapshot(of: WorkerXcodeTemplate(config: givenConfig()),
                       as: .dump)
    }
}
