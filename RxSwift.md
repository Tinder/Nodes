# Using Nodes with RxSwift

## Configuration

Configure the Nodes Xcode templates generator for RxSwift.

Provide a path to a custom config file with the `--config` option when executing `nodes-xcode-templates-gen`.

### Sample Config File

```yaml
t.b.d.
```

## Supporting Types

Add the following types to the application.

```swift
import Nodes
import RxSwift

internal class AbstractContext: _BaseContext {

    internal var disposeBag: DisposeBag = .init()

    override internal final func _reset() {
        LeakDetector.detect(disposeBag)
        disposeBag = DisposeBag()
    }
}

internal class AbstractWorker: _BaseWorker {

    internal var disposeBag: DisposeBag = .init()

    override internal final func _reset() {
        LeakDetector.detect(disposeBag)
        disposeBag = DisposeBag()
    }
}

@propertyWrapper
internal struct Published<Value> {

    internal var wrappedValue: Value {
        didSet { subject.onNext(wrappedValue) }
    }

    internal var projectedValue: Observable<Value> {
        subject
    }

    private let subject: PublishSubject<Value> = .init()

    internal init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}

extension StateObserver {

    internal func observe<O: ObservableType>(
        _ observable: O
    ) -> Disposable where O.Element == StateObserverStateType {
        observable.subscribe { [weak self] in self?.update(with: $0) }
    }
}
```
