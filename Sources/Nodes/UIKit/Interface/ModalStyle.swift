//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

#if canImport(UIKit) && !os(watchOS)

/**
 * Nodes' convenience modal presentation styles for [UIKit](https://developer.apple.com/documentation/uikit).
 */
@preconcurrency
@MainActor
public struct ModalStyle {

    /// The ``ModalStyle`` behavior.
    public enum Behavior {

        /// The `cover` behavior - [fullScreen](
        /// https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/fullscreen
        /// ) in UIKit.
        case cover

        /// The `overlay` behavior - [overFullScreen](
        /// https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/overFullScreen
        /// ) in UIKit.
        case overlay

        /// The `page` behavior - [pageSheet](
        /// https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/pageSheet
        /// ) in UIKit.
        @available(tvOS, unavailable)
        case page

        /// The `form` behavior - [formSheet](
        /// https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/formSheet
        /// ) in UIKit.
        @available(tvOS, unavailable)
        case form

        /// NOT INTENDED FOR USE
        case custom
    }

    /// The sheet style used to specify the ``ModalStyle`` behavior.
    @available(tvOS, unavailable)
    public enum SheetStyle {

        /// The `page` behavior - [pageSheet](
        /// https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/pageSheet
        /// ) in UIKit.
        case page

        /// The `form` behavior - [formSheet](
        /// https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/formSheet
        /// ) in UIKit.
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

    /// NOT INTENDED FOR USE
    public static func custom() -> Self {
        Self(behavior: .custom)
    }

    /// NOT INTENDED FOR USE
    public func withAdditionalConfiguration(
        configuration additionalConfiguration: @escaping (ViewControllable) -> Void
    ) -> Self {
        Self(behavior: behavior, configuration: configuration + [additionalConfiguration])
    }
}

#endif
