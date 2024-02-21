//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesGenerator
import XCTest

final class XcodeTemplateTests: XCTestCase, TestFactories {

    func testNodeXcodeTemplate() throws {
        try UIFramework.Kind.allCases.forEach { kind in
            try assertSnapshot(of: NodeXcodeTemplate(for: kind, config: givenConfig()),
                               as: .dump,
                               named: kind.rawValue)
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
        let frameworks: [UIFramework] = try UIFramework.Kind
            .allCases
            .map { try config.uiFramework(for: $0) }
        assertSnapshot(of: NodeXcodeTemplateV2(uiFrameworks: frameworks, config: config), as: .dump)
    }

    func testWorkerXcodeTemplate() {
        assertSnapshot(of: WorkerXcodeTemplate(config: givenConfig()),
                       as: .dump)
    }
}
