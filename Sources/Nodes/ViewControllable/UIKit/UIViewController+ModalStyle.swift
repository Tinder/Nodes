//
//  Copyright © 2020 Tinder (Match Group, LLC)
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

/**
 * Nodes' convenience modal presentation styles for [UIKit](https://developer.apple.com/documentation/uikit).
 */
@MainActor
public struct ModalStyle: Equatable {

    /// The ``ModalStyle`` behavior.
    public enum Behavior: Equatable {

        /// The ``UIModalPresentationStyle.fullScreen`` behavior.
        case cover

        /// The ``UIModalPresentationStyle.overFullScreen`` behavior.
        case overlay

        @available(tvOS, unavailable)
        /// The ``UIModalPresentationStyle.pageSheet`` behavior.
        case page

        @available(tvOS, unavailable)
        /// The ``UIModalPresentationStyle.formSheet`` behavior.
        case form

        /// The ``UIModalPresentationStyle.custom`` behavior.
        case custom
    }

    /// The sheet style used to specify the ``ModalStyle`` behavior.
    @available(tvOS, unavailable)
    public enum SheetStyle: Equatable {

        /// The ``UIModalPresentationStyle.pageSheet`` behavior.
        case page

        /// The ``UIModalPresentationStyle.formSheet`` behavior.
        case form
    }

    /// The ``ModalStyle`` behavior.
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
    ///   - lhs: The ``ModalStyle`` instance to compare.
    ///   - rhs: The ``ModalStyle`` instance to compare.
    ///
    /// - Returns: Whether the behavior of `lhs` is equal to the behavior of `rhs`.
    public static func == (lhs: Self, rhs: Self) -> Bool {
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
    public static func cover() -> Self {
        Self(behavior: .cover,
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
    ) -> Self {
        Self(behavior: .overlay,
             controlStatusBarAppearance: controlStatusBarAppearance,
             allowInteractiveDismissal: false)
    }

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
    @available(tvOS, unavailable)
    public static func sheet(
        style sheetStyle: SheetStyle = .page,
        controlStatusBarAppearance: Bool = false,
        allowInteractiveDismissal: Bool = false
    ) -> Self {
        let behavior: Behavior
        switch sheetStyle {
        case .page:
            behavior = .page
        case .form:
            behavior = .form
        }
        return Self(behavior: behavior,
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
    ) -> Self {
        Self(behavior: .custom,
             controlStatusBarAppearance: controlStatusBarAppearance,
             allowInteractiveDismissal: false)
    }

    /// DEPRECATED - DO NOT USE
    public func _withAdditionalConfiguration( // swiftlint:disable:this identifier_name
        configuration additionalConfiguration: @escaping (ViewControllable) -> Void
    ) -> Self {
        Self(behavior: behavior,
             controlStatusBarAppearance: controlStatusBarAppearance,
             allowInteractiveDismissal: allowInteractiveDismissal,
             configuration: configuration + [additionalConfiguration])
    }
}

extension UIViewController {

    /// Applies the given ``ModalStyle``.
    ///
    /// - Parameter modalStyle: The ``ModalStyle`` to apply.
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
