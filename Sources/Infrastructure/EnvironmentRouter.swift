//
//  RouterPropertyWrapper.swift
//  iosApp
//
//  Created by Juraj Macák on 09/09/2025.
//

import Foundation
import SwiftUI

/// A lightweight property wrapper to read a type-safe `Router` from the SwiftUI environment.
///
/// Use it in your views to access a router that was injected higher in the hierarchy:
/// ```swift
/// @EnvironmentRouter<AppViewFactory> private var router
/// ```
///
/// If no `Router<R>` is found, the app will crash with a clear message to help you fix the setup.
@propertyWrapper
public struct EnvironmentRouter<R: SwiftyRouter>: DynamicProperty {

    /// The environment-backed optional router.
    @Environment(Router<R>.self) private var router: Router<R>?

    /// The non-optional router value.
    ///
    /// Triggers a `fatalError` if the router has not been injected into the environment.
    public var wrappedValue: Router<R> {
        guard let router else {
            fatalError(
                "EnvironmentRouter<\(R.self)> is not available. " +
                "No Router<\(R.self)> was found in the SwiftUI environment. " +
                "Inject a router at or above this view, e.g.: " +
                ".environment(Router<\(R.self)>.self, routerInstance)"
            )
        }

        return router
    }

    /// Default initializer. Usually created implicitly by SwiftUI.
    public init() {}
}

