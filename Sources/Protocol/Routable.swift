//
//  Routable.swift
//  SwiftyRouter
//
//  Created by Juraj Macák on 04/10/2024.
//

import SwiftUI

/// A protocol that defines a minimal routing interface for driving navigation and presentation
/// on the main actor. Conforming types are expected to manage a navigation stack (push/pop),
/// as well as modal and full‑screen presentations.
///
/// The associated `Factory` describes the destination type used by the router. Typically,
/// this is a value that knows how to build a SwiftUI `View` (via `SwiftyRouter`),
/// allowing the router to remain decoupled from concrete view implementations.
protocol Routable: AnyObject, Observable {

    associatedtype Factory: SwiftyRouter

    /// The destination that should be presented as a modal sheet.
    ///
    /// Set this to a non-`nil` value to present a sheet; set it back to `nil` to dismiss.
    var modalDestination: Factory? { get set }

    /// The destination that should be presented as a full‑screen cover.
    ///
    /// Set this to a non-`nil` value to present a full‑screen cover; set it back to `nil` to dismiss.
    var fullScreenCoverDestination: Factory? { get set }

    /// Pushes a single destination onto the navigation stack.
    ///
    /// - Parameter destination: The destination to push.
    func push(_ destination: Factory)

    /// Pushes multiple destinations onto the navigation stack in order.
    ///
    /// The first element in `destinations` will be pushed first, followed by subsequent elements.
    ///
    /// - Parameter destinations: The ordered list of destinations to push.
    func push(_ destinations: [Factory])

    /// Pops the top destination from the navigation stack.
    ///
    /// If the stack is already at the root (or empty), this is a no‑op.
    func pop()

    /// Pops back a specific number of levels in the navigation stack.
    ///
    /// - Parameter depth: The number of levels to pop. A value of `1` is equivalent to `pop()`.
    /// - Throws: An error if `depth` is invalid for the current stack (e.g., negative, zero,
    ///           or greater than the current number of pushable levels).
    func pop(to depth: Int) throws

    /// Pops back through the navigation stack until the given destination is at the top.
    ///
    /// If multiple instances of the destination exist in the stack, behavior typically targets
    /// the nearest one below the current top. If the destination cannot be found, implementations
    /// may choose to do nothing.
    ///
    /// - Parameter destination: The destination to pop to.
    func pop(to destination: Factory)

    /// Pops all destinations and returns to the root of the navigation stack.
    func popToRoot()

    /// Presents a destination as a modal sheet.
    ///
    /// Implementations typically set `modalDestination` to the provided value to trigger the sheet
    /// and apply the given `detents` using `View.presentationDetents(_:)`.
    ///
    /// - Parameter destination: The destination to present in a sheet.
    /// - Parameter detents: The set of allowed sizes for the sheet, expressed as `PresentationDetent`
    ///   values (for example, `.medium`, `.large`, or custom). Implementations may store and apply
    ///   these detents when presenting the sheet. If empty, the system’s default detents are used.
    func show(_ destination: Factory, detents: Set<PresentationDetent>)

    /// Presents a destination as a full‑screen cover.
    ///
    /// Implementations typically set `fullScreenCoverDestination` to the provided value
    /// to trigger the presentation.
    ///
    /// - Parameter destination: The destination to present as a full‑screen cover.
    func fullScreenCover(_ destination: Factory)
}
