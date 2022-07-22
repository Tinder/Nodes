//
//  Created by Christopher Fuller on 2/23/21.
//  Copyright © 2021 Tinder. All rights reserved.
//

#if canImport(Combine)
import Combine
#endif
import Foundation

#if DEBUG

internal protocol NotificationPosting {

    var notification: Notification { get }
}

extension NotificationPosting {

    internal func post() {
        NotificationCenter.default.post(notification)
    }
}

public enum DebugInformation {

    public class Factory {

        private weak var object: AnyObject?

        internal init(_ object: AnyObject) {
            self.object = object
        }

        /// Use the factory's `object` instance (a view controller for example) to make
        /// an instance of another type (a view snapshot for example).
        ///
        /// Will return `nil` if the factory's weak `object` instance is `nil` or cannot
        /// be cast to type `T`.
        ///
        /// If an identity transform is provided, `nil` will be returned to prevent direct
        /// access to the factory's weak `object` itself.
        public func make<T: AnyObject, U>(_ type: T.Type, _ factory: (T) throws -> U) rethrows -> U? {
            guard let input = object as? T else { return nil }
            let output: U = try factory(input)
            guard output as AnyObject !== input else { return nil }
            return output
        }
    }

    internal class FlowWillStartNotification: NotificationPosting {

        private static let name: Notification.Name =
            .init("Nodes.\(DebugInformation.self).\(FlowWillStartNotification.self)")

        @available(iOS 13.0, OSX 10.15, *)
        fileprivate static func publisher() -> AnyPublisher<DebugInformation, Never> {
            NotificationCenter.default.publisher(for: name)
                .compactMap { $0.userInfo }
                .compactMap {
                    guard let flowIdentifier = $0["flow_identifier"] as? ObjectIdentifier,
                          let flowType = $0["flow_type"] as? Flow.Type,
                          let factory = $0["factory"] as? Factory
                    else { return nil }
                    return .flowWillStart(flowIdentifier: flowIdentifier,
                                          flowType: flowType,
                                          factory: factory)
                }
                .eraseToAnyPublisher()
        }

        internal let notification: Notification

        internal init(flow: Flow, viewController: AnyObject) {
            notification = Notification(name: Self.name, userInfo: [
                "flow_identifier": ObjectIdentifier(flow),
                "flow_type": type(of: flow),
                "factory": Factory(viewController)
            ])
        }
    }

    internal class FlowDidEndNotification: NotificationPosting {

        private static let name: Notification.Name =
            .init("Nodes.\(DebugInformation.self).\(FlowDidEndNotification.self)")

        @available(iOS 13.0, OSX 10.15, *)
        fileprivate static func publisher() -> AnyPublisher<DebugInformation, Never> {
            NotificationCenter.default.publisher(for: name)
                .compactMap { $0.userInfo }
                .compactMap {
                    guard let flowIdentifier = $0["flow_identifier"] as? ObjectIdentifier,
                          let flowType = $0["flow_type"] as? Flow.Type
                    else { return nil }
                    return .flowDidEnd(flowIdentifier: flowIdentifier,
                                       flowType: flowType)
                }
                .eraseToAnyPublisher()
        }

        internal let notification: Notification

        internal init(flow: Flow) {
            notification = Notification(name: Self.name, userInfo: [
                "flow_identifier": ObjectIdentifier(flow),
                "flow_type": type(of: flow)
            ])
        }
    }

    internal class FlowWillAttachNotification: NotificationPosting {

        private static let name: Notification.Name =
            .init("Nodes.\(DebugInformation.self).\(FlowWillAttachNotification.self)")

        @available(iOS 13.0, OSX 10.15, *)
        fileprivate static func publisher() -> AnyPublisher<DebugInformation, Never> {
            NotificationCenter.default.publisher(for: name)
                .compactMap { $0.userInfo }
                .compactMap {
                    guard let flowIdentifier = $0["flow_identifier"] as? ObjectIdentifier,
                          let flowType = $0["flow_type"] as? Flow.Type,
                          let subFlowIdentifier = $0["sub_flow_identifier"] as? ObjectIdentifier,
                          let subFlowType = $0["sub_flow_type"] as? Flow.Type
                    else { return nil }
                    return .flowWillAttachSubFlow(flowIdentifier: flowIdentifier,
                                                  flowType: flowType,
                                                  subFlowIdentifier: subFlowIdentifier,
                                                  subFlowType: subFlowType)
                }
                .eraseToAnyPublisher()
        }

        internal let notification: Notification

        internal init(flow: Flow, subFlow: Flow) {
            notification = Notification(name: Self.name, userInfo: [
                "flow_identifier": ObjectIdentifier(flow),
                "flow_type": type(of: flow),
                "sub_flow_identifier": ObjectIdentifier(subFlow),
                "sub_flow_type": type(of: subFlow)
            ])
        }
    }

    internal class FlowDidDetachNotification: NotificationPosting {

        private static let name: Notification.Name =
            .init("Nodes.\(DebugInformation.self).\(FlowDidDetachNotification.self)")

