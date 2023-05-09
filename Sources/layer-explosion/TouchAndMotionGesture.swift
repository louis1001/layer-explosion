import SwiftUI

extension View {

    func parallaxTouchAndMotionGesture(motionStrength: Double = 0.5, touchStrength: Double = 0.3) -> some View {
        self
            .contentShape(Rectangle())
            .parallaxLayer()
            .modifier(ParallaxMotionGesture(strength: motionStrength))
            .modifier(ParallaxTouchGesture(strength: touchStrength))
    }
}
