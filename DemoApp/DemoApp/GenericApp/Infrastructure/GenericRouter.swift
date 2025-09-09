//
//  Routes.swift
//  DemoApp
//
//  Created by Juraj Macák on 09/09/2025.
//

import SwiftUI
import SwiftyRouter

enum GenericRouter: SwiftyRouter {

    case detail(id: Int)
    case modal(id: Int)

    func viewForDestination() -> some View {
        switch self {
        case .detail(let id):
            GenericDetailScreen(id: id)

        case .modal(let id):
            GenericModalScreen(id: id)
        }
    }
}
