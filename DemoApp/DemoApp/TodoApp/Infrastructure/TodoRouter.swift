//
//  TodoRouter.swift
//  DemoApp
//
//  Created by Juraj Macák on 10/09/2025.
//

import SwiftyRouter
import SwiftUI

enum TodoRouter: SwiftyRouter {

    case add
    case detail(todo: Todo)

    func viewForDestination() -> some View {
        switch self {
        case .add:
            AddTodoScreen()

        case .detail(let todo):
            TodoDetailScreen(todo: todo)
        }
    }
}
