//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

#if canImport(SwiftUI)
import SwiftUI
#endif

/**
 * Nodes' [View](https://developer.apple.com/documentation/swiftui/view) protocol for
 * [SwiftUI](https://developer.apple.com/documentation/swiftui).
 */
@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol NodesView: View {

    /// The type of the `receiver` instance.
    associatedtype ReceiverType

    /// The view's receiver instance with which to delegate user interactions.
    var receiver: ReceiverType { get set }
}

/**
 * A protocol defining a root view (compatible with
 * [UIHostingController](https://developer.apple.com/documentation/swiftui/uihostingcontroller) in
 * [SwiftUI](https://developer.apple.com/documentation/swiftui)).
 */
@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@MainActor
public protocol NodesViewHostingController {

    /// The type of the `rootView` instance which must be a ``NodesView``.
    associatedtype ContentType: NodesView

    /// The root view of the ``NodesViewHostingController`` instance.
    var rootView: ContentType { get }
}

#if canImport(UIKit) && !os(watchOS)

/**
 * Nodes' abstract
 * [UIHostingController](https://developer.apple.com/documentation/swiftui/uihostingcontroller) subclass for
 * [SwiftUI](https://developer.apple.com/documentation/swiftui).
 */
@available(macCatalyst 13.0, iOS 13.0, tvOS 13.0, *)
open class AbstractViewHostingController<View: NodesView>: UIHostingController<View>, NodesViewHostingController {

    /// A pass-through computed property to the root view's `receiver` instance.
    public var receiver: View.ReceiverType {
        get { rootView.receiver }
        set { rootView.receiver = newValue }
    }
}

#endif
