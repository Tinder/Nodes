//
//  UIViewController+ModalStyle.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

extension UIViewController {

    public struct ModalStyle: Equatable {

        public static func == (lhs: ModalStyle, rhs: ModalStyle) -> Bool {
            lhs.behavior == rhs.behavior
        }

        // swiftlint:disable:next nesting
        public enum Behavior: Equatable {

            case cover, overlay, custom

            @available(macCatalyst 13.0, *)
            @available(tvOS, unavailable)
            case page, form
        }

        @available(macCatalyst 13.0, *)
        @available(tvOS, unavailable)
        // swiftlint:disable:next nesting
        public enum SheetStyle: Equatable {

            case page, form

            // swiftlint:disable:next strict_fileprivate
            fileprivate var behavior: Behavior {
                switch self {
                case .page:
                    return .page
                case .form:
                    return .form
                }
            }

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

        public static func cover() -> ModalStyle {
            ModalStyle(behavior: .cover,
                       presentationStyle: .fullScreen,
                       controlStatusBarAppearance: true,
                       allowInteractiveDismissal: false)
        }

        public static func overlay(
            controlStatusBarAppearance: Bool = false
        ) -> ModalStyle {
            ModalStyle(behavior: .overlay,
                       presentationStyle: .overFullScreen,
                       controlStatusBarAppearance: controlStatusBarAppearance,
                       allowInteractiveDismissal: false)
        }

        public static func custom(
            controlStatusBarAppearance: Bool = false
        ) -> ModalStyle {
            ModalStyle(behavior: .custom,
                       presentationStyle: .custom,
                       controlStatusBarAppearance: controlStatusBarAppearance,
                       allowInteractiveDismissal: false)
        }

        @available(macCatalyst 13.0, *)
        @available(tvOS, unavailable)
        public static func sheet(
            style sheetStyle: SheetStyle = .page,
            controlStatusBarAppearance: Bool = false,
            allowInteractiveDismissal: Bool = false
        ) -> ModalStyle {
            ModalStyle(behavior: sheetStyle.behavior,
                       presentationStyle: sheetStyle.presentationStyle,
                       controlStatusBarAppearance: controlStatusBarAppearance,
                       allowInteractiveDismissal: allowInteractiveDismissal)
        }

        public let behavior: Behavior

        internal let presentationStyle: UIModalPresentationStyle
        internal let controlStatusBarAppearance: Bool
        internal let allowInteractiveDismissal: Bool
        internal let configuration: [(ViewControllable) -> Void]

        private init(
            behavior: Behavior,
            presentationStyle: UIModalPresentationStyle,
            controlStatusBarAppearance: Bool,
            allowInteractiveDismissal: Bool,
            configuration: [(ViewControllable) -> Void] = []
        ) {
            self.behavior = behavior
            self.presentationStyle = presentationStyle
            self.controlStatusBarAppearance = controlStatusBarAppearance
            self.allowInteractiveDismissal = allowInteractiveDismissal
            self.configuration = configuration
        }

        public func withAdditionalConfiguration(
            configuration additionalConfiguration: @escaping (ViewControllable) -> Void
        ) -> ModalStyle {
            ModalStyle(
                behavior: behavior,
                presentationStyle: presentationStyle,
                controlStatusBarAppearance: controlStatusBarAppearance,
                allowInteractiveDismissal: allowInteractiveDismissal,
                configuration: configuration + [additionalConfiguration]
            )
        }
    }

    @discardableResult
    public func withModalStyle(_ modalStyle: ModalStyle) -> Self {
        modalPresentationStyle = modalStyle.presentationStyle
        if #available(macCatalyst 13.0, *) {
            #if !os(tvOS)
            modalPresentationCapturesStatusBarAppearance = modalStyle.controlStatusBarAppearance
            #endif
        }
        if #available(macCatalyst 13.0, iOS 13.0, tvOS 13.0, *) {
            isModalInPresentation = !modalStyle.allowInteractiveDismissal
        }
        modalStyle.configuration.forEach { $0(self) }
        return self
    }
}

#endif
