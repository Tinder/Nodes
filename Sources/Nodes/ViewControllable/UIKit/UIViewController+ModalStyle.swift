//
//  UIViewController+ModalStyle.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

public struct ModalStyle: Equatable {

    public enum Behavior: Equatable {

        case cover, overlay

        @available(macCatalyst 13.0, *)
        @available(tvOS, unavailable)
        case page, form

        case custom
    }

    @available(macCatalyst 13.0, *)
    @available(tvOS, unavailable)
    public enum SheetStyle: Equatable {

        case page, form
    }

    public let behavior: Behavior
    public let controlStatusBarAppearance: Bool
    public let allowInteractiveDismissal: Bool
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

    public static func == (lhs: ModalStyle, rhs: ModalStyle) -> Bool {
        lhs.behavior == rhs.behavior
    }

    public static func cover() -> ModalStyle {
        ModalStyle(behavior: .cover,
                   controlStatusBarAppearance: true,
                   allowInteractiveDismissal: false)
    }

    public static func overlay(
        controlStatusBarAppearance: Bool = false
    ) -> ModalStyle {
        ModalStyle(behavior: .overlay,
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

    public static func custom(
        controlStatusBarAppearance: Bool = false
    ) -> ModalStyle {
        ModalStyle(behavior: .custom,
                   controlStatusBarAppearance: controlStatusBarAppearance,
                   allowInteractiveDismissal: false)
    }

    // DEPRECATED - DO NOT USE
    // swiftlint:disable:next identifier_name
    public func _withAdditionalConfiguration(
        configuration additionalConfiguration: @escaping (ViewControllable) -> Void
    ) -> ModalStyle {
        ModalStyle(behavior: behavior,
                   controlStatusBarAppearance: controlStatusBarAppearance,
                   allowInteractiveDismissal: allowInteractiveDismissal,
                   configuration: configuration + [additionalConfiguration])
    }
}

extension UIViewController {

    @discardableResult
    public func withModalStyle(_ modalStyle: ModalStyle) -> Self {
        switch modalStyle.behavior {
        case .cover:
            modalPresentationStyle = .fullScreen
        case .overlay:
            modalPresentationStyle = .overFullScreen
        case .page:
            modalPresentationStyle = .pageSheet
        case .form:
            modalPresentationStyle = .formSheet
        case .custom:
            modalPresentationStyle = .custom
        }
        modalPresentationCapturesStatusBarAppearance = modalStyle.controlStatusBarAppearance
        if #available(iOS 13.0, *) {
            isModalInPresentation = !modalStyle.allowInteractiveDismissal
        }
        modalStyle.configuration.forEach { $0(self) }
        return self
    }
}

#endif
