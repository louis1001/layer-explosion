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

struct ParallaxOffset: EnvironmentKey {
    static var defaultValue: CGSize = .zero
}

struct ParallaxBorder: EnvironmentKey {
    static var defaultValue: Color? = nil
}

struct ParallaxStrength: EnvironmentKey {
    static var defaultValue: Double = 1
}

extension EnvironmentValues {
    var parallaxLevel: Int {
        get { self[ParallaxLevel.self] }
        set { self[ParallaxLevel.self] = newValue }
    }
    
    var parallaxOffset: CGSize {
        get { self[ParallaxOffset.self] }
        set { self[ParallaxOffset.self] = newValue }
    }
    
    var parallaxBorder: Color? {
        get { self[ParallaxBorder.self] }
        set { self[ParallaxBorder.self] = newValue }
    }
    
    var parallaxStrength: Double {
        get { self[ParallaxStrength.self] }
        set { self[ParallaxStrength.self] = newValue }
    }
}
