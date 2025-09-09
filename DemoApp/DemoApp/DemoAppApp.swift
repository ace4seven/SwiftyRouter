//
//  DemoAppApp.swift
//  DemoApp
//
//  Created by Juraj Macák on 09/09/2025.
//

import SwiftUI
import SwiftyRouter

@main
struct DemoAppApp: App {

    var body: some Scene {
        WindowGroup {
            TabView {
                TodoListScreen()
                    .tabItem {
                        Label("Todo List", systemImage: "checkmark")
                    }

                GenericScreen()
                    .tabItem {
                        Label("Generic", systemImage: "repeat")
                    }
            }
        }
    }
}
