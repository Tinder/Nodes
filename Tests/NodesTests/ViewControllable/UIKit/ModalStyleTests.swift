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

    func testCover() {

        let modalStyle: UIViewController.ModalStyle = .cover()
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior) == .cover
        expect(modalStyle.presentationStyle) == .fullScreen
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

        let modalStyle: UIViewController.ModalStyle = .overlay(controlStatusBarAppearance: true)
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior) == UIViewController.ModalStyle.Behavior.overlay
        expect(modalStyle.presentationStyle) == .overFullScreen
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

        let modalStyle: UIViewController.ModalStyle = .overlay()
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior) == UIViewController.ModalStyle.Behavior.overlay
        expect(modalStyle.presentationStyle) == .overFullScreen
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

    func testCustom() {

        let modalStyle: UIViewController.ModalStyle = .custom()
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior) == .custom
        expect(modalStyle.presentationStyle) == .custom
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

    @available(macCatalyst 13.0, iOS 13.0, *)
    @available(tvOS, unavailable)
    func testPageSheet() {

        let modalStyle: UIViewController.ModalStyle = .sheet(style: .page,
                                                             controlStatusBarAppearance: true,
                                                             allowInteractiveDismissal: true)
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior) == .page
        expect(modalStyle.presentationStyle) == .pageSheet
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

        let modalStyle: UIViewController.ModalStyle = .sheet(style: .page)
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior) == .page
        expect(modalStyle.presentationStyle) == .pageSheet
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

        let modalStyle: UIViewController.ModalStyle = .sheet(style: .form,
                                                             controlStatusBarAppearance: true,
                                                             allowInteractiveDismissal: true)
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior) == .form
        expect(modalStyle.presentationStyle) == .formSheet
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

        let modalStyle: UIViewController.ModalStyle = .sheet(style: .form)
        let viewController: UIViewController = givenViewController(with: modalStyle)

        expect(modalStyle.behavior) == .form
        expect(modalStyle.presentationStyle) == .formSheet
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

    private func givenViewController(with modalStyle: UIViewController.ModalStyle) -> UIViewController {
        let viewController: UIViewController = .init()
        expect(viewController).to(notBeNilAndToDeallocateAfterTest())
        return viewController.withModalStyle(modalStyle)
    }
}

#endif
