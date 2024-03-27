# ``Nodes``

Native Mobile Application Engineering at Scale

##

![Nodes Architecture Framework](Nodes)

## Nodes Architecture Framework

Native Mobile Application Engineering at Scale

## Overview

At Tinder, we create mobile applications ***to power and inspire real connections by making meeting easy and fun for every new generation of singles***. And to do that successfully, we assembled a large team of mobile engineers who continually deliver numerous concurrent projects to empower, delight and protect our countless members around the globe.

We think [Swift](https://developer.apple.com/swift) and related technologies including [SwiftUI](https://developer.apple.com/xcode/swiftui) and [Swift Concurrency](https://developer.apple.com/documentation/swift/swift_standard_library/concurrency) are simply awesome. However, creating mobile applications at Tinder's scale requires a scalable application architecture as well. We designed the Nodes Architecture Framework to specifically address how to build a complex app, with a large team, involving many simultaneous initiatives.

Nodes provides a modular and plugin-based approach to assembling an app with countless screens and features. Nodes leverages reactive data streams for state management to allow app state to be distributed, which is essential when many different teams own different parts of the codebase. Nodes is not opinionated about which reactive library to use however, or even which UI framework to use. In fact, Nodes is fully compatible with [SwiftUI](https://developer.apple.com/documentation/swiftui), [UIKit](https://developer.apple.com/documentation/uikit) and [AppKit](https://developer.apple.com/documentation/appkit).

Although the Nodes Architecture Framework leverages some concepts and patterns similar to [Uber's cross-platform mobile architecture framework](https://github.com/uber/RIBs) (RIBs), it was developed from the ground up to provide unique benefits purpose-built for [Tinder](https://github.com/tinder). ***No source code has been copied from RIBs*** into this framework. Other open source projects such as [Needle](https://github.com/uber/needle) and [Mockolo](https://github.com/uber/mockolo) are utilized as dependencies when creating an app with Nodes.

We ❤️ building mobile applications with Nodes and we hope you ~~will~~ do too!

## Design Goals

#### Reliable Extensibility

An app at scale has to remain as close to 100% reliable as possible while it is mutated and extended, in other words, as new features are added and tested. Due to its design, the Nodes architecture allows every feature to achieve very high test coverage and enables all screens of an application to be fully decoupled from one another. Any feature, any screen, any business rule and any underlying service may be dynamically swapped out for an alternate implementation. This extensibility allows new features and bug fixes to be delivered safely to avoid breaking existing functionality.

#### Feature Implementation Consistency

The Nodes architecture is backed by the Nodes framework which includes base classes and companion types to provide a cookie cutter approach to feature development. Every screen of an application is then implemented with the same exact structure. This consistent repeatable pattern is fostered by Nodes' Xcode templates.

#### Memory Management

Native mobile applications need to be good citizens within their host device and operating system. Memory leaks and even normal memory use must be managed carefully. This can be challenging enough in a small app, and inside a large codebase it can quickly become unmanageable without a clear plan. The Nodes architecture provides controls for the lifecycle of each feature screen in the application which allows all memory of each experience to be reclaimed.

## Introduction

In a Nodes based application, the code implementation for a single screen is referred to as a "node". The application can be thought of as a node tree, where navigating from screen to screen creates the branches, referred to as attaching a node to another node.

Each node is comprised of a few pre-defined types working in conjunction to power the screen and provide clean separation of concerns. Interaction handling and business logic for a screen is contained in the `Context` of the node, while its `Flow` is used for routing to other screens by attaching to other nodes within the application. The view of each node then remains solely focused on presentation. Each node can contain state which is transformed into view state and provided to the view for display.

## Topics

### Experimentation and Feature Gating

`Plugin` and `PluginList` subclasses provide conditional logic for experimentation and feature gating.

A Node's `Plugin` instance is a factory that optionally creates and returns the Node's `Builder` instance.

A `PluginList` instance provides a `Plugin` collection enabling versioning or A|B Testing multiple Nodes. The `PluginListWithDefault` variant allows for a default instance to be prepended to the `Builder` collection.

- ``Plugin``
- ``PluginList``
- ``PluginListWithDefault``

### Node Creation and Dependency Injection

A Node's `Builder` instance is a factory that non-optionally creates and returns the Node's `Flow` instance.

At that same time, the `Builder` also creates several other objects including the Node's `Context` instance, one or more `Worker` instances, and its ``ViewControllable`` instance.

Every `Builder` is provided a DI graph `Component` whose dependencies are made available for injection into the objects the `Builder` creates.

The `Builder` injects dynamic component dependencies (if provided) into the `Component` and injects dynamic build dependencies into the objects the `Builder` creates (for example injecting the Node's listener into the `Context` instance). Dynamic dependencies might include identifiers or other app state, but would never be services or dependencies provided by the DI graph `Component`. Dynamic dependencies are instead provided by a parent `Flow` when calling a `Builder` instance's build method.

- ``AbstractBuilder``

### Node Tree and Routing

A Node's `Flow` instance acts as a router and is responsible for attaching child `Flow` instances.

A Node tree is created when parent `Flow` instances use a `Builder` instance (either directly or from a `Plugin` or `PluginList` instance) to create a child `Flow` instance, and then present the ``ViewControllable`` instance of the child `Flow` and subsequently attach the child `Flow`. This will automatically start the child Node's `Flow` instance, activate the child Node's `Context` instance and start the child Node's `Worker` instances.

A `Flow` is also responsible for detaching its child `Flow` instances which occurs in the reverse order. This is an important lifecycle event for the Node, meaning that when a `Flow` instance is detached from its parent, the expectation is that all memory used by the Node and all of its objects is released.

- ``Flow``
- ``ViewControllableFlow``
- ``AbstractFlow``
- ``FlowRetaining``

### Events and Interactions

A Node's `Context` instance acts as an interactor and is responsible for handling events and responding to user interactions (received through a `Receiver` protocol from the user interface).

To avoid bloating the `Context` implementation, one or more `Worker` instances containing business logic may exist in the Node's `Worker` collection, and the `Context` can call methods on these `Worker` instances as needed.

The `Context` can (as desired) delegate data requests, event handling and user interactions to the Node's listener which, in almost every situation, is the `Context` of the parent Node.

- ``Context``
- ``AbstractContext``
- ``AbstractPresentableContext``

### Business Logic

One or more `Worker` instances containing business logic may exist in each Node's `Worker` collection, and the `Context` instance can call methods on these `Worker` instances as needed.

`Worker` class definitions do not have to be strictly associated to an individual Node. This enables sharing business logic with other Nodes and may be leveraged, for example, to allow a `Worker` defined in one module to be used in the `Worker` collection of a Node in another module. In this case, the `Worker` class definition should be stored separately from any specific Node's source files.

- ``Worker``
- ``AbstractWorker``

### User Interface

A Node's ``ViewControllable`` instance defines its user interface (for example a [UIViewController](https://developer.apple.com/documentation/uikit/uiviewcontroller) in a [UIKit](https://developer.apple.com/documentation/uikit) app) and is also responsible for displaying or presenting the user interface of child Nodes.

A ``ViewControllable`` protocol is used instead of the concrete class type to limit the available API, to avoid the use of UI frameworks (such as [UIKit](https://developer.apple.com/documentation/uikit)) within `Flow` instances and to facilitate testing.

- ``ViewControllable``
- ``NavigationControllable``
- ``TabBarControllable``
- ``WindowSceneViewControllable``
- ``WindowViewControllable``
- ``ModalStyle``

### UIKit Additions

- ``NavigationController``

### Reactive

- ``Cancellable``
- ``MutableState``
- ``StateObserver``
- ``Transform``
- ``WithViewState``

### Utility

- ``LeakDetector``

### Internal

- ``FlowController``
- ``WorkerController``

### Debugging

- ``DebugInformation``
- ``Node``
