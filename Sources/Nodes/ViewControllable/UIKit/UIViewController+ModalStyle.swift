//
//  UIViewController+ModalStyle.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

extension UIViewController {

    public struct ModalStyle {

        @available(macCatalyst 13.0, iOS 13.0, *)
        @available(tvOS, unavailable)
        // swiftlint:disable:next nesting
        public enum SheetStyle {

            case page, form

            // swiftlint:disable:next strict_fileprivate
            fileprivate var presentationStyle: UIModalPresentationStyle {
                switch self {
                case .page:
                    return .pageSheet
                case .form:
                    return .formSheet
                }
            }
        }

        // swiftlint:disable:next nesting
        public enum Behavior: Equatable {

            @available(macCatalyst 13.0, iOS 13.0, *)
            @available(tvOS, unavailable)
            case sheet(SheetStyle)

            case overlay, cover, custom
        }

        /// Partially cover the screen with or without interactive dismissal.
        @available(macCatalyst 13.0, iOS 13.0, *)
        @available(tvOS, unavailable)
        public static func sheet(
            style: SheetStyle = .page,
            isInteractiveDismissalEnabled: Bool = false,
            capturesStatusBarAppearance: Bool = false,
            adaptivePresentationDelegate: UIAdaptivePresentationControllerDelegate? = nil
        ) -> ModalStyle {
            ModalStyle(behavior: .sheet(style),
                       presentationStyle: style.presentationStyle,
                       isInteractiveDismissalEnabled: isInteractiveDismissalEnabled,
                       transitioningDelegate: nil,
                       capturesStatusBarAppearance: capturesStatusBarAppearance,
                       adaptivePresentationDelegate: adaptivePresentationDelegate)
        }

        /// Overlay the screen and keep the presenting view controller's views on screen.
        /// Uncovered underlying content will be visible.
        public static func overlay(
            capturesStatusBarAppearance: Bool = false
        ) -> ModalStyle {
            ModalStyle(behavior: .overlay,
                       presentationStyle: .overFullScreen,
                       isInteractiveDismissalEnabled: false,
                       transitioningDelegate: nil,
                       capturesStatusBarAppearance: capturesStatusBarAppearance,
                       adaptivePresentationDelegate: nil)
        }

        /// Cover the screen and remove the presenting view controller's views after
        /// the presentation completes. Presentation of a full screen view is expected
        /// since uncovered underlying content will disappear.
        ///
        /// When a `delegate` is provided, custom presentation will then be controlled by
        /// `UIViewControllerTransitioningDelegate` and `UIViewControllerAnimatedTransitioning`
        /// object(s). This style enables access to the `from` and `to` `UIView` instances
        /// during both presentation and dismissal.
        public static func cover(
            delegate: UIViewControllerTransitioningDelegate? = nil
        ) -> ModalStyle {
            ModalStyle(behavior: .cover,
                       presentationStyle: .fullScreen,
                       isInteractiveDismissalEnabled: false,
                       transitioningDelegate: delegate,
                       capturesStatusBarAppearance: false,
                       adaptivePresentationDelegate: nil)
        }

        /// Custom presentation controlled by `UIViewControllerTransitioningDelegate`
        /// and `UIViewControllerAnimatedTransitioning` object(s).
        ///
        /// The `UIView` instance accessed via `transitionContext.view(forKey: .from)`
        /// will be `nil` during presentation.
        ///
        /// The `UIView` instance accessed via `transitionContext.view(forKey: .to)`
        /// will be `nil` during dismissal.
        public static func custom(
            delegate: UIViewControllerTransitioningDelegate,
            capturesStatusBarAppearance: Bool = false
        ) -> ModalStyle {
            ModalStyle(behavior: .custom,
                       presentationStyle: .custom,
                       isInteractiveDismissalEnabled: false,
                       transitioningDelegate: delegate,
                       capturesStatusBarAppearance: capturesStatusBarAppearance,
                       adaptivePresentationDelegate: nil)
        }

        public let behavior: Behavior

        public let presentationStyle: UIModalPresentationStyle

        public let isInteractiveDismissalEnabled: Bool

        // swiftlint:disable:next weak_delegate
        public let transitioningDelegate: UIViewControllerTransitioningDelegate?

        public let capturesStatusBarAppearance: Bool

        // swiftlint:disable:next weak_delegate
        public let adaptivePresentationDelegate: UIAdaptivePresentationControllerDelegate?

        private init(
            behavior: Behavior,
            presentationStyle: UIModalPresentationStyle,
            isInteractiveDismissalEnabled: Bool,
            transitioningDelegate: UIViewControllerTransitioningDelegate?,
            capturesStatusBarAppearance: Bool,
            adaptivePresentationDelegate: UIAdaptivePresentationControllerDelegate?
        ) {
            self.behavior = behavior
            self.presentationStyle = presentationStyle
            self.isInteractiveDismissalEnabled = isInteractiveDismissalEnabled
            self.transitioningDelegate = transitioningDelegate
            self.capturesStatusBarAppearance = capturesStatusBarAppearance
            self.adaptivePresentationDelegate = adaptivePresentationDelegate
        }

        public func behavior(is behavior: Behavior) -> Bool {
            self.behavior == behavior
        }
    }

    @discardableResult
    public func withModalStyle(_ modalStyle: ModalStyle) -> Self {
        modalPresentationStyle = modalStyle.presentationStyle
        if #available(macCatalyst 13.0, iOS 13.0, tvOS 13.0, *) {
            isModalInPresentation = !modalStyle.isInteractiveDismissalEnabled
        }
        transitioningDelegate = modalStyle.transitioningDelegate
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            modalPresentationCapturesStatusBarAppearance = modalStyle.capturesStatusBarAppearance
            #endif
        }
        // swiftlint:disable:next explicit_type_interface
        if let adaptivePresentationDelegate = modalStyle.adaptivePresentationDelegate {
            presentationController?.delegate = adaptivePresentationDelegate
        }
        return self
    }
}

#endif
