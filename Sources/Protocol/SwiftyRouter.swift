//
//  SwiftyRouter.swift
//  SwiftyRouter
//
//  Created by Juraj Macák on 04/10/2024.
//

import SwiftUI

/// A protocol that produces a SwiftUI `View` for a routing destination.
///
/// Conform to `SwiftyRouter` when you want a lightweight, hashable value
/// to represent a destination in your navigation or routing system, and be able
/// to build the corresponding view on demand.
///
/// Requirements:
/// - Conformers must be `Hashable` to support identity and usage in sets/dictionaries.
/// - Conformers are `Identifiable` by default via their hash value (see extension).
/// - Implement `viewForDestination()` to construct the view for this destination.
///
/// Example:
/// ```swift
/// enum AppRoute: SwiftyRouter {
///     case home
///     case details(id: UUID)
///
///     @ViewBuilder
///     func viewForDestination() -> some View {
///         switch self {
///         case .home:
///             HomeView()
///         case .details(let id):
///             DetailView(id: id)
///         }
///     }
/// }
/// ```
public protocol SwiftyRouter: Hashable, Identifiable {

    /// The type of view produced for this destination.
    associatedtype Content: View

    /// Builds the SwiftUI view associated with this destination.
    ///
    /// This method is executed on the main actor and supports `@ViewBuilder`
    /// composition, enabling conditional and multi-view construction.
    ///
    /// - Returns: The view to present for this destination.
    @MainActor @ViewBuilder func viewForDestination() -> Content
}

public extension SwiftyRouter {

    /// A default identifier derived from the instance's hash value.
    ///
    /// This provides a stable identity within a single process run suitable
    /// for SwiftUI lists and navigation. Note that hash values are not stable
    /// across launches and should not be persisted.
    var id: Int { self.hashValue }
}
