//
//  TouchGesture.swift
//  
//
//  Created by Luis Gonzalez on 18/2/23.
//

import SwiftUI

public struct ParallaxTouchGesture: ViewModifier {
    public var strength: Double
    @State private var gestureOffset = CGSize.zero
    
    public func body(content: Content) -> some View {
        content
            .environment(\.parallaxOffset, gestureOffset)
            .environment(\.parallaxStrength, strength)
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
    public func parallaxTouchGesture(strength: Double = 1) -> some View {
        self
            .contentShape(Rectangle())
            .parallaxLayer()
            .modifier(ParallaxTouchGesture(strength: strength))
    }
}
