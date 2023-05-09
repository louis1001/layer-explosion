// https://github.com/louis1001/layer-explosion?ref=iosexample.com

import SwiftUI

struct ParallaxModifier: ViewModifier {
    var zIndex: Int
    var direction:Double
    
    @Environment(\.parallaxLevel) var parallaxLevel
    @Environment(\.parallaxOffsetTouch) var parallaxOffsetTouch
    @Environment(\.parallaxOffsetMotion) var parallaxOffsetMotion
    @Environment(\.parallaxBorder) var parallaxBorder
    @Environment(\.parallaxTouchStrength) var parallaxTouchStrength
    @Environment(\.parallaxMotionStrength) var parallaxMotionStrength
    
    @ViewBuilder
    func body(content: Content) -> some View {
        
        let actualLevel = parallaxLevel + zIndex
        let offsetDamp = 0.2 * ((parallaxTouchStrength + parallaxMotionStrength) / 2)
        
        let content = Group {
            if let parallaxBorder {
                content
                    .border(parallaxBorder)
            } else {
                content
            }
        }
        
        let rotationDampened = CGSize(
            width: (parallaxOffsetMotion.width * CGFloat(parallaxMotionStrength)) + (parallaxOffsetTouch.width * CGFloat(parallaxTouchStrength)),
            height: (parallaxOffsetMotion.height * CGFloat(parallaxMotionStrength)) + (parallaxOffsetTouch.height * CGFloat(parallaxTouchStrength))
        )
        
        let result = content
            .environment(\.parallaxLevel, actualLevel + 1)
            .offset(
                x: offsetDamp * (parallaxOffsetMotion.width + parallaxOffsetTouch.width) * CGFloat(actualLevel) * direction,
                y: offsetDamp * (parallaxOffsetMotion.height + parallaxOffsetTouch.height) * CGFloat(actualLevel) * direction // FIXME: Z-index offsetting
            )
        
        if actualLevel == 0 {
            let perspective = 0.5
            
            result
            /*.rotation3DEffect(
                Angle.degrees(rotationDampened.width * 0.2),
                axis: (0,1,0),
                perspective: perspective
            )*/
            .rotation3DEffect(
                Angle.degrees((-rotationDampened.height+rotationDampened.width) * 0.2),
                axis: (1,1,0),
                perspective: perspective
            )
        } else {
            result
        }
    }
}

extension View {
    func parallaxLayer(zIndex: Int = 0, invertMotion:Bool=false) -> some View {
        self
            .modifier(ParallaxModifier(zIndex: zIndex, direction:invertMotion == true ? -1.0 : 1.0))
    }
}
