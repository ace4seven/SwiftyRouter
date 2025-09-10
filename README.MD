# SwiftyRouter

A type-safe, scalable, and testable navigation framework for modern SwiftUI apps.

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://swift.org/package-manager/)

## Features

- **Type-Safe Navigation**: Leverage Swift's type system to prevent navigation errors at compile time
- **Declarative API**: Simple, SwiftUI-native navigation patterns
- **Multiple Presentation Modes**: Support for push navigation, modal sheets, and full-screen covers
- **Testable Architecture**: Built with testing in mind for reliable navigation flows
- **Lightweight**: Minimal overhead with clean, focused API
- **iOS 16+ Support**: Built for modern SwiftUI with latest navigation APIs

## Installation

### Swift Package Manager

Add SwiftyRouter to your project through Xcode:

1. Go to **File** -> **Add Package Dependencies**
2. Enter the repository URL: `https://github.com/ace4seven/swifty-router`
3. Click **Add Package**

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ace4seven/swifty-router", from: "0.1.0")
]
```

## Quick Start

### 1. Define Your Routes

Create an enum that conforms to `SwiftyRouter` to define your app's destinations:

```swift
import SwiftyRouter
import SwiftUI

enum AppRouter: SwiftyRouter {

    case home
    case profile(userId: String)
    case settings
    case detail(item: Item)
    
    func viewForDestination() -> some View {
        switch self {
        case .home:
            HomeView()
        case .profile(let userId):
            ProfileView(userId: userId)
        case .settings:
            SettingsView()
        case .detail(let item):
            DetailView(item: item)
        }
    }
}
```

### 2. Setup Your Root View

Wrap your root view with `SwiftyRootView` or use the convenience modifier:

```swift
struct ContentView: View {
    private let router = Router<AppRouter>()
    
    var body: some View {
        HomeView()
            .swiftyRootView(router: router)
    }
}
```

### 3. Navigate in Your Views

Use the `@EnvironmentRouter` property wrapper to access the router in any view:

```swift
struct HomeView: View {
    @EnvironmentRouter<AppRouter> private var router
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome Home!")
                .font(.title)
            
            Button("View Profile") {
                router.push(.profile(userId: "123"))
            }
            
            Button("Show Settings") {
                router.show(.settings, detents: [.medium, .large])
            }
        }
        .navigationTitle("Home")
    }
}
```

## Core Concepts

### Router

The `Router` class is the heart of SwiftyRouter. It manages navigation state and provides methods for different types of navigation:

```swift
let router = Router<AppRoute>()

// Push navigation (NavigationStack)
router.push(.detail(item: item))
router.push([.profile(userId: "123"), .settings]) // Push multiple

// Modal presentation
router.show(.settings) // Default detents
router.show(.profile(userId: "123"), detents: [.medium, .large])

// Full-screen presentation
router.fullScreenCover(.detail(item: item))

// Navigation control
router.pop() // Pop current or dismiss modal
router.popToRoot() // Return to root
router.pop(to: 2) // Pop specific depth
router.pop(to: .home) // Pop to specific destination
```

### SwiftyRouter Protocol

Your route enum must conform to `SwiftyRouter`:

```swift
public protocol SwiftyRouter: Hashable, Identifiable {
    associatedtype Content: View
    
    @MainActor @ViewBuilder 
    func viewForDestination() -> Content
}
```

Key benefits:
- **Hashable**: Enables route comparison and storage in collections
- **Identifiable**: Automatic ID generation for SwiftUI lists and navigation
- **ViewBuilder**: Support for conditional and multi-view construction

### Environment Integration

SwiftyRouter integrates seamlessly with SwiftUI's environment system:

```swift
// Inject router into environment
.swiftyRootView(router: router)

// Access router in any child view
@EnvironmentRouter private var router
```

## Advanced Usage

### Complex Route Parameters

Handle complex navigation scenarios with associated values:

```swift
enum AppRoute: SwiftyRouter {
    case productList(category: Category)
    case productDetail(product: Product, relatedProducts: [Product])
    case checkout(cart: ShoppingCart, paymentMethod: PaymentMethod?)
    
    func viewForDestination() -> some View {
        switch self {
        case .productList(let category):
            ProductListView(category: category)
        case .productDetail(let product, let related):
            ProductDetailView(product: product, relatedProducts: related)
        case .checkout(let cart, let paymentMethod):
            CheckoutView(cart: cart, paymentMethod: paymentMethod)
        }
    }
}
```

### Conditional Navigation

`viewForDestination` is ready for conditional view creation:

```swift
enum UserRoute: SwiftyRouter {
    case dashboard
    case adminPanel
    
