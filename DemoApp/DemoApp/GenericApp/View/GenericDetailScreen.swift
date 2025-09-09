//
//  DetailScreen.swift
//  DemoApp
//
//  Created by Juraj Macák on 09/09/2025.
//

import SwiftUI
import SwiftyRouter

struct GenericDetailScreen: View {

    @EnvironmentRouter<GenericRouter> private var router

    let id: Int

    var body: some View {
        VStack(spacing: 16) {
            Button("Go to Detail: \(id + 1)") {
                router.push(.detail(id: id + 1))
            }

            Button("Show Modal") {
                router.show(.modal(id: 1))
            }

            Button("Show Detent Modal") {
                router.show(.modal(id: 1), detents: [.medium, .large])
            }

            Button("Pop to Root") {
                router.popToRoot()
            }
        }
        .navigationTitle("Detail Screen \(id)")
    }
}
