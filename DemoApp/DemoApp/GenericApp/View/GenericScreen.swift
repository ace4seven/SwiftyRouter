//
//  DashboardScreen.swift
//  DemoApp
//
//  Created by Juraj Macák on 09/09/2025.
//

import SwiftUI
import SwiftyRouter

struct GenericScreen: View {

    private let genericRouter = Router<GenericRouter>()

    var body: some View {
        VStack(spacing: 16) {
            Button("Go to Detail 1") {
                genericRouter.push(.detail(id: 1))
            }
        }
        .navigationTitle("Generic")
        .swiftyRootView(router: genericRouter)
    }
}
