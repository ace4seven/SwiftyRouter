//
//  SwiftyRouterConfiguration.swift
//  SwiftyRouter
//
//  Created by Juraj Macák on 10/09/2025.
//

import OSLog

public class SwiftyRouterConfiguration {

    /// Global flag that enables or disables SwiftyRouter's debug logging.
    ///
    /// When `true`, calls to `logDebug(_:)` will emit messages using `OSLog` — but onlyJ
    /// in builds compiled with the `DEBUG` flag. Set this to `false` to silence router logs
    /// during development or in unit tests.
    ///
    /// Default: `true`.
    ///
    /// Example:
    /// ```swift
    /// SwiftyRouterConfiguration.logDebug = false
    /// ```
    ///
    /// - Important: In Release builds (without `DEBUG`), logging is compiled out regardless
    ///              of this value.
    public static var logDebug: Bool = true
}

func logDebug(_ message: String) {
#if DEBUG
    guard SwiftyRouterConfiguration.logDebug else { return }

    Logger(subsystem: "SwiftyRouter", category: "Navigation").debug("\(message)")
#endif
}

