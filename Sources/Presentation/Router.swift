//
//  Router.swift
//  SwiftyRouter
//
//  Created by Juraj Macák on 04/10/2024.
//

import SwiftUI

public class Router<Destination: SwiftyRouter>: Routable {

    @Published internal var path: [Destination] = []
    @Published internal var modalDestination: Destination? = nil
    @Published internal var fullScreenCoverDestination: Destination? = nil
    @Published internal var detents: Set<PresentationDetent> = []

    /// Creates a new, empty router.
    ///
    /// The router starts with an empty navigation path and no presented modals or full-screen covers.
    public init() {}
}

// MARK: - Private

private extension Router {

    func resetModal() {
        fullScreenCoverDestination = nil
        modalDestination = nil
    }
}

// MARK: - Public

public extension Router {

    /// Pops the current navigation destination or dismisses any presented sheet/full-screen cover.
    ///
    /// - If a sheet or full-screen cover is currently presented, this method dismisses it and returns.
    /// - Otherwise, if the navigation path is not empty, it removes the last destination from the path.
    func pop() {
        defer { resetModal() }

        guard modalDestination == nil, fullScreenCoverDestination == nil else {
            return
        }

        if !path.isEmpty {
            path.removeLast()
        }
    }

    /// Pops all navigation destinations and dismisses any presented sheet or full-screen cover.
    ///
    /// After calling this, the navigation path is empty and no modal presentations remain active.
    func popToRoot() {
        path = .init()

        resetModal()
    }

    /// Pops a specific number of destinations from the navigation path and dismisses any modal presentations.
    ///
    /// - Parameter depth: The number of destinations to remove from the end of the path.
    /// - Throws: `SwiftyRouterError.invalidPopDepth` if `depth` is greater than the number of items in the path.
    func pop(to depth: Int) throws {
        guard depth <= path.count else {
            throw SwiftyRouterError.invalidPopDepth
        }
        path.removeLast(depth)

        resetModal()
    }

    /// Pops back to the first occurrence of a destination in the navigation path.
    ///
    /// If the destination exists in the path, the path is truncated to include it (and everything before it).
    /// If the destination is not found, the router pops to root.
    ///
    /// - Parameter destination: The destination to pop back to.
    func pop(to destination: Destination) {
        if let index = path.firstIndex(of: destination) {
            path = Array(path.prefix(upTo: index + 1))
        } else {
            popToRoot()
        }
    }

    /// Pushes a new destination onto the navigation path.
    ///
    /// - Parameter destination: The destination to append to the path.
    func push(_ destination: Destination) {
        path.append(destination)
    }

    /// Pushes multiple destinations onto the navigation path in order.
    ///
    /// - Parameter destinations: An array of destinations to append to the path.
    func push(_ destinations: [Destination]) {
        destinations.forEach { destination in
            push(destination)
        }
    }

    /// Presents a destination as a sheet (modal) with optional detents.
    ///
    /// - Parameters:
    ///   - destination: The destination to present as a sheet.
    ///   - detents: A set of detents controlling the sheet's height, if supported by the platform.
    func show(_ destination: Destination, detents: Set<PresentationDetent> = []) {
        self.detents = detents
        modalDestination = destination
    }

    /// Presents a destination as a full-screen cover.
    ///
    /// - Parameter destination: The destination to present as a full-screen cover.
    func fullScreenCover(_ destination: Destination) {
        fullScreenCoverDestination = destination
    }
}
