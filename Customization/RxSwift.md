# Using RxSwift with Nodes

While Nodes is configured by default for [Combine](https://developer.apple.com/documentation/combine), other reactive frameworks such [RxSwift](https://github.com/ReactiveX/RxSwift) require custom configuration and setup.

## Configure the Xcode Templates Generator

Specify a path to a custom config file by providing the `--config` option when executing the `nodes-xcode-templates-gen` command.

<details>

<summary><strong>Quick Start Project Setup</strong></summary>

<br>

If utilizing the [quick start project setup](https://github.com/Tinder/Nodes#quick-start), the path can be set in the `project.yml` file:

```
swift run --skip-build -- nodes-xcode-templates-gen --id "RxSwift" --config "nodes.yml"
```

> TIP: The provided `id` value is used to uniquely identify different sets of templates within the new file dialog in Xcode.

The script that creates the presets in the quick start project should use the same config file:

```
swift run --skip-build -- nodes-code-gen --preset "$PRESET" --author "$AUTHOR" --path "$1" --config "nodes.yml"
```

</details>

## Sample Config File

```yaml
uiFrameworks:
  - framework:
      custom:
        name: UIKit (RxSwift)
        import: UIKit
        viewControllerType: UIViewController
        viewControllerSuperParameters: "nibName: nil, bundle: nil"
        viewControllerMethods: |-
          @available(*, unavailable)
          internal required init?(coder: NSCoder) {
              preconditionFailure("init(coder:) has not been implemented")
          }

          override internal func viewDidLoad() {
              super.viewDidLoad()
              view.backgroundColor = .systemBackground
              update(with: initialState)
          }

          override internal func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)
              observe(stateObservable).disposed(by: disposeBag)
          }

          override internal func viewWillDisappear(_ animated: Bool) {
              super.viewWillDisappear(animated)
              LeakDetector.detect(disposeBag)
              disposeBag = DisposeBag()
          }
reactiveImports:
  - RxSwift
viewControllerSubscriptionsProperty: |-
  /// The DisposeBag instance.
  private var disposeBag: DisposeBag = .init()
viewStateEmptyFactory: Observable.empty()
viewStateOperators: |-
  .distinctUntilChanged()
  .observe(on: MainScheduler.instance)
viewStatePropertyComment: The view state observable
viewStatePropertyName: stateObservable
viewStateTransform: store.viewStatePublisher.asObservable()
publisherType: Observable
publisherFailureType: ""
contextGenericTypes: []
workerGenericTypes: []
```

## Add Supporting Types

Add the following types to the application:

```swift
import Combine
import Nodes
import RxSwift
import SwiftUI

open class AbstractContext: _BaseContext {

    public var disposeBag: DisposeBag = .init()

    override public final func _reset() {
        LeakDetector.detect(disposeBag)
        disposeBag = DisposeBag()
    }
}

open class AbstractWorker: _BaseWorker {

    public var disposeBag: DisposeBag = .init()

    override public final func _reset() {
        LeakDetector.detect(disposeBag)
        disposeBag = DisposeBag()
    }
}

@propertyWrapper
public struct Published<Value> {

    public var wrappedValue: Value {
        didSet { subject.onNext(wrappedValue) }
    }

    public var projectedValue: Observable<Value> {
        subject
    }

    private let subject: PublishSubject<Value> = .init()

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}

extension StateObserver {

    public func observe<O: ObservableType>(
        _ observable: O
    ) -> Disposable where O.Element == StateObserverStateType {
        observable.subscribe { [weak self] state in
            self?.update(with: state)
        }
    }
}

extension Publisher {

    public func asObservable() -> Observable<Output> {
        Observable.create { observer in
            let cancellable: AnyCancellable = sink { completion in
                switch completion {
                case .finished:
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            } receiveValue: { value in
                observer.onNext(value)
            }
            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
}

extension Observable: Publisher {

    public typealias Output = Element
    public typealias Failure = Never

    public func receive<S>(subscriber: S) where S: Subscriber, S.Input == Element, S.Failure == Never {
        subscriber.receive(subscription: ObservableSubscription(subscriber: subscriber, observable: self))
    }
}

private final class ObservableSubscription
<
    T,
    S: Subscriber
>
: Subscription where S.Input == T,
                     S.Failure == Never {

    private var disposeBag: DisposeBag? = .init()

    init(subscriber: S, observable: Observable<T>) {
        guard let disposeBag: DisposeBag
        else { return }
        observable
            .subscribe { _ = subscriber.receive($0) }
            .disposed(by: disposeBag)
    }

    func request(_ demand: Subscribers.Demand) {}

    func cancel() {
        disposeBag = nil
    }
}
```

Optionally add the following type to the application to additionally support the presentable context pattern.

```swift
open class AbstractPresentableContext<PresentableType>: AbstractContext {

    public let presentable: PresentableType

    public init(presentable: PresentableType, workers: [Worker]) {
        self.presentable = presentable
        super.init(workers: workers)
    }
}
```
