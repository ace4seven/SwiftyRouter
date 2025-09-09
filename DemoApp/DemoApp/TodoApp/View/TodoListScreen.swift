//
//  TodoListScreen.swift
//  DemoApp
//
//  Created by Juraj Macák on 10/09/2025.
//

import SwiftUI
import SwiftyRouter

struct TodoListScreen: View {

    @State private var router = Router<TodoRouter>()
    @State private var store = TodoStore()

    var body: some View {
        SwiftyRootView(router: router) {
            List {
                ForEach(store.todos, id: \.self) { todo in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(todo.title)
                            .font(.body.bold())

                        Text(todo.description)
                            .font(.footnote)
                    }
                    .onTapGesture {
                        router.push(.detail(todo: todo))
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("Todo's")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { router.show(.add, detents: [.medium, .large]) }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .environment(store)
    }
}
