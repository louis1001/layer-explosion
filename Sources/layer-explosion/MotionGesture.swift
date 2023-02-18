//
//  MotionGesture.swift
//  
//
//  Created by Luis Gonzalez on 18/2/23.
//

import SwiftUI
import CoreMotion
import Combine

fileprivate class MotionObserver {
    static let shared = MotionObserver()
    
    let motionManager: CMMotionManager = {
        let motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 1 / 15
        
        return motionManager
    }()
    
    let passthrough: PassthroughSubject<CMGyroData?, Never> = PassthroughSubject()
    
    private typealias MotionCallback = (CMGyroData?)->Void
    
    var subscriberCount = 0
    
    func startUpdates() {
        motionManager.startGyroUpdates(to: .main) {[unowned self] data, _  in
            guard subscriberCount > 0 else {
                motionManager.stopGyroUpdates()
                return
            }
            
            passthrough.send(data)
        }
    }
    
    func configure(_ manager: MotionManager) {
        if subscriberCount == 0 {
            startUpdates()
        }
        
        subscriberCount += 1
        
        manager.subscription = passthrough
            .receive(on: RunLoop.main)
            .sink {[weak manager] data in
                guard let rotation = data?.rotationRate else { return }
                manager?.rotationOffset.width += rotation.y
                manager?.rotationOffset.height += rotation.x
            }
        
    }
    
    func removeSubscriber(_ manager: MotionManager) {
        subscriberCount -= 1
        if subscriberCount <= 0 {
            motionManager.stopGyroUpdates()
        }
        
        manager.subscription = nil
    }
}

class MotionManager: ObservableObject {
    @Published var rotationOffset: CGSize = .zero
    
    fileprivate var subscription: AnyCancellable?
    
    init() {
        MotionObserver.shared.configure(self)
    }
    
    deinit {
        MotionObserver.shared.removeSubscriber(self)
    }
}

struct ParallaxMotionGesture: ViewModifier {
    var strength: Double
    @StateObject private var motion = MotionManager()
    
    func body(content: Content) -> some View {
        content
            .environment(\.parallaxOffset, motion.rotationOffset)
            .environment(\.parallaxStrength, strength)
            .onTapGesture { // TODO: TEMPORARY. JUST FOR TESTING
                motion.rotationOffset = .zero
            }
    }
}

extension View {
    func parallaxMotionGesture(strength: Double = 1) -> some View {
        self
            .contentShape(Rectangle())
            .parallaxLayer()
            .modifier(ParallaxMotionGesture(strength: strength))
    }
}
