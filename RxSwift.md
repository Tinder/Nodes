# Using RxSwift with Nodes

While Nodes works out-of-the-box with [Combine](https://developer.apple.com/documentation/combine), using [RxSwift](https://github.com/ReactiveX/RxSwift) with Nodes requires the following custom configuration and setup.

## Configure the Xcode Template Generator

Specify a path to a custom config file by providing the `--config` option when executing `nodes-xcode-templates-gen`.

If utilizing the [quick start project setup](https://github.com/TinderApp/Nodes#quick-start), the path can be set in the `project.yml` file, for example:

```
swift run -- nodes-xcode-templates-gen --id "RxSwift" --config "nodes.yml"
```

> TIP: The provided `id` value is used to uniquely identify different sets of templates within the new file dialog in Xcode.

### Sample Config File

```yaml
uiFrameworks:
  - framework: UIKit
    viewControllerMethods: |
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
  - framework: SwiftUI
reactiveImports:
  - RxSwift
viewControllerSubscriptionsProperty: |
  /// The DisposeBag instance.
  private var disposeBag: DisposeBag = .init()
viewStateEmptyFactory: Observable.empty()
viewStateOperators: |
  .distinctUntilChanged()
  .observe(on: MainScheduler.instance)
viewStatePropertyComment: The view state observable
viewStatePropertyName: stateObservable
viewStateTransform: context.$state.map { viewStateFactory($0) }
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

public class AbstractContext: _BaseContext {

    public var disposeBag: DisposeBag = .init()

    override public final func _reset() {
        LeakDetector.detect(disposeBag)
        disposeBag = DisposeBag()
    }
}

public class AbstractWorker: _BaseWorker {

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

extension WithViewState {

    public init<P: Publisher>(
        initialState: ViewState,
        stateObservable publisher: P,
        @ViewBuilder content: @escaping (ViewState) -> Content
    ) where P.Output == ViewState, P.Failure == Never {
        self.init(initialState: initialState, statePublisher: publisher, content: content)
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
