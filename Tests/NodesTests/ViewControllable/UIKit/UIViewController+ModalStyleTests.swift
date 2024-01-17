// swiftlint:disable:this file_name
//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

#if canImport(UIKit)

import Nimble
import Nodes
import UIKit
import XCTest

@MainActor
final class UIViewControllerModalStyleTests: XCTestCase {

    func testCover() {

        let modalStyle: ModalStyle = .cover()
        expect(modalStyle.behavior) == .cover

        let viewController: UIViewController = givenViewController(with: modalStyle)
        expect(viewController.modalPresentationStyle) == .fullScreen

        if #available(iOS 13.0, tvOS 13.0, *) {
            expect(viewController.isModalInPresentation) == true
        }
    }

    func testOverlayWithDefaults() {

        let modalStyle: ModalStyle = .overlay()
        expect(modalStyle.behavior) == ModalStyle.Behavior.overlay

        let viewController: UIViewController = givenViewController(with: modalStyle)
        expect(viewController.modalPresentationStyle) == .overFullScreen

        if #available(iOS 13.0, tvOS 13.0, *) {
            expect(viewController.isModalInPresentation) == true
        }
    }

    @available(iOS 13.0, *)
    @available(tvOS, unavailable)
    func testPageSheet() {

        let modalStyle: ModalStyle = .sheet(style: .page)
        expect(modalStyle.behavior) == .page

        let viewController: UIViewController = givenViewController(with: modalStyle)
        expect(viewController.modalPresentationStyle) == .pageSheet
        expect(viewController.isModalInPresentation) == true
    }

    @available(iOS 13.0, *)
    @available(tvOS, unavailable)
    func testFormSheet() {

        let modalStyle: ModalStyle = .sheet(style: .form)
        expect(modalStyle.behavior) == .form

        let viewController: UIViewController = givenViewController(with: modalStyle)
        expect(viewController.modalPresentationStyle) == .formSheet
        expect(viewController.isModalInPresentation) == true
    }

    func testCustom() {

        let modalStyle: ModalStyle = .custom()
        expect(modalStyle.behavior) == .custom

        let viewController: UIViewController = givenViewController(with: modalStyle)
        expect(viewController.modalPresentationStyle) == .custom

        if #available(iOS 13.0, tvOS 13.0, *) {
            expect(viewController.isModalInPresentation) == true
        }
    }

    func testAdditionalConfiguration() {
        var additionalConfiguration1: [UIViewController] = []
        var additionalConfiguration2: [UIViewController] = []
        var additionalConfiguration3: [UIViewController] = []
        let modalStyle: ModalStyle = .cover()
            .withAdditionalConfiguration { additionalConfiguration1.append($0._asUIViewController()) }
            .withAdditionalConfiguration { additionalConfiguration2.append($0._asUIViewController()) }
            .withAdditionalConfiguration { additionalConfiguration3.append($0._asUIViewController()) }
        let viewController: UIViewController = givenViewController(with: modalStyle)
        expect(additionalConfiguration1) == [viewController]
        expect(additionalConfiguration2) == [viewController]
        expect(additionalConfiguration3) == [viewController]
        _ = givenViewController(with: modalStyle)
        expect(additionalConfiguration1.count) == 2
        expect(additionalConfiguration2.count) == 2
        expect(additionalConfiguration3.count) == 2
    }

    private func givenViewController(with modalStyle: ModalStyle) -> UIViewController {
        let viewController: UIViewController = .init()
        expect(viewController).to(notBeNilAndToDeallocateAfterTest())
        return viewController.withModalStyle(modalStyle)
    }
}

#endif
