//
//  TodoStore.swift
//  DemoApp
//
//  Created by Juraj Macák on 10/09/2025.
//

import SwiftUI

@Observable final class TodoStore {

    var todos: [Todo] = []

    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
}
