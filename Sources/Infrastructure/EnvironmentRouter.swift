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
    @EnvironmentObject private var router: Router<R>

    public var wrappedValue: Router<R> {
        return router
    }

    /// Default initializer. Usually created implicitly by SwiftUI.
    public init() {}
}

