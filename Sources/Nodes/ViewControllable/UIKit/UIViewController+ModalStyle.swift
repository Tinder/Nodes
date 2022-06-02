//
//  UIViewController+ModalStyle.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

/**
 * Nodes' default modal presentation styles.
 */
public struct ModalStyle: Equatable {

    /// The behavior of the modal style.
    public enum Behavior: Equatable {

        /// The ModalStyle.Behavior which maps to UIModalPresentationStyle.fullScreen.
        case cover

        /// The ModalStyle.Behavior which maps to UIModalPresentationStyle.overFullScreen.
        case overlay

        @available(tvOS, unavailable)
        /// The ModalStyle.Behavior which maps to UIModalPresentationStyle.pageSheet.
        case page

        @available(tvOS, unavailable)
        /// The ModalStyle.Behavior which maps to UIModalPresentationStyle.formSheet.
        case form

        /// The ModalStyle.Behavior which maps to UIModalPresentationStyle.custom.
        case custom
    }

    @available(tvOS, unavailable)
    /// The sheet style used to specify the behavior of the modal style.
    public enum SheetStyle: Equatable {

        /// The ModalStyle.SheetStyle which maps to UIModalPresentationStyle.pageSheet.
        case page

        /// The ModalStyle.SheetStyle which maps to UIModalPresentationStyle.formSheet.
        case form
    }

    /// The behavior of the modal style.
    public let behavior: Behavior

    /// Specifies whether control of status bar appearance is enabled.
    public let controlStatusBarAppearance: Bool

    /// Specifies whether interactive dismissal is allowed.
    public let allowInteractiveDismissal: Bool

    /// An array of closures containing additional modal style configuration. Each closure is called with the
    /// ``ViewControllable`` instance to configure.
    public let configuration: [(ViewControllable) -> Void]

    private init(
        behavior: Behavior,
        controlStatusBarAppearance: Bool,
        allowInteractiveDismissal: Bool,
        configuration: [(ViewControllable) -> Void] = []
    ) {
        self.behavior = behavior
        self.controlStatusBarAppearance = controlStatusBarAppearance
        self.allowInteractiveDismissal = allowInteractiveDismissal
        self.configuration = configuration
    }

    /// Returns a Boolean value indicating whether two ``ModalStyle`` instances are equal.
    ///
    /// - Parameters:
    ///   - lhs: The ModalStyle instance to compare.
    ///   - rhs: The ModalStyle instance to compare.
    ///
    /// - Returns: Whether the behavior of `lhs` is equal to the behavior of `rhs`.
    public static func == (lhs: ModalStyle, rhs: ModalStyle) -> Bool {
        lhs.behavior == rhs.behavior
    }

    /// A factory method that creates a ``ModalStyle`` with cover behavior.
    ///
    /// Covers the screen and removes the presenting view controller's views after
    /// the presentation completes. Presentation of a full screen view is expected
    /// since uncovered underlying content will disappear.
    ///
    /// - Returns: A ``ModalStyle`` instance with `behavior` set to `.cover`, `controlStatusBarAppearance` set to
    ///   `true` and `allowInteractiveDismissal` set to `false`.
    public static func cover() -> ModalStyle {
        ModalStyle(behavior: .cover,
                   controlStatusBarAppearance: true,
                   allowInteractiveDismissal: false)
    }

    /// A factory method that creates a ``ModalStyle`` with overlay behavior.
    ///
    /// Overlays the presenting view controller which remains visible.
    /// All content not covered by the presented view controller will also be visible.
    ///
    /// - Parameter controlStatusBarAppearance: A Boolean value specifying whether the presented view controller
    ///   takes over control of status bar appearance from the presenting view controller.
    ///
    /// - Returns: A ``ModalStyle`` instance with `behavior` set to `.overlay`, the given
    ///   `controlStatusBarAppearance` and `allowInteractiveDismissal` set to `false`.
    public static func overlay(
        controlStatusBarAppearance: Bool = false
    ) -> ModalStyle {
        ModalStyle(behavior: .overlay,
                   controlStatusBarAppearance: controlStatusBarAppearance,
                   allowInteractiveDismissal: false)
    }

