//
//  File.swift
//  SwiftyRouter
//
//  Created by Juraj Macák on 04/10/2024.
//

import SwiftUI

internal extension Router {

    func binding<T>(for keyPath: ReferenceWritableKeyPath<Router, T?>) -> Binding<T?> where T: Identifiable {
        Binding(
            get: { self[keyPath: keyPath] },
            set: { self[keyPath: keyPath] = $0 }
        )
    }

    func binding<T>(for keyPath: ReferenceWritableKeyPath<Router, T>) -> Binding<T> {
        Binding(
            get: { self[keyPath: keyPath] },
            set: { self[keyPath: keyPath] = $0 }
        )
    }
}
