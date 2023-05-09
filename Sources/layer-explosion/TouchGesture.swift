//
//  TouchGesture.swift
//
//
//  Created by Luis Gonzalez on 18/2/23.
//

import SwiftUI

struct ParallaxTouchGesture: ViewModifier {
    var strength: Double
    
    @State private var gestureOffset = CGSize.zero
    
    func body(content: Content) -> some View {
        content
            .environment(\.parallaxOffsetTouch, gestureOffset)
            .environment(\.parallaxTouchStrength, strength)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        gestureOffset = value.translation
                    }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            gestureOffset = .zero
                        }
                    }
            )
    }
}

extension View {
    func parallaxTouchGesture(strength: Double = 1) -> some View {
        self
            .contentShape(Rectangle())
            .parallaxLayer()
            .modifier(ParallaxTouchGesture(strength: strength))
    }
}
