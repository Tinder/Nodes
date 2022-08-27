# Contributing to Nodes

- [Project Setup](#project-setup)

## Project Setup

### Requirements

- Xcode version `13.3` or greater

### Install dependencies

```
$ brew install libgit2
```

### Clone repository

```
$ git clone git@github.com:TinderApp/Nodes.git && cd Nodes
```

### Open project in Xcode

```
$ xed Package.swift
```

Confirm all package dependencies are resolved successfully before continuing.

### Building

Confirm the `Nodes-Package` scheme is selected and then select `Build` from the `Product` menu (Command-B).

### Testing

Confirm the `Nodes-Package` scheme is selected and then select `Test` from the `Product` menu (Command-U).
