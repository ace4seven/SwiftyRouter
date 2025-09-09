//
//  AddTodoScreen.swift
//  DemoApp
//
//  Created by Juraj Macák on 10/09/2025.
//

import SwiftUI
import SwiftyRouter

struct AddTodoScreen: View {


    @Environment(TodoStore.self) private var store
    @EnvironmentRouter<TodoRouter> private var router
    @State private var title: String = ""
    @State private var description: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Add Todo")
                    .font(.headline.bold())

                VStack(alignment: .leading, spacing: 8) {
                    Text("Title")
                        .font(.footnote.bold())
                    TextField("Enter title ...", text: $title)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.footnote.bold())
                    TextField("Enter description ...", text: $description)
                }

                Button("Add Todo") {
                    if !title.isEmpty {
                        store.addTodo(Todo(title: title, description: description))
                        router.pop()
                    }
                }
                .disabled(title.isEmpty)
            }
            .padding(16)
        }
    }
}
