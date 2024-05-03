//
//  Parallax.swift
//  
//
//  Created by Luis Gonzalez on 18/2/23.
//

import SwiftUI

public struct ParallaxModifier: ViewModifier {
    public var zIndex: Int
    
    @Environment(\.parallaxLevel) private var parallaxLevel
    @Environment(\.parallaxOffset) private var parallaxOffset
    @Environment(\.parallaxBorder) private var parallaxBorder
    @Environment(\.parallaxStrength) private var parallaxStrength
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        let actualLevel = parallaxLevel + zIndex
        let offsetDamp = 0.2 * parallaxStrength
        
        let content = Group {
            if let parallaxBorder {
                content
                    .border(parallaxBorder)
            } else {
                content
            }
        }
        
        let rotationDampened = CGSize(
            width: parallaxOffset.width * CGFloat(parallaxStrength),
            height: parallaxOffset.height * CGFloat(parallaxStrength)
        )
        
        let result = content
            .environment(\.parallaxLevel, actualLevel + 1)
            .offset(
                x: offsetDamp * parallaxOffset.width * CGFloat(actualLevel),
                y: offsetDamp * parallaxOffset.height * CGFloat(actualLevel) // FIXME: Z-index offsetting
            )
        
        if actualLevel == 0 {
            let perspective = 0.5
            
            result
            .rotation3DEffect(
                Angle.degrees(rotationDampened.width * 0.2),
                axis: (x: 0, y: 1, z: 0),
                perspective: perspective
            )
            .rotation3DEffect(
                Angle.degrees(-rotationDampened.height * 0.2),
                axis: (x: 1, y: 0, z: 0),
                perspective: perspective
            )
        } else {
            result
        }
    }
}

extension View {
    public func parallaxLayer(zIndex: Int = 0) -> some View {
        self
            .modifier(ParallaxModifier(zIndex: zIndex))
    }
}
