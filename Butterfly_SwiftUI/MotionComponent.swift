//
//  Components.swift
//  BirdLanding
//
//  Created by Peter Rogers on 05/07/2023.
//

import Foundation

import RealityKit

struct MotionComponent: RealityKit.Component {
    
    private(set) var state: ButterflyState
    private(set) var onscreen: entityVisibility?
    private(set) var groundTarget: SIMD3<Float>
	private(set) var skyTarget: SIMD3<Float>
    private(set) var flyingControl: FlyingMotionControl
	private(set) var landedControl: LandedMotionControl
    private(set) var animation: AnimationPlaybackController?
    private(set) var animator: Animator
	
	init(groundTarget: SIMD3<Float>, skyTarget: SIMD3<Float>, animator: Animator, state: ButterflyState, flying: FlyingMotionControl, landing: LandedMotionControl ){
		self.state = state
		self.animator = animator
		self.groundTarget = groundTarget
		self.landedControl = landing
		self.flyingControl = flying
		self.skyTarget = skyTarget
		
	}
   
    mutating func setState(state:ButterflyState){
        self.state = state
    }
    
    mutating func setSkyPosition(tp: SIMD3<Float>){
        self.skyTarget = tp
    }
	
	mutating func setGroundPosition(tp: SIMD3<Float>){
		self.groundTarget = tp
	}

    mutating func setAnimation(animation:AnimationPlaybackController){
        self.animation = animation
    }
    
    mutating func setScreenState(state:entityVisibility){
        self.onscreen = state
    }
}

enum ButterflyState{
	case flyingUp
	case flyingDown
	case landed
	case takingOff
	case landing
}

enum entityVisibility{
    case onscreen
    case offscreen
    case appearing
    case leaving
}

enum RealityError: Error {
	case modelLoadingError
	
}
