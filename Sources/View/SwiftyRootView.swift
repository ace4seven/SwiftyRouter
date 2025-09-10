//
//  File.swift
//  SwiftyRouter
//
//  Created by Juraj Macák on 04/10/2024.
//

import SwiftUI
import OSLog

public struct SwiftyRootView<Destination: SwiftyRouter, Content: View>: View {

    @ObservedObject var router: Router<Destination>
    let content: () -> Content

    public init(router: Router<Destination>, @ViewBuilder content: @escaping () -> Content) {
        self.router = router
        self.content = content
    }

    public var body: some View {
        NavigationStack(path: $router.path) {
            content()
                .navigationDestination(
                    for: Destination.self,
                    destination: { destination in
                        destination.viewForDestination()
                            .id(destination)
                            .onAppear { logDebug("🧭 Push • Destination=\(String(describing: destination))") }
                    }
                )
        }
        .onLoad() {
            router.popToRoot()
            logDebug("🚀 Router Load • Name=\(String(describing: router))")
        }
        .sheet(item: router.binding(for: \.modalDestination)) { destination in
            destination.viewForDestination()
                .presentationDetents(router.detents)
                .onAppear {
                    let detentsText = router.detents.isEmpty ? "default" : String(describing: router.detents)
                    logDebug("🗂️ Sheet • Destination=\(String(describing: destination)); detents=\(detentsText)")
                }
        }
        .fullScreenCover(item: router.binding(for: \.fullScreenCoverDestination)) { destination in
            destination.viewForDestination()
                .onAppear { logDebug("🖼️ FullScreenCover • Destination=\(String(describing: destination))") }
        }
        .environmentObject(router)
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
    ///     @State var router = Router<AppRouter>()
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .swiftyRootView(router: router)
    ///     }
    /// }
    /// ```
    public func swiftyRootView<Destination: SwiftyRouter>(
        router: Router<Destination>
    ) -> some View {
        SwiftyRootView(router: router) {
            self
        }
    }
}
