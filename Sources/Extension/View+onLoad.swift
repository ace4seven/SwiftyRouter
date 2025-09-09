//
//  View+onLoad.swift
//  SwiftyRouter
//
//  Created by Juraj Macák on 10/09/2025.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {

    @State private var didLoad = false
    let action: (() -> Void)

    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action()
            }
        }
    }

}

extension View {

    func onLoad(perform action: @escaping () -> Void) -> some View {
        modifier(ViewDidLoadModifier(action: action))
    }
}