        @available(iOS 13.0, OSX 10.15, *)
        fileprivate static func publisher() -> AnyPublisher<DebugInformation, Never> {
            NotificationCenter.default.publisher(for: name)
                .compactMap { $0.userInfo }
                .compactMap {
                    guard let flowIdentifier = $0["flow_identifier"] as? ObjectIdentifier,
                          let flowType = $0["flow_type"] as? Flow.Type,
                          let subFlowIdentifier = $0["sub_flow_identifier"] as? ObjectIdentifier,
                          let subFlowType = $0["sub_flow_type"] as? Flow.Type
                    else { return nil }
                    return .flowDidDetachSubFlow(flowIdentifier: flowIdentifier,
                                                 flowType: flowType,
                                                 subFlowIdentifier: subFlowIdentifier,
                                                 subFlowType: subFlowType)
                }
                .eraseToAnyPublisher()
        }

        internal let notification: Notification

        internal init(flow: Flow, subFlow: Flow) {
            notification = Notification(name: Self.name, userInfo: [
                "flow_identifier": ObjectIdentifier(flow),
                "flow_type": type(of: flow),
                "sub_flow_identifier": ObjectIdentifier(subFlow),
                "sub_flow_type": type(of: subFlow)
            ])
        }
    }

    internal class FlowControllerWillAttachNotification: NotificationPosting {

        private static let name: Notification.Name =
            .init("Nodes.\(DebugInformation.self).\(FlowControllerWillAttachNotification.self)")

        @available(iOS 13.0, OSX 10.15, *)
        fileprivate static func publisher() -> AnyPublisher<DebugInformation, Never> {
            NotificationCenter.default.publisher(for: name)
                .compactMap { $0.userInfo }
                .compactMap {
                    guard let flowControllerIdentifier = $0["flow_controller_identifier"] as? ObjectIdentifier,
                          let flowIdentifier = $0["flow_identifier"] as? ObjectIdentifier,
                          let flowType = $0["flow_type"] as? Flow.Type
                    else { return nil }
                    return .flowControllerWillAttachFlow(flowControllerIdentifier: flowControllerIdentifier,
                                                         flowIdentifier: flowIdentifier,
                                                         flowType: flowType)
                }
                .eraseToAnyPublisher()
        }

        internal let notification: Notification

        internal init(flowController: FlowController, flow: Flow) {
            notification = Notification(name: Self.name, userInfo: [
                "flow_controller_identifier": ObjectIdentifier(flowController),
                "flow_identifier": ObjectIdentifier(flow),
                "flow_type": type(of: flow)
            ])
        }
    }

    internal class FlowControllerDidDetachNotification: NotificationPosting {

        private static let name: Notification.Name =
            .init("Nodes.\(DebugInformation.self).\(FlowControllerDidDetachNotification.self)")

        @available(iOS 13.0, OSX 10.15, *)
        fileprivate static func publisher() -> AnyPublisher<DebugInformation, Never> {
            NotificationCenter.default.publisher(for: name)
                .compactMap { $0.userInfo }
                .compactMap {
                    guard let flowControllerIdentifier = $0["flow_controller_identifier"] as? ObjectIdentifier,
                          let flowIdentifier = $0["flow_identifier"] as? ObjectIdentifier,
                          let flowType = $0["flow_type"] as? Flow.Type
                    else { return nil }
                    return .flowControllerDidDetachFlow(flowControllerIdentifier: flowControllerIdentifier,
                                                        flowIdentifier: flowIdentifier,
                                                        flowType: flowType)
                }
                .eraseToAnyPublisher()
        }

        internal let notification: Notification

        internal init(flowController: FlowController, flow: Flow) {
            notification = Notification(name: Self.name, userInfo: [
                "flow_controller_identifier": ObjectIdentifier(flowController),
                "flow_identifier": ObjectIdentifier(flow),
                "flow_type": type(of: flow)
            ])
        }
    }

    private static var queue: DispatchQueue = .init(label: "Nodes Debug Notifications",
                                                    qos: .background)

    @available(iOS 13.0, OSX 10.15, *)
    public static func publisher() -> AnyPublisher<DebugInformation, Never> {
        FlowWillStartNotification.publisher()
            .merge(with: FlowDidEndNotification.publisher())
            .merge(with: FlowWillAttachNotification.publisher())
            .merge(with: FlowDidDetachNotification.publisher())
            .merge(with: FlowControllerWillAttachNotification.publisher())
            .merge(with: FlowControllerDidDetachNotification.publisher())
            .receive(on: queue)
            .eraseToAnyPublisher()
    }

    case flowWillStart(flowIdentifier: ObjectIdentifier,
                       flowType: Flow.Type,
                       factory: Factory)

    case flowDidEnd(flowIdentifier: ObjectIdentifier,
                    flowType: Flow.Type)

    case flowWillAttachSubFlow(flowIdentifier: ObjectIdentifier,
                               flowType: Flow.Type,
                               subFlowIdentifier: ObjectIdentifier,
                               subFlowType: Flow.Type)

    case flowDidDetachSubFlow(flowIdentifier: ObjectIdentifier,
                              flowType: Flow.Type,
                              subFlowIdentifier: ObjectIdentifier,
                              subFlowType: Flow.Type)

    case flowControllerWillAttachFlow(flowControllerIdentifier: ObjectIdentifier,
                                      flowIdentifier: ObjectIdentifier,
                                      flowType: Flow.Type)

    case flowControllerDidDetachFlow(flowControllerIdentifier: ObjectIdentifier,
                                     flowIdentifier: ObjectIdentifier,
                                     flowType: Flow.Type)
}

#endif
