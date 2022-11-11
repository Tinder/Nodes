//
//  TemplatesTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Christopher Fuller on 5/31/21.
//

import SnapshotTesting
@testable import XcodeTemplateGeneratorLibrary
import XCTest

final class TemplatesTests: XCTestCase, TestFactories {

    func testNodeTemplateForAppKit() {
        assertSnapshot(matching: NodeTemplate(for: givenFramework(for: .appKit), config: givenConfig()),
                       as: .dump)
    }

    func testNodeTemplateForUIKit() {
        assertSnapshot(matching: NodeTemplate(for: givenFramework(for: .uiKit), config: givenConfig()),
                       as: .dump)
    }

    func testNodeTemplateForSwiftUI() {
        assertSnapshot(matching: NodeTemplate(for: givenFramework(for: .swiftUI), config: givenConfig()),
                       as: .dump)
    }

    func testNodeTemplateForCustomFramework() {
        assertSnapshot(matching: NodeTemplate(for: givenFramework(for: .custom), config: givenConfig()),
                       as: .dump)
    }

    func testNodeViewInjectedTemplate() {
        assertSnapshot(matching: NodeViewInjectedTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testPluginListNodeTemplate() {
        assertSnapshot(matching: PluginListNodeTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testPluginNodeTemplate() {
        assertSnapshot(matching: PluginNodeTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testPluginTemplate() {
        assertSnapshot(matching: PluginTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testWorkerTemplate() {
        assertSnapshot(matching: WorkerTemplate(config: givenConfig()),
                       as: .dump)
    }
}
