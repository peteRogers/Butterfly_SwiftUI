//
//  HoppingAnimationControl.swift
//  Butterfly_SwiftUI
//
//  Created by Peter Rogers on 07/03/2024.
//

import Foundation
import RealityKit
import ARKit
import Combine
import simd

class LandedMotionControl{

	var entity: Entity
	var subscriptions = Set<AnyCancellable>()
	var arView:ARView
	var takeOffScheduler:Scheduler?
	
	init(entity: Entity, arView: ARView){
		self.entity = entity
		self.arView = arView
		
	}
	
	deinit{
		print("From landed deinit")
		takeOffScheduler?.cancelTask()
	}
	
	func startLanded(){
		
		if var mc:MotionComponent = entity.components[MotionComponent.self]{
			mc.setState(state: .landed)
			mc.setAnimation(animation: mc.animator.setAnimation(entity: entity, name: "land", trans: 0.1))
			self.entity.components[MotionComponent.self] = mc
			arView.scene.subscribe(to: AnimationEvents.PlaybackCompleted.self, on: entity) {event in
				if event.playbackController == mc.animation {
					mc.setAnimation(animation: mc.animator.setAnimation(entity: self.entity, name: "idle", trans: 0.3))
					mc.animation?.speed = 0.2
					self.entity.components[MotionComponent.self] = mc
					print("idle animation running")
				}
			}.store(in: &subscriptions)
		}
		print("scheduler task")
		takeOffScheduler?.cancelTask()
		takeOffScheduler = Scheduler()
		takeOffScheduler?.scheduleTask(after: 5) {
			self.launchTakeOff()
		}
			
	}
	
	func forceTakeOff(){
		takeOffScheduler?.cancelTask()
	}
	
	func launchTakeOff(){
		if var mc:MotionComponent = entity.components[MotionComponent.self]{
			mc.setState(state: .takingOff)
			entity.components[MotionComponent.self] = mc
			//mc.setAnimation(animation: mc.animator.setAnimation(entity: entity, name: "takeOff", trans: 0.3))
		}
			
//			
	}
	
	func updatePosition(deltaTime: TimeInterval){
//		if isLanded == false{
//			isLanded = true
//			startLanded()
//		}
	}
	
//	func updatePosition(deltaTime: TimeInterval){
//		
//		if(isHopping == false && waitingToHop <= 0){
//			isHopping = true
//	
//		
//		
//			
//			print("from here")
//			if var mc:MotionComponent = entity.components[MotionComponent.self]{
//				//mc.setAnimationState(state: .hopping)
//				self.entity.components[MotionComponent.self] = mc
//				mc.setAnimation(animation: mc.animator.setAnimation(entity: entity, name: "takeOff", trans: 0.3))
//				arView.scene.subscribe(to: AnimationEvents.PlaybackCompleted.self, on: entity) {event in
//					if event.playbackController == mc.animation {
////mc.setAnimationState(state: .landed)
//						mc.setAnimation(animation: mc.animator.setAnimation(entity: self.entity, name: "land", trans: 0.3))
//						self.entity.components[MotionComponent.self] = mc
//						self.waitingToHop = 250
//						self.isHopping = false
//						
//						
//					}
//				}.store(in: &subscriptions)
//			}
//		}else{
//			waitingToHop -= 1
//		}
//		
//	}
	
	func moveTowards(targetPosition: SIMD3<Float>, from currentPosition: SIMD3<Float>, speed: Float, deltaTime: TimeInterval) -> SIMD3<Float> {
		let vectorToTarget = targetPosition - currentPosition
		let distanceToTarget = simd_length(vectorToTarget)
		
		// Check if we are close enough to consider as arrived
		if distanceToTarget < 0.001 {
			return targetPosition
		}
		
		let directionToTarget = vectorToTarget / distanceToTarget
		let movementThisStep = min(distanceToTarget, speed * Float(deltaTime))
		
		return currentPosition + directionToTarget * movementThisStep
	}

	
}
