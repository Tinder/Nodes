//
//  StateObserver.swift
//  Nodes
//
//  Created by Christopher Fuller on 5/1/21.
//

#if canImport(Combine)

import Combine
import Foundation

/// @mockable
public protocol StateObserver: AnyObject {

    associatedtype StateObserverStateType: Equatable

    func update(with: StateObserverStateType)
}

@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension StateObserver {

    public func observe<P: Publisher>(
        _ publisher: P
    ) -> AnyCancellable where P.Output == StateObserverStateType, P.Failure == Never {
        publisher
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.update(with: $0)
            }
    }
}

#endif
