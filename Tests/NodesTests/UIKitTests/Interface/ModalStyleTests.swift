//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

#if canImport(UIKit)

import Nimble
import Nodes
import UIKit
import XCTest

final class ModalStyleTests: XCTestCase {

    @MainActor
    func testCover() {
        let modalStyle: ModalStyle = .cover()
        expect(modalStyle.behavior) == .cover
    }

    @MainActor
    func testOverlay() {
        let modalStyle: ModalStyle = .overlay()
        expect(modalStyle.behavior) == .overlay
    }

    @MainActor
    func testPageSheet() {
        let modalStyle: ModalStyle = .sheet(style: .page)
        expect(modalStyle.behavior) == .page
    }

    @MainActor
    func testFormSheet() {
        let modalStyle: ModalStyle = .sheet(style: .form)
        expect(modalStyle.behavior) == .form
    }

    @MainActor
    func testCustom() {
        let modalStyle: ModalStyle = .custom()
        expect(modalStyle.behavior) == .custom
    }

    @MainActor
    func testWithAdditionalConfiguration() {
        let viewController: UIViewController = givenViewController()
        var additionalConfiguration1: [UIViewController] = []
        var additionalConfiguration2: [UIViewController] = []
        var additionalConfiguration3: [UIViewController] = []
        let modalStyle: ModalStyle = .custom()
            .withAdditionalConfiguration { additionalConfiguration1.append($0._asUIViewController()) }
            .withAdditionalConfiguration { additionalConfiguration2.append($0._asUIViewController()) }
            .withAdditionalConfiguration { additionalConfiguration3.append($0._asUIViewController()) }
        modalStyle.configuration.forEach { $0(viewController) }
        expect(additionalConfiguration1) == [viewController]
        expect(additionalConfiguration2) == [viewController]
        expect(additionalConfiguration3) == [viewController]
        modalStyle.configuration.forEach { $0(viewController) }
        expect(additionalConfiguration1.count) == 2
        expect(additionalConfiguration2.count) == 2
        expect(additionalConfiguration3.count) == 2
    }

    @MainActor
    private func givenViewController() -> UIViewController {
        let viewController: UIViewController = .init()
        expect(viewController).to(notBeNilAndToDeallocateAfterTest())
        return viewController
    }
}

#endif