    func viewForDestination() -> some View {
        switch self {
        case .dashboard:
            DashboardView()
        case .adminPanel:
            if UserSession.shared.isAdmin {
                AdminPanelView()
            } else {
                UnauthorizedView()
            }
        }
    }
}
```

### Sheet Detents

Control modal presentation size with detents:

```swift
// Small modal
router.show(.quickAction, detents: [.medium])

// Flexible sizing
router.show(.details, detents: [.medium, .large])

// System default
router.show(.settings) // Uses system defaults
```

### Deep Navigation

Push multiple destinations to create deep navigation stacks:

```swift
// Navigate directly to a deep state
router.push([
    .category(id: "electronics"),
    .product(id: "iphone-15"),
    .reviews
])
```

### Error Handling

SwiftyRouter provides clear error handling for invalid operations:

```swift
do {
    try router.pop(to: 5) // More than available
} catch SwiftyRouterError.invalidPopDepth {
    print("Cannot pop that many levels")
}
```

## Example: Todo App

Here's a complete example showing SwiftyRouter in action:

### Route Definition

```swift
enum TodoRoute: SwiftyRouter {
    case add
    case detail(todo: Todo)
    
    func viewForDestination() -> some View {
        switch self {
        case .add:
            AddTodoView()
        case .detail(let todo):
            TodoDetailView(todo: todo)
        }
    }
}
```

### List View with Navigation

```swift
struct TodoListView: View {
    @State private var router = Router<TodoRoute>()
    @State private var store = TodoStore()
    
    var body: some View {
        SwiftyRootView(router: router) {
            List(store.todos, id: \.self) { todo in
                VStack(alignment: .leading) {
                    Text(todo.title).font(.headline)
                    Text(todo.description).font(.caption)
                }
                .onTapGesture {
                    router.push(.detail(todo: todo))
                }
            }
            .navigationTitle("Todos")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        router.show(.add, detents: [.medium, .large])
                    }
                }
            }
        }
        .environment(store)
    }
}
```

### Add Todo Modal

```swift
struct AddTodoView: View {
    @Environment(TodoStore.self) private var store
    @EnvironmentRouter private var router
    @State private var title = ""
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
            }
            .navigationTitle("Add Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { router.pop() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.addTodo(Todo(title: title, description: description))
                        router.pop()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
```

## Testing

SwiftyRouter is built with testing in mind. Here are some testing patterns:

### Basic Navigation Tests

```swift
import Testing
@testable import SwiftyRouter

@Test
func testPushNavigation() {
    let router = Router<AppRoute>()
    
    #expect(router.path.isEmpty)
    
    router.push(.home)
    #expect(router.path.count == 1)
    #expect(router.path.last == .home)
}

@Test 
func testPopNavigation() {
    let router = Router<AppRoute>()
    router.push(.home)
    router.push(.settings)
    
    router.pop()
    #expect(router.path.count == 1)
    #expect(router.path.last == .home)
}

@Test
func testInvalidPopDepth() {
    let router = Router<AppRoute>()
    router.push(.home)
    
    #expect(throws: SwiftyRouterError.invalidPopDepth) {
        try router.pop(to: 5)
    }
}
```

### Mock Routes for Testing

```swift
enum MockRoute: SwiftyRouter {
    case screen1, screen2, screen3
    
    func viewForDestination() -> some View {
        Text("Mock View")
    }
}

@Test
func testComplexNavigation() {
    let router = Router<MockRoute>()
    
    // Test deep navigation
    router.push([.screen1, .screen2, .screen3])
    #expect(router.path.count == 3)
    
    // Test pop to specific destination
    router.pop(to: .screen1)
    #expect(router.path.last == .screen1)
}
```

## API Reference

### Router Methods

| Method | Description |
|--------|-------------|
| `push(_:)` | Push a destination onto the navigation stack |
| `push(_:)` | Push multiple destinations in sequence |
| `pop()` | Pop current destination or dismiss modal |
| `pop(to:)` | Pop to specific depth or destination |
| `popToRoot()` | Return to root of navigation stack |
| `show(_:detents:)` | Present destination as modal sheet |
| `fullScreenCover(_:)` | Present destination as full-screen cover |

### Property Wrappers

| Wrapper | Description |
|---------|-------------|
| `@EnvironmentRouter` | Access router from SwiftUI environment |

### View Modifiers

| Modifier | Description |
|----------|-------------|
| `.swiftyRootView(router:)` | Setup navigation root with router |

### Error Types

| Error | Description |
|-------|-------------|
| `SwiftyRouterError.invalidPopDepth` | Attempted to pop more levels than available |

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

SwiftyRouter is available under the MIT license.