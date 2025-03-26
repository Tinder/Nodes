# Nodes Configuration

Nodes is easily customized using a YAML configuration file. The [sample](#sample-config-file) below demonstrates the available options.

While Nodes is configured by default for iOS with [UIKit](https://developer.apple.com/documentation/uikit) and [SwiftUI](https://developer.apple.com/xcode/swiftui), UI frameworks for [AppKit](https://developer.apple.com/documentation/appkit) or other platforms may be enabled. 

## Configure the Xcode Templates Generator

Specify a path to a custom config file by providing the `--config` option when executing the `nodes-xcode-templates-gen` command.

<details>

<summary><strong>Quick Start Project Setup</strong></summary>

<br>

If utilizing the [quick start project setup](https://github.com/Tinder/Nodes#quick-start), the path can be set in the `project.yml` file:

```
swift run --skip-build -- nodes-xcode-templates-gen --id "Custom" --config "nodes.yml"
```

> The provided `id` value is used to uniquely identify different sets of templates within the new file dialog in Xcode.

The script that creates the presets in the quick start project should use the same config file:

```
swift run --skip-build -- nodes-code-gen --preset "$PRESET" --author "$AUTHOR" --path "$1" --config "nodes.yml"
```

</details>

## Sample Config File

All values shown in the sample are the defaults.

> [!TIP]
> It is only necessary to include config options that are different from the defaults.

```yaml
uiFrameworks:
  - framework: UIKit
  - framework: UIKit (SwiftUI)
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
pluginListImports: []
pluginListInterfaceImports: []
viewControllerImports: []
dependencies: []
analyticsProperties: []
flowProperties: []
viewControllableFlowType: ViewControllableFlow
viewControllableType: ViewControllable
viewControllableMockContents: ""
viewControllerStaticContent: ""
viewControllerSubscriptionsProperty: |-
  /// The collection of cancellable instances.
  private var cancellables: Set<AnyCancellable> = .init()
viewControllerUpdateComment: |-
  // Add implementation to update the user interface when the view state changes.
viewStateEmptyFactory: Empty().eraseToAnyPublisher()
viewStateOperators: |-
  .removeDuplicates()
  .receive(on: DispatchQueue.main)
  .eraseToAnyPublisher()
viewStatePropertyComment: The view state publisher.
viewStatePropertyName: statePublisher
viewStateTransform: store.viewStatePublisher
publisherType: AnyPublisher
publisherFailureType: Never
contextGenericTypes:
  - AnyCancellable
workerGenericTypes:
  - AnyCancellable
isViewInjectedTemplateEnabled: true
isObservableStoreEnabled: false
isPreviewProviderEnabled: false
isTestTemplatesGenerationEnabled: true
isPeripheryCommentEnabled: false
```

## UI Frameworks

The UI framework presets available to enable in the config file are `AppKit`, `AppKit (SwiftUI)`, `UIKit` and `UIKit (SwiftUI)`. A fully custom UI framework may be configured for unique use cases.

More than one UI framework may be included in the configuration. Without specifying any UI frameworks, `UIKit` and `UIKit (SwiftUI)` are enabled by default.

```yaml
  - framework: AppKit
```

```yaml
  - framework: AppKit (SwiftUI)
```

```yaml
  - framework: UIKit
```

```yaml
  - framework: UIKit (SwiftUI)
```

```yaml
  - framework:
      custom:
        name: ""
        import: ""
        viewControllerType: ""
        viewControllerSuperParameters: ""
        viewControllerMethods: ""
```

> [!IMPORTANT]
> A non-empty string must be provided for `name`, `import` and `viewControllerType`.

> [!TIP]
> The `viewControllerSuperParameters` and `viewControllerMethods` keys may be omitted.