    @available(tvOS, unavailable)
    /// A factory method that creates a ``ModalStyle`` with page or form behavior.
    ///
    /// Partially covers the presenting view controller which remains visible.
    /// All content not covered by the presented view controller will also be visible.
    ///
    /// - Parameters:
    ///   - sheetStyle: The SheetStyle used to specify page or form behavior.
    ///   - controlStatusBarAppearance: A Boolean value specifying whether the presented view controller
    ///     takes over control of status bar appearance from the presenting view controller.
    ///   - allowInteractiveDismissal: A Boolean value specifying whether the presentation allows interactive
    ///     dismissal.
    ///
    /// - Returns: A ``ModalStyle`` instance with `behavior` set to the given `sheetStyle`, the given
    ///   `controlStatusBarAppearance` and the given `allowInteractiveDismissal`.
    public static func sheet(
        style sheetStyle: SheetStyle = .page,
        controlStatusBarAppearance: Bool = false,
        allowInteractiveDismissal: Bool = false
    ) -> ModalStyle {
        let behavior: Behavior
        switch sheetStyle {
        case .page:
            behavior = .page
        case .form:
            behavior = .form
        }
        return ModalStyle(behavior: behavior,
                          controlStatusBarAppearance: controlStatusBarAppearance,
                          allowInteractiveDismissal: allowInteractiveDismissal)
    }

    /// A factory method that creates a ``ModalStyle`` with custom behavior.
    ///
    /// Custom presentation controlled by ``UIViewControllerTransitioningDelegate``
    /// and ``UIViewControllerAnimatedTransitioning`` object(s).
    ///
    /// - Parameter controlStatusBarAppearance: A Boolean value specifying whether the presented view controller
    ///   takes over control of status bar appearance from the presenting view controller.
    ///
    /// - Returns: A ``ModalStyle`` instance with `behavior` set to `.custom`, the given
    ///   `controlStatusBarAppearance` and `allowInteractiveDismissal` set to `false`.
    public static func custom(
        controlStatusBarAppearance: Bool = false
    ) -> ModalStyle {
        ModalStyle(behavior: .custom,
                   controlStatusBarAppearance: controlStatusBarAppearance,
                   allowInteractiveDismissal: false)
    }

    /// DEPRECATED - DO NOT USE
    public func _withAdditionalConfiguration( // swiftlint:disable:this identifier_name
        configuration additionalConfiguration: @escaping (ViewControllable) -> Void
    ) -> ModalStyle {
        ModalStyle(behavior: behavior,
                   controlStatusBarAppearance: controlStatusBarAppearance,
                   allowInteractiveDismissal: allowInteractiveDismissal,
                   configuration: configuration + [additionalConfiguration])
    }
}

extension UIViewController {

    /// Applies the given ``ModalStyle``.
    ///
    /// - Parameter modalStyle: The `ModalStyle` to apply.
    ///
    /// - Returns: The `self` instance with the given ``ModalStyle`` applied.
    @discardableResult
    public func withModalStyle(_ modalStyle: ModalStyle) -> Self {
        switch modalStyle.behavior {
        case .cover:
            modalPresentationStyle = .fullScreen
        case .overlay:
            modalPresentationStyle = .overFullScreen
        #if !os(tvOS)
        case .page:
            modalPresentationStyle = .pageSheet
        case .form:
            modalPresentationStyle = .formSheet
        #endif
        case .custom:
            modalPresentationStyle = .custom
        }
        #if !os(tvOS)
        modalPresentationCapturesStatusBarAppearance = modalStyle.controlStatusBarAppearance
        #endif
        if #available(iOS 13.0, tvOS 13.0, *) {
            isModalInPresentation = !modalStyle.allowInteractiveDismissal
        }
        modalStyle.configuration.forEach { $0(self) }
        return self
    }
}

#endif
