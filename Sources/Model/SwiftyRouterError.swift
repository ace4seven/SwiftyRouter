//
//  SwiftyRouterError.swift
//  SwiftyRouter
//
//  Created by Juraj Macák on 04/10/2024.
//

import Foundation

/// A namespace for errors that can be thrown by the SwiftyRouter package.
///
/// Use these errors to understand and handle failures that occur during
/// navigation operations (e.g., pushing, popping, presenting).
public enum SwiftyRouterError: Error {

    /// The requested pop operation used an invalid depth.
    ///
    /// This typically occurs when attempting to pop more screens than are currently
    /// available on the navigation stack, or when a non-positive depth is provided.
    ///
    /// Example:
    /// - If the stack contains 2 screens and you attempt to pop 3, this error is thrown.
    /// - If a depth of 0 or a negative number is provided, this error can also be thrown.
    case invalidPopDepth

    // TODO: Add Additional Errors
}
