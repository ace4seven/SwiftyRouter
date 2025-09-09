//
//  TodoDetailScreen.swift
//  DemoApp
//
//  Created by Juraj Macák on 10/09/2025.
//

import SwiftUI

struct TodoDetailScreen: View {

    let todo: Todo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Title")
                    .font(.title.bold())

                Text(todo.title)

                Text("Description")
                    .font(.title2.bold())

                Text(todo.description)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("Todo Detail")
        .toolbarTitleDisplayMode(.inline)
    }
}
