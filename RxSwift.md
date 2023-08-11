# Using Nodes with RxSwift

## Configuration

Configure the Nodes Xcode templates generator for RxSwift.

Specify a path to a custom config file by providing the `--config` option when executing `nodes-xcode-templates-gen`.

If utlizing the [quick start project setup](https://github.com/TinderApp/Nodes#quick-start), the path can be set in the `project.yml` file, for example:

```
swift run -- nodes-xcode-templates-gen --id "Xcode Templates" --config nodes.yml
```

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
