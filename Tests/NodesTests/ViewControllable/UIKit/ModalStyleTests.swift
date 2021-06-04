//
//  ModalStyleTests.swift
//  NodeTests
//
//  Created by Christopher Fuller on 5/4/21.
//

#if canImport(UIKit)

import Nimble
@testable import Nodes
import UIKit
import XCTest

final class ModalStyleTests: XCTestCase {

    private class DelegateMock: NSObject,
                                UIAdaptivePresentationControllerDelegate,
                                UIViewControllerTransitioningDelegate {}

    @available(macCatalyst 13.0, iOS 13.0, *)
    @available(tvOS, unavailable)
    func testPageSheet() {

        let delegate: DelegateMock = .init()

        expect(delegate).to(notBeNilAndToDeallocateAfterTest())

        let modalStyle: UIViewController.ModalStyle = .sheet(isInteractiveDismissalEnabled: true,
                                                             capturesStatusBarAppearance: true,
                                                             adaptivePresentationDelegate: delegate)
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior(is: .sheet(.page))) == true
        expect(modalStyle.presentationStyle) == .pageSheet
        expect(modalStyle.isInteractiveDismissalEnabled) == true
        expect(modalStyle.transitioningDelegate).to(beNil())
        expect(modalStyle.capturesStatusBarAppearance) == true
        expect(modalStyle.adaptivePresentationDelegate) === delegate

