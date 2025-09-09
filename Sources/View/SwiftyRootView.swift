//
//  File.swift
//  SwiftyRouter
//
//  Created by Juraj Macák on 04/10/2024.
//

import SwiftUI
import OSLog

public struct SwiftyRootView<Factory: SwiftyRouter, Content: View>: View {

    @Bindable public var router: Router<Factory>
    public var content: () -> Content

    public init(router: Router<Factory>, @ViewBuilder content: @escaping () -> Content) {
        self.router = router
        self.content = content
    }

    public var body: some View {
        NavigationStack(path: $router.path) {
            content()
                .navigationDestination(
                    for: Factory.self,
                    destination: { factory in
                        factory.viewForDestination()
                            .id(factory)
                            .onAppear { logDebug("🧭 Push • Destination=\(String(describing: factory))") }
                    }
                )
        }
        .onLoad() {
            router.popToRoot()
            logDebug("🚀 Router Load • Name=\(String(describing: router))")
        }
        .sheet(item: router.binding(for: \.modalDestination)) { factory in
            factory.viewForDestination()
                .presentationDetents(router.detents)
                .onAppear {
                    let detentsText = router.detents.isEmpty ? "default" : String(describing: router.detents)
                    logDebug("🗂️ Sheet • Destination=\(String(describing: factory)); detents=\(detentsText)")
                }
        }
        .fullScreenCover(item: router.binding(for: \.fullScreenCoverDestination)) { factory in
            factory.viewForDestination()
                .onAppear { logDebug("🖼️ FullScreenCover • Destination=\(String(describing: factory))") }
        }
        .environment(router)
    }
}

public extension View {

    /// Wraps the current view in a `SwiftyRootView` that manages navigation, sheets, and full‑screen covers using the provided router.
    ///
    /// Use this convenience to enable SwiftyRouter‑driven navigation for a feature by hosting your view inside a `NavigationStack` and injecting the router into the environment.
    ///
    /// - Parameter router: A `Router` that controls the navigation path, sheet and full‑screen cover destinations, and sheet detents.
    /// - Returns: A view that hosts a `NavigationStack` and injects the router into the environment.
    /// - Note: The root view automatically pops to its root when it disappears.
    /// - SeeAlso: ``SwiftyRootView``
    ///
    /// ### Example
    /// ```swift
    /// struct AppRoot: View {
    ///     @State var router = Router<AppFactory>()
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .swiftyRootView(router: router)
    ///     }
    /// }
    /// ```
    public func swiftyRootView<F: SwiftyRouter>(
        router: Router<F>
    ) -> some View {
        SwiftyRootView(router: router) {
            self
        }
    }
}
