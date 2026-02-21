//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

#if DEBUG && canImport(Combine)

import Combine
import Foundation

internal protocol NotificationPosting {

    var notification: Notification { get }
}

// swiftlint:disable:next file_types_order
extension NotificationPosting {

    internal func post() {
        NotificationCenter.default.post(notification)
    }
}

public enum DebugInformation {

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

    private typealias UserInfo = [UserInfoKey: Any]

    public final class Factory {

        private weak var object: AnyObject?

        internal init(_ object: AnyObject) {
            self.object = object
        }

        // swiftlint:disable unused_parameter

        public func canMake<T>(withObjectOfType type: T.Type) -> Bool {
            (object as? T) != nil
        }

        /// Use the factory's `object` instance (a view controller for example) to make
        /// an instance of another type (a view snapshot for example).
        ///
        /// Will return `nil` if the factory's weak `object` instance is `nil` or cannot
        /// be cast to type `T`.
        ///
        /// If an identity transform is provided, `nil` will be returned to prevent direct
        /// access to the factory's weak `object` itself.
        public func make<T: AnyObject, U>(
            withObjectOfType type: T.Type,
            transform: @MainActor (T) throws -> U
        ) async rethrows -> U? where T: Sendable, U: Sendable {
            guard let input = object as? T
            else { return nil }
            let output: U = try await transform(input)
            guard output as AnyObject !== input
            else { return nil }
            return output
        }

        // swiftlint:enable unused_parameter
    }

    internal final class FlowWillStartNotification: NotificationPosting {

        private static let name: Notification.Name =
            .init("Nodes.\(DebugInformation.self).\(FlowWillStartNotification.self)")

        internal let notification: Notification

        internal init(flow: Flow, viewController: AnyObject) {
            let userInfo: UserInfo = [
                .flowIdentifier: ObjectIdentifier(flow),
                .flowType: type(of: flow),
                .factory: Factory(viewController)
            ]
            notification = Notification(name: Self.name, userInfo: userInfo)
        }

        @available(iOS 13.0, OSX 10.15, *) // swiftlint:disable:next strict_fileprivate
        fileprivate static func publisher() -> AnyPublisher<DebugInformation, Never> {
            NotificationCenter.default.publisher(for: name)
                .compactMap { $0.userInfo as? UserInfo }
                .compactMap { userInfo in
                    guard let flowIdentifier = userInfo[.flowIdentifier] as? ObjectIdentifier,
                          let flowType = userInfo[.flowType] as? Flow.Type,
                          let factory = userInfo[.factory] as? Factory
                    else { return nil }
                    return .flowWillStart(flowIdentifier: flowIdentifier,
                                          flowType: flowType,
                                          factory: factory)
                }
                .eraseToAnyPublisher()
        }
    }

    internal final class FlowDidEndNotification: NotificationPosting {

        private static let name: Notification.Name =
            .init("Nodes.\(DebugInformation.self).\(FlowDidEndNotification.self)")

        internal let notification: Notification

        internal init(flow: Flow) {
            let userInfo: UserInfo = [
                .flowIdentifier: ObjectIdentifier(flow),
                .flowType: type(of: flow)
            ]
            notification = Notification(name: Self.name, userInfo: userInfo)
        }

        @available(iOS 13.0, OSX 10.15, *) // swiftlint:disable:next strict_fileprivate
        fileprivate static func publisher() -> AnyPublisher<DebugInformation, Never> {
            NotificationCenter.default.publisher(for: name)
                .compactMap { $0.userInfo as? UserInfo }
                .compactMap { userInfo in
                    guard let flowIdentifier = userInfo[.flowIdentifier] as? ObjectIdentifier,
                          let flowType = userInfo[.flowType] as? Flow.Type
                    else { return nil }
                    return .flowDidEnd(flowIdentifier: flowIdentifier,
                                       flowType: flowType)
                }
                .eraseToAnyPublisher()
        }
    }

    internal final class FlowWillAttachNotification: NotificationPosting {

        private static let name: Notification.Name =
            .init("Nodes.\(DebugInformation.self).\(FlowWillAttachNotification.self)")

        internal let notification: Notification

        internal init(flow: Flow, subFlow: Flow) {
            let userInfo: UserInfo = [
                .flowIdentifier: ObjectIdentifier(flow),
                .flowType: type(of: flow),
                .subFlowIdentifier: ObjectIdentifier(subFlow),
                .subFlowType: type(of: subFlow)
            ]
            notification = Notification(name: Self.name, userInfo: userInfo)
        }

        @available(iOS 13.0, OSX 10.15, *) // swiftlint:disable:next strict_fileprivate
        fileprivate static func publisher() -> AnyPublisher<DebugInformation, Never> {
            NotificationCenter.default.publisher(for: name)
                .compactMap { $0.userInfo as? UserInfo }
                .compactMap { userInfo in
                    guard let flowIdentifier = userInfo[.flowIdentifier] as? ObjectIdentifier,
                          let flowType = userInfo[.flowType] as? Flow.Type,
                          let subFlowIdentifier = userInfo[.subFlowIdentifier] as? ObjectIdentifier,
                          let subFlowType = userInfo[.subFlowType] as? Flow.Type
                    else { return nil }
                    return .flowWillAttachSubFlow(flowIdentifier: flowIdentifier,
                                                  flowType: flowType,
                                                  subFlowIdentifier: subFlowIdentifier,
                                                  subFlowType: subFlowType)
                }
                .eraseToAnyPublisher()
        }
    }

