//
//  StateObserver.swift
//  Nodes
//
//  Created by Christopher Fuller on 5/1/21.
//

#if canImport(Combine)
import Combine
#endif

public protocol StateObserver: AnyObject {

    associatedtype StateObserverStateType

    func update(with: StateObserverStateType)
}

@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension StateObserver {

    public func observe<P: Publisher>(
        _ publisher: P
    ) -> AnyCancellable where P.Output == StateObserverStateType, P.Failure == Never {
        publisher.sink { [weak self] in
            self?.update(with: $0)
        }
    }
}
