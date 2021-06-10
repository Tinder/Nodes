//
//  AbstractViewHostingController.swift
//  Nodes
//
//  Created by Christopher Fuller on 5/11/21.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol NodesView: View {

    associatedtype ReceiverType

    var receiver: ReceiverType { get set }
}

@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol NodesViewHostingController {

    associatedtype ContentType: NodesView

    var rootView: ContentType { get }
}

#if canImport(UIKit) && !os(watchOS)

@available(macCatalyst 13.0, iOS 13.0, tvOS 13.0, *)
open class AbstractViewHostingController<View: NodesView>: UIHostingController<View>, NodesViewHostingController {

    public var receiver: View.ReceiverType {
        get { rootView.receiver }
        set { rootView.receiver = newValue }
    }
}

#endif