    internal final class FlowDidDetachNotification: NotificationPosting {

        private static let name: Notification.Name =
            .init("Nodes.\(DebugInformation.self).\(FlowDidDetachNotification.self)")

        internal let notification: Notification

        internal init(flow: Flow, subFlow: Flow) {
            let userInfo: UserInfo = [
                .flowIdentifier: ObjectIdentifier(flow),
                .flowType: type(of: flow),
                .subFlowIdentifier: ObjectIdentifier(subFlow),
                .subFlowType: type(of: subFlow)
            ]
            notification = Notification(name: Self.name, userInfo: userInfo)
        }

        @available(iOS 13.0, OSX 10.15, *) // swiftlint:disable:next strict_fileprivate
        fileprivate static func publisher() -> AnyPublisher<DebugInformation, Never> {
            NotificationCenter.default.publisher(for: name)
                .compactMap { $0.userInfo as? UserInfo }
                .compactMap { userInfo in
                    guard let flowIdentifier = userInfo[.flowIdentifier] as? ObjectIdentifier,
                          let flowType = userInfo[.flowType] as? Flow.Type,
                          let subFlowIdentifier = userInfo[.subFlowIdentifier] as? ObjectIdentifier,
                          let subFlowType = userInfo[.subFlowType] as? Flow.Type
                    else { return nil }
                    return .flowDidDetachSubFlow(flowIdentifier: flowIdentifier,
                                                 flowType: flowType,
                                                 subFlowIdentifier: subFlowIdentifier,
                                                 subFlowType: subFlowType)
                }
                .eraseToAnyPublisher()
        }
    }

    internal final class FlowControllerWillAttachNotification: NotificationPosting {

        private static let name: Notification.Name =
            .init("Nodes.\(DebugInformation.self).\(FlowControllerWillAttachNotification.self)")

        internal let notification: Notification

        internal init(flowController: FlowController, flow: Flow) {
            let userInfo: UserInfo = [
                .flowControllerIdentifier: ObjectIdentifier(flowController),
                .flowIdentifier: ObjectIdentifier(flow),
                .flowType: type(of: flow)
            ]
            notification = Notification(name: Self.name, userInfo: userInfo)
        }

        @available(iOS 13.0, OSX 10.15, *) // swiftlint:disable:next strict_fileprivate
        fileprivate static func publisher() -> AnyPublisher<DebugInformation, Never> {
            NotificationCenter.default.publisher(for: name)
                .compactMap { $0.userInfo as? UserInfo }
                .compactMap { userInfo in
                    guard let flowControllerIdentifier = userInfo[.flowControllerIdentifier] as? ObjectIdentifier,
                          let flowIdentifier = userInfo[.flowIdentifier] as? ObjectIdentifier,
                          let flowType = userInfo[.flowType] as? Flow.Type
                    else { return nil }
                    return .flowControllerWillAttachFlow(flowControllerIdentifier: flowControllerIdentifier,
                                                         flowIdentifier: flowIdentifier,
                                                         flowType: flowType)
                }
                .eraseToAnyPublisher()
        }
    }

    internal final class FlowControllerDidDetachNotification: NotificationPosting {

        private static let name: Notification.Name =
            .init("Nodes.\(DebugInformation.self).\(FlowControllerDidDetachNotification.self)")

        internal let notification: Notification

        internal init(flowController: FlowController, flow: Flow) {
            let userInfo: UserInfo = [
                .flowControllerIdentifier: ObjectIdentifier(flowController),
                .flowIdentifier: ObjectIdentifier(flow),
                .flowType: type(of: flow)
            ]
            notification = Notification(name: Self.name, userInfo: userInfo)
        }

        @available(iOS 13.0, OSX 10.15, *) // swiftlint:disable:next strict_fileprivate
        fileprivate static func publisher() -> AnyPublisher<DebugInformation, Never> {
            NotificationCenter.default.publisher(for: name)
                .compactMap { $0.userInfo as? UserInfo }
                .compactMap { userInfo in
                    guard let flowControllerIdentifier = userInfo[.flowControllerIdentifier] as? ObjectIdentifier,
                          let flowIdentifier = userInfo[.flowIdentifier] as? ObjectIdentifier,
                          let flowType = userInfo[.flowType] as? Flow.Type
                    else { return nil }
                    return .flowControllerDidDetachFlow(flowControllerIdentifier: flowControllerIdentifier,
                                                        flowIdentifier: flowIdentifier,
                                                        flowType: flowType)
                }
                .eraseToAnyPublisher()
        }
    }

    private enum UserInfoKey {

        case flowIdentifier
        case flowType
        case factory
        case subFlowIdentifier
        case subFlowType
        case flowControllerIdentifier
    }

    private static let queue: DispatchQueue = .init(label: "Nodes Debug Notifications",
                                                    qos: .background)

    @available(iOS 13.0, OSX 10.15, *)
    public static func publisher() -> AnyPublisher<Self, Never> {
        Publishers.MergeMany(FlowWillStartNotification.publisher(),
                             FlowDidEndNotification.publisher(),
                             FlowWillAttachNotification.publisher(),
                             FlowDidDetachNotification.publisher(),
                             FlowControllerWillAttachNotification.publisher(),
                             FlowControllerDidDetachNotification.publisher())
        .receive(on: queue)
        .eraseToAnyPublisher()
    }
}

#endif
