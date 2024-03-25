# Nodes Configuration

While Nodes works out-of-the-box with [UIKit](https://developer.apple.com/documentation/uikit) and [SwiftUI](https://developer.apple.com/xcode/swiftui) (for iOS), the following custom configuration is required to use other UI frameworks, such as [AppKit](https://developer.apple.com/documentation/appkit).

## Configure the Xcode Templates Generator

Specify a path to a custom config file by providing the `--config` option when executing `nodes-xcode-templates-gen`.

<details>

<summary><strong>Quick Start Project Setup</strong></summary>

<br>

If utilizing the [quick start project setup](https://github.com/TinderApp/Nodes#quick-start), the path can be set in the `project.yml` file:

```
swift run --skip-build -- nodes-xcode-templates-gen --id "Custom" --config "nodes.yml"
```

> TIP: The provided `id` value is used to uniquely identify different sets of templates within the new file dialog in Xcode.

The script that creates the presets in the quick start project should use the same config file:

```
swift run --skip-build -- nodes-code-gen --preset "$PRESET" --author "$AUTHOR" --path "$1" --config "nodes.yml"
```

</details>

### Sample Config File

All values shown in the samples below are the defaults.

> TIP: It is only necessary to include config options that are different from the defaults.

```yaml
fileHeader: //___FILEHEADER___
baseImports: []
baseTestImports:
  - Nimble
  - XCTest
reactiveImports: 
  - Combine
dependencyInjectionImports: 
  - NeedleFoundation
builderImports: []
flowImports: []
viewControllerImports: []
dependencies: []
analyticsProperties: []
flowProperties: []
viewControllableFlowType: ViewControllableFlow
viewControllableType: ViewControllable
viewControllableMockContents: ""
viewControllerSubscriptionsProperty: |
  /// The collection of cancellable instances.
  private var cancellables: Set<AnyCancellable> = .init()
viewControllerUpdateComment: |
  // Add implementation to update the user interface when the view state changes.
viewStateEmptyFactory: Empty().eraseToAnyPublisher()
viewStateOperators: |
  .removeDuplicates()
  .receive(on: DispatchQueue.main)
  .eraseToAnyPublisher()
viewStatePropertyComment: The view state publisher
viewStatePropertyName: statePublisher
viewStateTransform: Publishers.Map(upstream: context.$state, transform: viewStateFactory).eraseToAnyPublisher()
publisherType: AnyPublisher
publisherFailureType: Never
contextGenericTypes:
  - AnyCancellable
workerGenericTypes: 
  - AnyCancellable
isViewInjectedTemplateEnabled: true
isPreviewProviderEnabled: false
isTestTemplatesGenerationEnabled: false
isPeripheryCommentEnabled: false
```

To control which UI Frameworks are made available within the new file dialog in Xcode, include configuration for AppKit, UIKit, or SwiftUI as shown below; or a fully custom UI framework may be configured for unique use cases. More than one UI framework can be included in the configuration. And by default, without providing any UI framework configuration, UIKit and SwiftUI (for iOS) are automatically configured. 

> TIP: For use in an iOS app that allows both UIKit and SwiftUI, both may be enabled simultaneously if desired.

#### AppKit

```yaml
uiFrameworks:
  - framework: AppKit
    viewControllerProperties: ""
    viewControllerMethods: |
      @available(*, unavailable)
      internal required init?(coder: NSCoder) {
          preconditionFailure("init(coder:) has not been implemented")
      }

      override internal func viewDidLoad() {
          super.viewDidLoad()
          update(with: initialState)
      }

      override internal func viewWillAppear() {
          super.viewWillAppear()
          observe(statePublisher).store(in: &cancellables)
      }

      override internal func viewWillDisappear() {
          super.viewWillDisappear()
          cancellables.cancelAll()
      }
```

#### UIKit

```yaml
uiFrameworks:
  - framework: UIKit
    viewControllerProperties: ""
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
          observe(statePublisher).store(in: &cancellables)
      }

      override internal func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          cancellables.cancelAll()
      }
```

#### SwiftUI

> IMPORTANT: SwiftUI is only supported in iOS apps currently (SwiftUI support for macOS apps may be added in the future).

```yaml
uiFrameworks:
  - framework: SwiftUI
    viewControllerProperties: ""
    viewControllerMethods: ""
```

#### Custom

> IMPORTANT: A non-empty string must be provided for `name`, `import` and `viewControllerType`.

```yaml
uiFrameworks:
  - framework:
      custom:
        name: ""
        import: ""
        viewControllerType: ""
        viewControllerSuperParameters: ""
    viewControllerProperties: ""
    viewControllerMethods: ""
```
