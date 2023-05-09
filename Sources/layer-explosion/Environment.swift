//
//  Environment.swift
//
//
//  Created by Luis Gonzalez on 18/2/23.
//

import SwiftUI

struct ParallaxLevel: EnvironmentKey {
    static var defaultValue: Int = 0
}

struct ParallaxOffsetMotion: EnvironmentKey {
    static var defaultValue: CGSize = .zero
}

struct ParallaxOffsetTouch: EnvironmentKey {
    static var defaultValue: CGSize = .zero
}

struct ParallaxBorder: EnvironmentKey {
    static var defaultValue: Color? = nil
}

struct ParallaxTouchStrength: EnvironmentKey {
    static var defaultValue: Double = 1
}

struct ParallaxMotionStrength: EnvironmentKey {
    static var defaultValue: Double = 1
}

extension EnvironmentValues {
    var parallaxLevel: Int {
        get { self[ParallaxLevel.self] }
        set { self[ParallaxLevel.self] = newValue }
    }
    
    var parallaxOffsetMotion: CGSize {
        get { self[ParallaxOffsetMotion.self] }
        set { self[ParallaxOffsetMotion.self] = newValue }
    }
    
    var parallaxOffsetTouch: CGSize {
        get { self[ParallaxOffsetTouch.self] }
        set { self[ParallaxOffsetTouch.self] = newValue }
    }
    
    var parallaxBorder: Color? {
        get { self[ParallaxBorder.self] }
        set { self[ParallaxBorder.self] = newValue }
    }
    
    var parallaxTouchStrength: Double {
        get { self[ParallaxTouchStrength.self] }
        set { self[ParallaxTouchStrength.self] = newValue }
    }
    var parallaxMotionStrength: Double {
        get { self[ParallaxMotionStrength.self] }
        set { self[ParallaxMotionStrength.self] = newValue }
    }
}
