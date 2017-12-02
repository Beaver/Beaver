# Welcome to `Beaver` 

[![Join the chat at https://gitter.im/BeaverFramework/Lobby](https://badges.gitter.im/BeaverFramework/Lobby.svg)](https://gitter.im/BeaverFramework/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Build status](https://travis-ci.org/Beaver/Beaver.svg?branch=master)](https://travis-ci.org/Beaver/Beaver)

A framework to help you build your application fast and clean! 

# Introduction

**Beaver is a framework** which includes everything you need to create your iOS applications in Swift. It aims to set **standards** in order to make iOS development **easier, more scalable and fully testable**.

# Features

What Beaver can help you with:
- Structure your project correctly.
- Modularize your project in a scalable manner.
- Implement your features in an explicit and exhaustive manner.
- Generate boiler plate code.
- Produce a fully testable code.

On the other hand, Beaver can't help you make your code shorter by doing some obscure magic for you. Beaver is not a library solving specific problems, it is a framework guiding you to make the right choices when developing your application so it can scale and stay easy to maintain.

# Architecture

Let's see what an App built with Beaver is made of:

- At least one **Module** per feature.

- The **App State** is the data structure of the application. It contains the modules' data and global context.

- The **App Reducer** is the core logic of the application. It performs updates on the current state based on an event. It is also entirely stateless.

- The **Routing Events** are dispatched to ensure intermodule communications. It's also triggering modules' presentations and dismissals. They are the only public API of the modules.

- The **App Store** stores the app state and maintains it up to date. It also dispatches the events and state updates to its children and subscribers.

- The **App Presenter** subscribes to the app store and presents the modules based on the current app state.

And what is a module is made of:

- The **State** is a subset of the app state. It is the data structure of the module. 

- The **UI Events** are dispatched to ensure the module internal UI communications. It's basically triggering business logic on user interactions.

- The **Child Store** is the child of the app store. It holds the module's state. It is the interface to dispatch routing events to the rest of the app and ui event internally.
 
- The **Reducer** is a subset of the app reducer. It is responsible of the internal logic of the module.

- The **Presenter** subscribes to the child store and presents the view controllers based on the current state. It also dispatches routing events to interact with other modules.

- The **ViewController** subscribes to the child store state and builds the views based on the current state. It dispatches ui actions and lifecycle events.

Beaver's architecture implements the *unidirectional data flow*. The flow begins with a ui event, which is dispatched to the store. The store asks a state update to the reducer. The reducer applies the application's business logic based on the current state and the received event. The store updates the state, and propagates it thoughout the application, implying ui presentations and ui updates.

# Project structure

A freshly generated Beaver project is structure like so:
```bash
$ tree
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

- `Core` is a dynamic framework containing all the shared classes between your modules.
- `Home` is a dynamic framework containing a module implementation.
- The `Podfile` and `Cakefile` are located at the root directory. These two configurations are reading each modules' `Podfile.rb` and `Cakefile.rb` in order generate the `xcodeproj` and `xcworkspace` files.

# Show me some code

Let's write a very simple module showing a list of cells, and presenting another module when the user taps one of them.

First, our module needs to define its routing events. That's how we'll be able to interact with it. For now, let's define the `start` and `stop` actions.

```swift
public protocol HomeAction: Beaver.Action {
}

public enum HomeRoutingAction: HomeAction {
    case start
    case stop
}
```

Then, our module needs a state. We want to show movies in a list, so let's define an array of movie titles.

```swift
public struct HomeState: Beaver.State {
    public var movies: [String]?
    
    public init() {
    }
}
```

Note that these two classes are defined `public` because they need to be accessible by the rest of the app. They are built with the `Core` framework for that purpose.

The next step is to write our reducer. It will build the state with the data we need to show.

```swift
public struct HomeReducer: Beaver.ChildReducing {
    public typealias RoutingActionType = HomeRoutingAction
    public typealias UIActionType = HomeUIAction
    public typealias StateType = HomeState

    public init() {
    }

    public func handle(action: ExhaustiveAction<HomeRoutingAction, HomeUIAction>,
                       state: HomeState,
                       completion: @escaping (HomeState) -> ()) -> HomeState {
        var newState = state

        switch action {
        case .routing(.start):
            newState.movies = (0...10).map { "Movie \($0)" }
            
        case .routing(.stop):
            newState.movies = nil

        case .ui:
            break
        }
        
        return newState
    }
}
```

When starting, the `AppPresenter` will send a `start` routing event to our module, which will result in our reducer generating 10 movie titles. In the other hand, when stoping, we reset to an empty state.

The `ExhaustiveAction` permits to exhaustively write one case per action in order to make sure that no action is left unhandled.

Also note that this class is built with the `Home` framework and declared `public` so that the `AppReducer` is able to access to it from the `App` target.

Let's write our view now. The architecture of Beaver is made so the `UIViewController` is made very simple. It basically only handles the UI logic, dispatches UI events throughout the module and build the `UIView`s.

```swift
final class HomeViewController: Beaver.ViewController<HomeState, AppState, HomeUIAction>, UITableViewDataSource {
    let tableView: UITableView = ...

    override func stateDidUpdate(oldState: HomeState?,
                                 newState: HomeState,
                                 completion: @escaping () -> ()) {
        if oldState != newState {
            tableView.reloadData()
        }
        completion()
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.movies?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = state.movies?[indexPath.row].title
        
        return cell
    }
}
```

This controller basically only gets the movie titles from the state, and shows them in a table view.

Note that this class is declared `internal` and built with the `Home` module so it can't be accessed by other modules.

Now let's write our presenter, so we can actually show our view to the screen.

```swift
public final class HomePresenter: Beaver.Presenting, Beaver.ChildStoring {
    public typealias StateType = HomeState
    public typealias ParentStateType = AppState

    public let store: ChildStore<HomeState, AppState>

    public let context: Context

    public init(store: ChildStore<HomeState, AppState>,
                context: Context) {
        self.store = store
        self.context = context
    }
}

extension HomePresenter {
    public func stateDidUpdate(oldState: HomeState?,
                               newState: HomeState,
                               completion: @escaping () -> ()) {

        switch (oldState?.movies, newState.movies) {
        case (.none, .some):
            let homeController = HomeViewController(store: store)
            context.present(controller: homeController, completion: completion)

        case (.some, .none):
            context.dismiss(completion: completion)
        }
    }
}
```

The presenter is a subscriber of the store. Therefore, we can handle presentation in the `stateDidUpdate(oldState:newState:completion:)` method.

- When coming from a state without movies to a state with some movies, we know we should present our controller in order to show a list of movies.
- When coming from a state with movies to a state without movies, we dismiss the controller we just shown. Of course, this is an example, and in a real app, we would either switch to another controller, or make our controller show an empty state.

We use the context to present and dismiss our controller. `Context` is a protocol that can have different implementations of `present(controller:)` and `dismiss()`. For example `NavigationContext` know how to push and pop a controller when `ModalContext` knows how to present and dismiss a controller as a modal.

Note that this presenter is built with the `Home` module and declared `public` so it can be accessed by the `AppPresenter`.

Now, we have the ability to show a list of movies, through our `Home` module, but nothing happen yet when tapping a cell. Let's assume we have a `MovieCard` module defining the following routing actions.

```swift
public enum MovieCardRoutingAction: MovieCardAction {
    case start(title: String)
    case stop
}
```

When sending the action `start(title:)`, it would present a controller showing the movie title. To do that, let's begin by writing our module ui actions, so we can handle the tap of a cell. 

```swift
enum HomeUIAction: HomeAction {
    case didTapOnMovieCell(title: String)
}
```

Note that this enum is declared `internal` and built in the `Home` module.

Now, let's dispatch this action when the user taps a cell.

```swift
final class HomeViewController: Beaver.ViewController<HomeState, AppState, HomeUIAction>, UITableViewDataSource, UITableViewDelegate {
    ...

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movies = state.movies, movies.count > indexPath.row else {
            fatalError("State inconsticency: the selected movie does not exist in state.")
        }

        let movie = movies[indexPath.row]

        controller.dispatch(action: .didTapOnMovieCell(title: movie.title))
    }

    ...
}
```

When this action is passing through our reducer, the state needs to be mutated in a way that will let our presenter know what to do. To achieve that, let's add an attribute to our state.

```swift
public struct HomeState: Beaver.State {
    public var movies: [String]?

    public var selectedMovie: String?
    
    public init() {
    }
}
```

Now, let's make our reducer build this new state when receiving the `.didTapOnMovieCell(title:)` action.

```swift
public func handle(action: ExhaustiveAction<HomeRoutingAction, HomeUIAction>,
                   state: HomeState,
                   completion: @escaping (HomeState) -> ()) -> HomeState {
    var newState = state

    switch action {
    case .routing(.start):
        newState.movies = (0...10).map { "Movie \($0)" }
        
    case .routing(.stop):
        newState.movies = nil

    case .ui(.didTapOnMovieCell(let title)):
    	newState.selectedMovie = title
    }
    
    return newState
}
```

And finally, let's make our presenter handle this new state.

```swift
extension HomePresenter {
    public func stateDidUpdate(oldState: HomeState?,
                               newState: HomeState,
                               completion: @escaping () -> ()) {

        if oldState?.movies != newState.movies {
            switch (oldState?.movies, newState.movies) {
            case (.none, .some):
                let homeController = HomeViewController(store: store)
                context.present(controller: homeController, completion: completion)

            case (.some, .none):
                context.dismiss(completion: completion)
            }
            return
    	}

    	if oldState?.selectedMovie != newState.selectedMovie {
            switch (oldState?.selectedMovie, newState.selectedMovie) {
            case (.none, let title):
                dispatch(AppAction.start(module: MovieCardRoutingAction.start(title: title)))

            case (.some, .none):
                break
            }	        
            completion()
            return
        }
    }
}
```

# Why Beaver?

Writing an application at an early stage should be done right. In the mean time, we build applications to solve real life problems, and most often, we want to focus on these instead of architecture details. **Beaver is here to help you start your project fast, but clean** by generating for you all the boiler plate code that you need, including project's and frameworks' configurations.

The most difficult part when writing an application are the data flows. They can easily be made complex because of the product needs, but also because of the way we write our code. **MVC, MVVM or VIPER don't define a clear way to handle the application's state and the way it's mutated** while the user uses the application. What usually happens is that each developer implements data flows their own way, resulting in an inconsistent codebase, making the project hard to maintain. **Beaver forces you to exhaustively handle all the cases of your flow in a unique way which can be easily understood by any developer**.

While the code base is growing, developers tend to write generic code in order not to rewrite the wheel for each feature. They also tend to use singletons in order to access global states more easily. These two tendencies lead to strong coupling between classes and overdesign, making the whole system a lot less flexible. Beaver aims to solve this by providing **a project structure that gives a place for every classes**. Common classes belongs in the `Core` framework, feature business logic code belongs in the modules frameworks. Modules don't know about each others, avoiding wrong coupling. Beaver also removes the need of singletons by providing **a safe and easily accessible global state**.

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

## For a new project

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

4. Open `App.xcworkspace`

You're all set!

## For an existing project

### Cocoapods

You install Beaver via CocoaPods by adding it to your `Podfile`:

```ruby
pod 'Beaver', :git => 'git@github.com:Beaver/Beaver.git'
```

And run `pod install`.

### Carthage

You can install Beaver via Carthage by adding the following line to your `Cartfile`:

```
github "Beaver/Beaver"
```
