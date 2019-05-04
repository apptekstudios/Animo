//
//  CALayer+Animo.swift
//  Animo
//
//  Copyright © 2016 eureka, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import QuartzCore

// MARK: - CALayer

public extension CALayer {
    
    
    // MARK: Public
	func runAnimation(_ animation: LayerAnimation, forKey key: String = UUID().uuidString, completion: (() -> Void)? = nil) -> AnimationToken {
    let token = AnimationToken(key: key, animationLayer: self, onCompletion: completion)
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            token.onCompletion?() //Implicit capture of token
        })
        self.add(animation.copyObject(), forKey: key)
        CATransaction.commit()
        return token
    }
    
	func pauseAnimations() {
        
        self.speed = 0
        self.timeOffset = self.convertTime(CACurrentMediaTime(), from: nil)
    }
    
	func resumeAnimations() {
        
        self.resumeAnimationsAtSpeed(1)
    }
    
	func resumeAnimationsAtSpeed(_ newSpeed: Float) {
        
        let pausedTime = self.timeOffset
        
        guard pausedTime != 0 else {
            
            let currentTime = CACurrentMediaTime()
            self.timeOffset = self.convertTime(currentTime, from: nil)
            self.beginTime = currentTime
            self.speed = newSpeed
            return
        }
        
        self.speed = newSpeed
        self.timeOffset = 0
        self.beginTime = 0
        
        let elapsedTime = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = elapsedTime
    }
    
	func runTransition(_ type: Transition = .fade, duration: TimeInterval = 0, timingMode: TimingMode = .linear, options: Options = Options(fillMode: CAMediaTimingFillMode.removed, removedOnCompletion: true)) {
        
        let transition = CATransition()
        type.applyTo(transition)
        transition.duration = duration
        transition.applyOptions(options)
        
        self.add(transition, forKey: nil)
    }
}
