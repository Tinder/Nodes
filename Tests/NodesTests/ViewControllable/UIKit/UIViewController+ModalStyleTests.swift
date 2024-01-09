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
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior) == .cover
        expect(modalStyle.controlStatusBarAppearance) == true
        expect(modalStyle.allowInteractiveDismissal) == false

        expect(viewController.modalPresentationStyle) == .fullScreen
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            expect(viewController.modalPresentationCapturesStatusBarAppearance) == true
            #endif
        }
        if #available(macCatalyst 13.0, iOS 13.0, tvOS 13.0, *) {
            expect(viewController.isModalInPresentation) == true
        }
    }

    func testOverlay() {

        let modalStyle: ModalStyle = .overlay(controlStatusBarAppearance: true)
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior) == ModalStyle.Behavior.overlay
        expect(modalStyle.controlStatusBarAppearance) == true
        expect(modalStyle.allowInteractiveDismissal) == false

        expect(viewController.modalPresentationStyle) == .overFullScreen
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            expect(viewController.modalPresentationCapturesStatusBarAppearance) == true
            #endif
        }
        if #available(macCatalyst 13.0, iOS 13.0, tvOS 13.0, *) {
            expect(viewController.isModalInPresentation) == true
        }
    }

    func testOverlayWithDefaults() {

        let modalStyle: ModalStyle = .overlay()
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior) == ModalStyle.Behavior.overlay
        expect(modalStyle.controlStatusBarAppearance) == false
        expect(modalStyle.allowInteractiveDismissal) == false

        expect(viewController.modalPresentationStyle) == .overFullScreen
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            expect(viewController.modalPresentationCapturesStatusBarAppearance) == false
            #endif
        }
        if #available(macCatalyst 13.0, iOS 13.0, tvOS 13.0, *) {
            expect(viewController.isModalInPresentation) == true
        }
    }

    @available(macCatalyst 13.0, iOS 13.0, *)
    @available(tvOS, unavailable)
    func testPageSheet() {

        let modalStyle: ModalStyle = .sheet(style: .page,
                                            controlStatusBarAppearance: true,
                                            allowInteractiveDismissal: true)
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior) == .page
        expect(modalStyle.controlStatusBarAppearance) == true
        expect(modalStyle.allowInteractiveDismissal) == true

        expect(viewController.modalPresentationStyle) == .pageSheet
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            expect(viewController.modalPresentationCapturesStatusBarAppearance) == true
            #endif
        }
        expect(viewController.isModalInPresentation) == false
    }

    @available(macCatalyst 13.0, iOS 13.0, *)
    @available(tvOS, unavailable)
    func testPageSheetWithDefaults() {

        let modalStyle: ModalStyle = .sheet(style: .page)
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior) == .page
        expect(modalStyle.controlStatusBarAppearance) == false
        expect(modalStyle.allowInteractiveDismissal) == false

        expect(viewController.modalPresentationStyle) == .pageSheet
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            expect(viewController.modalPresentationCapturesStatusBarAppearance) == false
            #endif
        }
        expect(viewController.isModalInPresentation) == true
    }

    @available(macCatalyst 13.0, iOS 13.0, *)
    @available(tvOS, unavailable)
    func testFormSheet() {

        let modalStyle: ModalStyle = .sheet(style: .form,
                                            controlStatusBarAppearance: true,
                                            allowInteractiveDismissal: true)
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior) == .form
        expect(modalStyle.controlStatusBarAppearance) == true
        expect(modalStyle.allowInteractiveDismissal) == true

        expect(viewController.modalPresentationStyle) == .formSheet
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            expect(viewController.modalPresentationCapturesStatusBarAppearance) == true
            #endif
        }
        expect(viewController.isModalInPresentation) == false
    }

    @available(macCatalyst 13.0, iOS 13.0, *)
    @available(tvOS, unavailable)
    func testFormSheetWithDefaults() {

        let modalStyle: ModalStyle = .sheet(style: .form)
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior) == .form
        expect(modalStyle.controlStatusBarAppearance) == false
        expect(modalStyle.allowInteractiveDismissal) == false

        expect(viewController.modalPresentationStyle) == .formSheet
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            expect(viewController.modalPresentationCapturesStatusBarAppearance) == false
            #endif
        }
        expect(viewController.isModalInPresentation) == true
    }

    func testCustom() {

        let modalStyle: ModalStyle = .custom()
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior) == .custom
        expect(modalStyle.controlStatusBarAppearance) == false
        expect(modalStyle.allowInteractiveDismissal) == false

        expect(viewController.modalPresentationStyle) == .custom
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            expect(viewController.modalPresentationCapturesStatusBarAppearance) == false
            #endif
        }
        if #available(macCatalyst 13.0, iOS 13.0, tvOS 13.0, *) {
            expect(viewController.isModalInPresentation) == true
        }
    }

    func testAdditionalConfiguration() {
        var additionalConfiguration1: [UIViewController] = []
        var additionalConfiguration2: [UIViewController] = []
        var additionalConfiguration3: [UIViewController] = []
        let modalStyle: ModalStyle = .cover()
            ._withAdditionalConfiguration { additionalConfiguration1.append($0._asUIViewController()) }
            ._withAdditionalConfiguration { additionalConfiguration2.append($0._asUIViewController()) }
            ._withAdditionalConfiguration { additionalConfiguration3.append($0._asUIViewController()) }
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
