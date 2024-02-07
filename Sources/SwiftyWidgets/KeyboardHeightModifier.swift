//
//  KeyboardHeightModifier.swift
//  PodTest
//
//  Created by Ali Raza on 01/02/2024.
//

import SwiftUI

@available(iOS 13.0,*)
public struct KeyboardHeightModifier: ViewModifier {
    @State private var currentHeight: CGFloat = 0

    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, self.currentHeight)
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                        self.currentHeight = 1
                    }

                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                        self.currentHeight = 0
                    }
                }
        }
    }
}
