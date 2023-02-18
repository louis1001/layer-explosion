//
//  Parallax.swift
//  
//
//  Created by Luis Gonzalez on 18/2/23.
//

import SwiftUI

struct ParallaxModifier: ViewModifier {
    var zIndex: Int
    
    @Environment(\.parallaxLevel) var parallaxLevel
    @Environment(\.parallaxOffset) var parallaxOffset
    @Environment(\.parallaxBorder) var parallaxBorder
    @Environment(\.parallaxStrength) var parallaxStrength
    
    @ViewBuilder
    func body(content: Content) -> some View {
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
    func parallaxLayer(zIndex: Int = 0) -> some View {
        self
            .modifier(ParallaxModifier(zIndex: zIndex))
    }
}
