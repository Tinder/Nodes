//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesGenerator
import XCTest

final class XcodeTemplateTests: XCTestCase, TestFactories {

    func testNodeXcodeTemplateV2() throws {
        let config: Config = givenConfig()
        assertSnapshot(of: NodeXcodeTemplateV2(uiFrameworks: config.uiFrameworks, config: config),
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
