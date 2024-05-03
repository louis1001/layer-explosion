//
//  HoverGesture.swift
//
//
//  Created by Luis Gonzalez on 3/5/24.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct ParallaxHoverGesture: ViewModifier {
    var strength: Double
    
    @State private var contentSize: CGSize = .zero
    @State private var rotationOffset = CGSize.zero
    
    public func body(content: Content) -> some View {
        content
            .rectReader(id: "hover-frame", in: .local) { rect in
                contentSize = rect.size
            }
            .onContinuousHover { phase in
                switch phase {
                case .active(let location):
                    if contentSize.width.isZero || contentSize.height.isZero {
                        rotationOffset = .zero
                        return
                    }
                    
//                    let rotationWidth = ((location.x - (contentSize.width/2)) / contentSize.width) * 2
//                    let rotationHeight = ((location.y - (contentSize.height/2)) / contentSize.height) * 2
                    
                    rotationOffset = CGSize(
                        width: location.x - contentSize.width/2,
                        height: location.y - contentSize.height/2
                    )
                case .ended:
                    withAnimation {
                        rotationOffset = .zero
                    }
                }
            }
            .environment(\.parallaxOffset, rotationOffset)
            .environment(\.parallaxStrength, strength)
            .onTapGesture { // TODO: TEMPORARY. JUST FOR TESTING
                rotationOffset = .zero
            }
    }
}

extension View {
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
    @available(watchOS, unavailable)
    public func parallaxHoverGesture(strength: Double = 1) -> some View {
        self
            .contentShape(Rectangle())
            .parallaxLayer()
            .modifier(ParallaxHoverGesture(strength: strength))
    }
}
