# ``Nodes``

Nodes Architecture Framework

Native Mobile Application Engineering at Scale

[https://github.com/TinderApp/Nodes](https://github.com/TinderApp/Nodes)

At Tinder we create mobile applications ***to keep the magic of human connection alive***. And to do that successfully, we built a large team of mobile engineers who continually deliver numerous concurrent projects to empower, delight and protect our countless members around the globe.

We think [Swift](https://developer.apple.com/swift) and related technologies including [SwiftUI](https://developer.apple.com/documentation/swiftui) and [Swift Concurrency](https://developer.apple.com/documentation/swift/swift_standard_library/concurrency) are simply awesome. However, building a mobile application at Tinder's scale requires a scalable application architecture as well. We created the Nodes Architecture Framework to specifically address how to build a complex app, with a large team, involving many simultaneous initiatives.

Nodes provides a modular and plugin-based approach to assembling an app with countless screens and features. Nodes leverages reactive data streams for state management to allow app state to be distributed, which is essential when many different teams own different parts of the codebase. Nodes is not opinionated about which reactive library to use however, or even which UI framework to use. In fact, Nodes is fully compatible with [SwiftUI](https://developer.apple.com/xcode/swiftui), [UIKit](https://developer.apple.com/documentation/uikit) and [AppKit](https://developer.apple.com/documentation/appkit).

We also want you to know that the Nodes Architecture Framework leverages some concepts and patterns similar to [Uber's cross-platform mobile architecture framework](https://github.com/uber/RIBs) (RIBs) but was built from the ground up to include unique benefits purpose built for [Tinder](https://github.com/tinder). ***No source code has been copied from RIBs*** to create this framework. Other open source projects such as [Needle](https://github.com/uber/needle) and [Mockolo](https://github.com/uber/mockolo) are utilized as dependencies when creating an app with Nodes.

We ❤️ building mobile applications with Nodes and we hope you ~will~ do to.

## Topics

### Plugin

Experimentation and Feature Gating

A Node's `Plugin` instance is a factory that optionally creates and returns the Node's `Builder` instance. `PluginList` and `PluginMap` provide `Plugin` collections.

`Plugin`, `PluginList` and `PluginMap` subclasses are intended to contain conditional logic such as to support experimentation and feature gating. Always utilize `PluginList` and `PluginMap` collections when versioning or A|B Testing Nodes.

The `PluginListWithDefault` and `PluginMapWithDefault` variants allow for a default instance to be used when the collection is empty.

- ``Plugin``
- ``PluginList``
- ``PluginListWithDefault``
- ``PluginMap``
- ``PluginMapWithDefault``

### Builder

Node Creation and Dependency Injection

A Node's `Builder` instance is a factory that non-optionally creates and returns the Node's `Flow` instance.

At that same time, the `Builder` also creates several other objects including the Node's `Context` instance, one or more `Worker` instances, and its ``ViewControllable`s``` instance.

Every `Builder` is provided a DI graph `Component` whose dependencies are made available for injection into the objects the `Builder` creates.

The `Builder` injects dynamic component dependencies (if provided) into the `Component` and injects dynamic build dependencies into the objects the `Builder` creates (for example injecting the Node's listener into the `Context` instance). Dynamic dependencies might include identifiers or other app state, but would never be services or dependencies provided by the DI graph `Component`. Dynamic dependencies are instead provided by a parent `Flow` when calling a `Builder` instance's build method.

- ``AbstractBuilder``

### Flow

Node Tree and Routing

A Node's `Flow` instance acts as a router and is responsible for attaching child `Flow` instances.

A Node tree is created when parent `Flow` instances use a `Builder` instance (either directly or from a `PluginList`, `PluginMap` or `Plugin` instance) to create a child `Flow` instance, and then present the ``ViewControllable`` instance of the child `Flow` and subsequently attach the child `Flow`. This will automatically start the child Node's `Flow` instance, activate the child Node's `Context` instance and start the child Node's `Worker` instances.

A `Flow` is also responsible for detaching its child `Flow` instances which occurs in the reverse order. This is an important lifecycle event for the Node, meaning that when a `Flow` instance is detached from its parent, the expectation is that all memory used by the Node and all of its objects is released.

- ``Flow``
- ``FlowRetaining``
- ``AbstractFlow``

### Context

Events and Interactions

A Node's `Context` instance acts as an interactor and is responsible for handling events and responding to user interactions (received through a `Receiver` protocol from the user interface).

To avoid bloating the `Context` instance, data transformations and other business logic can exist in the Node's `Worker` instances, and the `Context` may call methods on those `Worker` instances as needed.

The `Context` may participate in keeping the Node's user interface (through a `Presentable` protocol) in sync with the current app state, though the Node's view state dedicated `Worker` normally handles this responsibility.

The `Context` can (as desired) delegate data requests, event handling and user interactions to the Node's listener which, in almost every situation, is the `Context` of the parent Node.

- ``Context``
- ``AbstractContext``
- ``AbstractPresentableContext``

### Worker

Data Transformations and Business Logic

Every Node includes a `Worker` instance responsible for transforming app state into view state. Additional `Worker` instances may be used (as needed) for other data transformations or additional business logic. The Node's `Context` instance may call methods on the Node's `Worker` instances as needed.

- ``Worker``
- ``AbstractWorker``

### UI

User Interface

A Node's ``ViewControllable`` instance defines its user interface (for example a [UIViewController](https://developer.apple.com/documentation/uikit/uiviewcontroller) in a [UIKit](https://developer.apple.com/documentation/uikit) app) and is also responsible for displaying or presenting the user interface of child Nodes. A ``ViewControllable`` protocol is used instead of the concrete class type to limit the available API, to avoid the use of UI frameworks (such as [UIKit](https://developer.apple.com/documentation/uikit)) within `Flow` instances and to facilitate testing.

The ``ViewControllable`` instance is injected into the Node's `Context` as well, however a different protocol named `Presentable` is used there.

This means the same exact instance is accessed through a ``ViewControllable`` protocol from within the `Flow` instance (for presentation) and through a `Presentable` protocol from within the `Context` instance (for updating the UI).

Note that although the `Context` may participate in keeping a Node's user interface in sync with the current app state, the Node's view state dedicated `Worker` normally handles this responsibility.

- ``ViewControllable``
- ``ViewControllableFlow``
- ``NavigationControllable``
- ``TabBarControllable``
- ``ModalStyle``

### SwiftUI

- ``NodesView``
- ``NodesViewHostingController``
- ``AbstractViewHostingController``

### View State

- ``InitialStateProviding``
- ``StateObserver``
- ``WithViewState``

### Reactive

- ``Cancellable``

### Utility

- ``LeakDetector``

### Internal

- ``FlowController``
- ``WorkerController``
