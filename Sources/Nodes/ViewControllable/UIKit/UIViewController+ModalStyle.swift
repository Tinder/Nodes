//
//  Copyright © 2020 Tinder (Match Group, LLC)
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

/**
 * Nodes' convenience modal presentation styles for [UIKit](https://developer.apple.com/documentation/uikit).
 */
@preconcurrency
@MainActor
public struct ModalStyle {

    /// The ``ModalStyle`` behavior.
    public enum Behavior {

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
    public enum SheetStyle {

        /// The ``UIModalPresentationStyle.pageSheet`` behavior.
        case page

        /// The ``UIModalPresentationStyle.formSheet`` behavior.
        case form
    }

    /// The ``ModalStyle`` behavior.
    public let behavior: Behavior

    /// An array of closures containing additional modal style configuration. Each closure is called with the
    /// ``ViewControllable`` instance to configure.
    public let configuration: [(ViewControllable) -> Void]

    private init(
        behavior: Behavior,
        configuration: [(ViewControllable) -> Void] = []
    ) {
        self.behavior = behavior
        self.configuration = configuration
    }

    /// A factory method that creates a ``ModalStyle`` with cover behavior.
    ///
    /// Covers the screen and removes the presenting view controller's views after
    /// the presentation completes. Presentation of a full screen view is expected
    /// since uncovered underlying content will disappear.
    ///
    /// - Returns: A ``ModalStyle`` instance with `behavior` set to `.cover`.
    public static func cover() -> Self {
        Self(behavior: .cover)
    }

    /// A factory method that creates a ``ModalStyle`` with overlay behavior.
    ///
    /// Overlays the presenting view controller which remains visible.
    /// All content not covered by the presented view controller will also be visible.
    ///
    /// - Returns: A ``ModalStyle`` instance with `behavior` set to `.overlay`.
    public static func overlay() -> Self {
        Self(behavior: .overlay)
    }

    /// A factory method that creates a ``ModalStyle`` with page or form behavior.
    ///
    /// Partially covers the presenting view controller which remains visible.
    /// All content not covered by the presented view controller will also be visible.
    ///
    /// - Parameter sheetStyle: The SheetStyle used to specify page or form behavior.
    ///
    /// - Returns: A ``ModalStyle`` instance with `behavior` set to the given `sheetStyle`.
    @available(tvOS, unavailable)
    public static func sheet(
        style sheetStyle: SheetStyle = .page
    ) -> Self {
        let behavior: Behavior
        switch sheetStyle {
        case .page:
            behavior = .page
        case .form:
            behavior = .form
        }
        return Self(behavior: behavior)
    }

    /// A factory method that creates a ``ModalStyle`` with custom behavior.
    ///
    /// Custom presentation controlled by ``UIViewControllerTransitioningDelegate``
    /// and ``UIViewControllerAnimatedTransitioning`` object(s).
    ///
    /// - Returns: A ``ModalStyle`` instance with `behavior` set to `.custom`.
    public static func custom() -> Self {
        Self(behavior: .custom)
    }

    // swiftlint:disable identifier_name

    /// DEPRECATED - DO NOT USE
    public func _withAdditionalConfiguration(
        configuration additionalConfiguration: @escaping (ViewControllable) -> Void
    ) -> Self {
        Self(behavior: behavior, configuration: configuration + [additionalConfiguration])
    }

    // swiftlint:enable identifier_name
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
        if #available(iOS 13.0, tvOS 13.0, *) {
            isModalInPresentation = true
        }
        modalStyle.configuration.forEach { $0(self) }
        return self
    }
}

#endif
