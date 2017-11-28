# Welcome to `Beaver` 

[![Join the chat at https://gitter.im/BeaverFramework/Lobby](https://badges.gitter.im/BeaverFramework/Lobby.svg)](https://gitter.im/BeaverFramework/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Build status](https://travis-ci.org/Beaver/Beaver.svg?branch=master)](https://travis-ci.org/Beaver/Beaver)

A framework to help you build your application fast but right! 

# Introduction

**Beaver is a framework** that includes everything needed to create iOS applications in Swift according to the main [Redux](https://github.com/reactjs/redux) principles.
It aims to set **standards** in order to make iOS development **easier, more scalable and fully testable**.

# Features

What Beaver can help you to do:
- Structure your project correctly.
- Modularize your project in a scalable manner.
- Implement your features in an explicit and exhaustive manner.
- Generate boiler plate code.
- Produce a fully testable code.

On the other hand, Beaver won't help you make your code shorter. Beaver is not a library solving specific problems, it is a framework guiding you to make the right choices when developing your application so it can scale and stay maintainable.

# Architecture

A Beaver application is composed of:

- At least one **Module** per feature.

- The **App State** is the data structure of the application. It contains the modules' data and global context.

- The **App Reducer** is the core logic of the application. It performs updates on the current state based on an event. It is also entirely stateless.

- The **Routing Events** are dispatched to ensure intermodule communications. It's also triggering modules' presentations and dismissals. They are the only public API of the modules.

- The **App Store** stores the app state and maintains it up to date. It also dispatches the events and state updates to its children and subscribers.

- The **App Presenter** subscribes to the app store and presents the modules based on the current app state.

A Beaver module is composed of:

- The **State** is a subset of the app state. It is the data structure of the module. 

- The **UI Events** are dispatched to ensure the module internal UI communications. It's basically triggering business logic on user interactions.

- The **Child Store** is the child of the app store. It holds the module's state. It is the interface to dispatch routing events to the rest of the app and ui event internally.
 
- The **Reducer** is a subset of the app reducer. It is responsible of the internal logic of the module.

- The **Presenter** subscribes to the child store and presents the view controllers based on the current state. It also dispatches routing events to interact with other modules.

- The **ViewController** subscribes to the child store state and builds the views based on the current state. It dispatches ui actions and lifecycle events.

Beaver's architecture implements the *unidirectional data flow*. The flow begins with a ui event, which is dispatched to the store. The store asks a state update to the reducer. The reducer applies the application business logic based on the current state and the received event. The store updates the state, and propagates it thoughout the application, implying ui presentation and ui updates.

# Why Beaver?

Writing an application at an early stage should be done right. In the mean time, we build applications to solve real life problems, and most often, we want to focus on these instead of architecture details. **Beaver is here to help you start your project fast, but right** by generating for you all the boiler plate code that you need, including project's and frameworks' configurations.

The most difficult part when writing an application are the data flows. They can easily be made complex because of the product needs, but also because of the way we write our code. **MVC, MVVM or VIPER don't define a clear way to handle the application's state and the way it's mutated** while the user uses the application. What usually happen is that each developer implement data flows their own way resulting in an inconsistent codebase which is hard to maintain. **Beaver forces you to exhaustively handle all the cases of your flow in a unique way which can be easily understood by the everybody**.

While the code base is growing, we tend to write generic code in order not to rewrite the wheel for each feature. We also make singletons to make stateful classes easy to access. The problem is that we couple classes between each others without considering how we will be able to modularize our code later, or even test it. Beaver aims to solve this by providing **a project structure that gives a place for each classes**. Common classes belongs in the `Core` framework, feature business logic code belongs in the modules frameworks. Each module doesn't know about each other, avoiding wrong coupling. And using one state for the entire app avoids the use of singletons since accessing the application state is made easy and safe.

# Project structure

A freshly generated Beaver project is structure like so:
```
NewProject/
├── App
│   ├── AppDelegate.swift
│   ├── AppPresenter.swift
│   ├── AppReducer.swift
│   └── Info.plist
├── AppTests
│   └── Info.plist
├── Cakefile
├── Module
│   ├── Core
│   │   ├── Cakefile.rb
│   │   ├── Core
│   │   │   ├── AppAction.swift
│   │   │   ├── AppState.swift
│   │   │   ├── HomeAction.swift
│   │   │   ├── HomeState.swift
│   │   │   └── Info.plist
│   │   ├── CoreTests
│   │   │   └── Info.plist
│   │   └── Podfile.rb
│   └── Home
│       ├── Cakefile.rb
│       ├── Home
│       │   ├── HomeAction.swift
│       │   ├── HomePresenter.swift
│       │   ├── HomeReducer.swift
│       │   ├── HomeViewController.swift
│       │   └── Info.plist
│       ├── HomeTests
│       │   └── Info.plist
│       └── Podfile.rb
└── Podfile
```

- `Core` is a dynamic framework where you can find the classes that are shared between your modules.
- `Home` is a dynamic framework implementing a module.
- At the root you can find a `Podfile` and a `Cakefile`. These two configurations are reading each modules' `Podfile.rb` and `Cakefile.rb` in order generate the project `xcodeproj` and `xcworkspace` with its Pods.

# Command line tools

Beaver comes with its command line tools, which you can install like so:
```bash
$ git clone git@github.com:Beaver/BeaverScript.git
$ make build
$ make install
```

The `beaver` command permits to: 

- Create a new project:
```bash
$ beaver init --project_path . --project_name NewProject --module_names ModuleOne,ModuleTwo
```

- Add a module to an existing project:
```bash
$ beaver add module --project_path . --module_name NewModule
```

- Add an action to an existing module:
```bash
$ beaver add action --project_path . --module_name ModuleOne --action_name NewAction --action_type ui
```

# Getting started guide

## New project

Creating a new project with beaver is very simple. Follow these few steps:

1. Install the `beaver` command line tools, [xcake](https://github.com/jcampbell05/xcake) and [cocoapods](https://guides.cocoapods.org).

2. Run:
```bash
$ beaver init
```
It will to guide you to generate your project boiler plate. 

3. Go to your project directory, and run:
```bash
$ xcake make
```
It generates the project boiler plate with all the necessary `xcake` and `CocoaPods` configurations.

4. Open `App.xcworkspace`

You're all setup!

## Existing project

### Cocoapods

You install Beaver via CocoaPods by adding it to your `Podfile`:

```ruby
pod 'Beaver', :git => 'git@github.com:Beaver/Beaver.git'
```

And run `pod install`.

### Carthage

You can install Beaver via Carthage by adding the following line to your `Cartfile`:

```
github "ReSwift/ReSwift"
```
