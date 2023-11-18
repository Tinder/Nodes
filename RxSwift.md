# Using RxSwift with Nodes

Using [RxSwift](https://github.com/ReactiveX/RxSwift) with Nodes requires custom configuration and setup.

## Step 1 - Configure the Nodes Xcode Templates Generator for RxSwift

Specify a path to a custom config file by providing the `--config` option when executing `nodes-xcode-templates-gen`.

If utlizing the [quick start project setup](https://github.com/TinderApp/Nodes#quick-start), the path can be set in the `project.yml` file, for example:

```
swift run -- nodes-xcode-templates-gen --id "RxSwift" --config "nodes.yml"
```

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
isPreviewProviderEnabled: true
```

## Step 2 - Add Supporting Types

Add the following types to the application:

```swift
import Nodes
import RxSwift

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
```
