//
//  DashboardModalScreen.swift
//  DemoApp
//
//  Created by Juraj Macák on 09/09/2025.
//

import SwiftUI
import SwiftyRouter

struct GenericModalScreen: View {

    let id: Int

    @State private var router = Router<GenericRouter>()
    @EnvironmentRouter<GenericRouter> private var parentRouter

    var body: some View {
        SwiftyRootView(router: router) {
            VStack(spacing: 16) {
                Button("Pop Modal") {
                    parentRouter.pop()
                }

                Button("Show Modal") {
                    router.show(.modal(id: id + 1))
                }

                Button("Show Full Screen Modal") {
                    router.fullScreenCover(.modal(id: id + 1))
                }

                Button("Show Detent Modal") {
                    router.show(.modal(id: id + 1), detents: [.medium, .large])
                }

                Button("Go to Detail 1") {
                    router.push(.detail(id: 1))
                }
            }
            .navigationTitle("Modal Presentation \(id)")
        }
    }
}
