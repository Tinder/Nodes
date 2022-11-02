//
//  CurrentValuePublisher.swift
//  Nodes
//
//  Created by Christopher Fuller on 11/1/22.
//

import Combine

@available(macOS 11.0, macCatalyst 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
public final class CurrentValuePublisher<Output>: Publisher {

    public typealias Output = Output
    public typealias Failure = Never

    @Published public private(set) var value: Output

    public init<P: Publisher>(initialValue: Output, publisher: P) where P.Output == Output, P.Failure == Failure {
        value = initialValue
        publisher.assign(to: &$value)
    }

    public func receive<S>(subscriber: S) where S : Subscriber, S.Input == Output, S.Failure == Failure {
        $value.receive(subscriber: subscriber)
    }

    public func receive<S>(
        on scheduler: S,
        options: S.SchedulerOptions? = nil
    ) -> CurrentValuePublisher<Output> where S : Scheduler {
        $value.receive(on: scheduler, options: options).asCurrentValuePublisher(initialValue: value)
    }
}

@available(macOS 11.0, macCatalyst 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension CurrentValuePublisher where Output: Equatable {

    public func removeDuplicates() -> CurrentValuePublisher<Output> {
        self
            .eraseToAnyPublisher()
            .removeDuplicates()
            .asCurrentValuePublisher(initialValue: value)
    }
}

@available(macOS 11.0, macCatalyst 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension CurrentValueSubject where Failure == Never {

    public func asCurrentValuePublisher() -> CurrentValuePublisher<Output> {
        CurrentValuePublisher(initialValue: value, publisher: self)
    }
}

@available(macOS 11.0, macCatalyst 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension Just where Failure == Never {

    public func asCurrentValuePublisher() -> CurrentValuePublisher<Output> {
        CurrentValuePublisher(initialValue: output, publisher: self)
    }
}

@available(macOS 11.0, macCatalyst 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension Publisher where Failure == Never {

    public func asCurrentValuePublisher(initialValue: Output) -> CurrentValuePublisher<Output> {
        CurrentValuePublisher(initialValue: initialValue, publisher: self)
    }
}