        expect(viewController.modalPresentationStyle) == .pageSheet
        expect(viewController.isModalInPresentation) == false
        expect(viewController.transitioningDelegate).to(beNil())
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            expect(viewController.modalPresentationCapturesStatusBarAppearance) == true
            #endif
        }
        expect(viewController.presentationController?.delegate) === delegate
        breakRetainCycle(viewController)
    }

    @available(macCatalyst 13.0, iOS 13.0, *)
    @available(tvOS, unavailable)
    func testPageSheetWithDefaults() {

        let modalStyle: UIViewController.ModalStyle = .sheet()
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior(is: .sheet(.page))) == true
        expect(modalStyle.presentationStyle) == .pageSheet
        expect(modalStyle.isInteractiveDismissalEnabled) == false
        expect(modalStyle.transitioningDelegate).to(beNil())
        expect(modalStyle.capturesStatusBarAppearance) == false
        expect(modalStyle.adaptivePresentationDelegate).to(beNil())

        expect(viewController.modalPresentationStyle) == .pageSheet
        expect(viewController.isModalInPresentation) == true
        expect(viewController.transitioningDelegate).to(beNil())
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            expect(viewController.modalPresentationCapturesStatusBarAppearance) == false
            #endif
        }
        expect(viewController.presentationController?.delegate).to(beNil())
        breakRetainCycle(viewController)
    }

    @available(macCatalyst 13.0, iOS 13.0, *)
    @available(tvOS, unavailable)
    func testFormSheet() {

        let delegate: DelegateMock = .init()

        expect(delegate).to(notBeNilAndToDeallocateAfterTest())

        let modalStyle: UIViewController.ModalStyle = .sheet(style: .form,
                                                             isInteractiveDismissalEnabled: true,
                                                             capturesStatusBarAppearance: true,
                                                             adaptivePresentationDelegate: delegate)
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior(is: .sheet(.form))) == true
        expect(modalStyle.presentationStyle) == .formSheet
        expect(modalStyle.isInteractiveDismissalEnabled) == true
        expect(modalStyle.transitioningDelegate).to(beNil())
        expect(modalStyle.capturesStatusBarAppearance) == true
        expect(modalStyle.adaptivePresentationDelegate) === delegate

        expect(viewController.modalPresentationStyle) == .formSheet
        expect(viewController.isModalInPresentation) == false
        expect(viewController.transitioningDelegate).to(beNil())
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            expect(viewController.modalPresentationCapturesStatusBarAppearance) == true
            #endif
        }
        expect(viewController.presentationController?.delegate) === delegate
        breakRetainCycle(viewController)
    }

    @available(macCatalyst 13.0, iOS 13.0, *)
    @available(tvOS, unavailable)
    func testFormSheetWithDefaults() {

        let modalStyle: UIViewController.ModalStyle = .sheet(style: .form)
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior(is: .sheet(.form))) == true
        expect(modalStyle.presentationStyle) == .formSheet
        expect(modalStyle.isInteractiveDismissalEnabled) == false
        expect(modalStyle.transitioningDelegate).to(beNil())
        expect(modalStyle.capturesStatusBarAppearance) == false
        expect(modalStyle.adaptivePresentationDelegate).to(beNil())

        expect(viewController.modalPresentationStyle) == .formSheet
        expect(viewController.isModalInPresentation) == true
        expect(viewController.transitioningDelegate).to(beNil())
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            expect(viewController.modalPresentationCapturesStatusBarAppearance) == false
            #endif
        }
        expect(viewController.presentationController?.delegate).to(beNil())
        breakRetainCycle(viewController)
    }

    func testOverlay() {

        let modalStyle: UIViewController.ModalStyle = .overlay(capturesStatusBarAppearance: true)
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior(is: .overlay)) == true
        expect(modalStyle.presentationStyle) == .overFullScreen
        expect(modalStyle.isInteractiveDismissalEnabled) == false
        expect(modalStyle.transitioningDelegate).to(beNil())
        expect(modalStyle.capturesStatusBarAppearance) == true
        expect(modalStyle.adaptivePresentationDelegate).to(beNil())

        expect(viewController.modalPresentationStyle) == .overFullScreen
        if #available(macCatalyst 13.0, iOS 13.0, tvOS 13.0, *) {
            expect(viewController.isModalInPresentation) == true
        }
        expect(viewController.transitioningDelegate).to(beNil())
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            expect(viewController.modalPresentationCapturesStatusBarAppearance) == true
            #endif
        }
        expect(viewController.presentationController?.delegate).to(beNil())
        breakRetainCycle(viewController)
    }

    func testOverlayWithDefaults() {

        let modalStyle: UIViewController.ModalStyle = .overlay()
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior(is: .overlay)) == true
        expect(modalStyle.presentationStyle) == .overFullScreen
        expect(modalStyle.isInteractiveDismissalEnabled) == false
        expect(modalStyle.transitioningDelegate).to(beNil())
        expect(modalStyle.capturesStatusBarAppearance) == false
        expect(modalStyle.adaptivePresentationDelegate).to(beNil())

        expect(viewController.modalPresentationStyle) == .overFullScreen
        if #available(macCatalyst 13.0, iOS 13.0, tvOS 13.0, *) {
            expect(viewController.isModalInPresentation) == true
        }
        expect(viewController.transitioningDelegate).to(beNil())
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            expect(viewController.modalPresentationCapturesStatusBarAppearance) == false
            #endif
        }
        expect(viewController.presentationController?.delegate).to(beNil())
        breakRetainCycle(viewController)
    }

    func testCover() {

        let delegate: DelegateMock = .init()

        expect(delegate).to(notBeNilAndToDeallocateAfterTest())

        let modalStyle: UIViewController.ModalStyle = .cover(delegate: delegate)
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior(is: .cover)) == true
        expect(modalStyle.presentationStyle) == .fullScreen
        expect(modalStyle.isInteractiveDismissalEnabled) == false
        expect(modalStyle.transitioningDelegate) === delegate
        expect(modalStyle.capturesStatusBarAppearance) == false
        expect(modalStyle.adaptivePresentationDelegate).to(beNil())

        expect(viewController.modalPresentationStyle) == .fullScreen
        if #available(macCatalyst 13.0, iOS 13.0, tvOS 13.0, *) {
            expect(viewController.isModalInPresentation) == true
        }
        expect(viewController.transitioningDelegate) === delegate
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            expect(viewController.modalPresentationCapturesStatusBarAppearance) == false
            #endif
        }
        expect(viewController.presentationController?.delegate).to(beNil())
        breakRetainCycle(viewController)
    }

    func testCoverWithDefaults() {

        let modalStyle: UIViewController.ModalStyle = .cover()
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior(is: .cover)) == true
        expect(modalStyle.presentationStyle) == .fullScreen
        expect(modalStyle.isInteractiveDismissalEnabled) == false
        expect(modalStyle.transitioningDelegate).to(beNil())
        expect(modalStyle.capturesStatusBarAppearance) == false
        expect(modalStyle.adaptivePresentationDelegate).to(beNil())

        expect(viewController.modalPresentationStyle) == .fullScreen
        if #available(macCatalyst 13.0, iOS 13.0, tvOS 13.0, *) {
            expect(viewController.isModalInPresentation) == true
        }
        expect(viewController.transitioningDelegate).to(beNil())
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            expect(viewController.modalPresentationCapturesStatusBarAppearance) == false
            #endif
        }
        expect(viewController.presentationController?.delegate).to(beNil())
        breakRetainCycle(viewController)
    }

    func testCustom() {

        let delegate: DelegateMock = .init()

        expect(delegate).to(notBeNilAndToDeallocateAfterTest())

        let modalStyle: UIViewController.ModalStyle = .custom(delegate: delegate)
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior(is: .custom)) == true
        expect(modalStyle.presentationStyle) == .custom
        expect(modalStyle.isInteractiveDismissalEnabled) == false
        expect(modalStyle.transitioningDelegate) === delegate
        expect(modalStyle.capturesStatusBarAppearance) == false
        expect(modalStyle.adaptivePresentationDelegate).to(beNil())

        expect(viewController.modalPresentationStyle) == .custom
        if #available(macCatalyst 13.0, iOS 13.0, tvOS 13.0, *) {
            expect(viewController.isModalInPresentation) == true
        }
        expect(viewController.transitioningDelegate) === delegate
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            expect(viewController.modalPresentationCapturesStatusBarAppearance) == false
            #endif
        }
        expect(viewController.presentationController?.delegate).to(beNil())
    }

    private func givenViewController(with modalStyle: UIViewController.ModalStyle) -> UIViewController {
        let viewController: UIViewController = .init()
        expect(viewController).to(notBeNilAndToDeallocateAfterTest())
        return viewController.withModalStyle(modalStyle)
    }

    private func breakRetainCycle(_ viewController: UIViewController) {
        UIViewController().present(viewController, animated: false)
    }
}

#endif
