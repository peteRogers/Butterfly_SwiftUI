//
//  ARModel.swift
//  Tap To Place RealityKit Tutorial
//
//  Created by Cole Dennis on 11/21/22.
//

import Foundation
import RealityKit
import ARKit
import Combine
import simd

class ARModel {
	var arView : RKBaseView
	var anchors = [UUID: AnchorEntity]()
	var baseEntity:Entity!
	var subscribes = Set<AnyCancellable>()
	let animator = Animator()
	static let butterflyQuery = EntityQuery(where: .has(MotionComponent.self))
	
	init() {
		arView = RKBaseView(frame: .zero)
		arView.setup()
		animator.loadAnimations()
		baseEntity = try? Entity.load(named: "bxFlying")
		addEntity()
		arView.scene.subscribe(to: SceneEvents.Update.self) { event in
			self.updateFrame(deltaTime: event.deltaTime)
		}.store(in: &subscribes)
		
		
	}
	
	func updateFrame(deltaTime: TimeInterval){
		arView.scene.performQuery(Self.butterflyQuery).forEach  { entity in
			if var mc:MotionComponent = entity.components[MotionComponent.self]{
				if(mc.state == .flyingUp){
					mc.flyingControl.updateUpPosition(deltaTime: deltaTime)
					//print("updating up")
				}
				if(mc.state == .flyingDown){
					mc.flyingControl.updateDownPosition(deltaTime: deltaTime)
					
				}
				if(mc.state == .takingOff){
					mc.flyingControl.doTakeOff()
				}
				if(mc.state == .landing){
					mc.landedControl.startLanded()
				}
				
				if(mc.state == .landed){
					//mc.landedControl.updatePosition(deltaTime: deltaTime)
							
					}
				}
//				if(mc.state == .landed){
//					mc.deinitFlyingControl()
//					if mc.landedControl != nil{
//						
//						//mc.landedControl?.xoxo
//					}else{
//						mc.setLandedControl(entity: entity, arView: arView)
//						entity.components[MotionComponent.self] = mc
//					}
//					
//				}
				
			
		}
	}
	
	
	func addEntity(){
		let testAnchor = AnchorEntity(world: .zero)
		let hopper = baseEntity.clone(recursive: true)
	
		do{
			let orange = try getUSDZModel(name: "orange.usdz")
			let ninetyDegreesInRadians = -90 * (Float.pi / 180)

			// Create a quaternion for 90-degree rotation around the X-axis
			let rotationQuaternion = simd_quatf(angle: ninetyDegreesInRadians, axis: [1, 0, 0])

			// Apply the rotation to the entity
			orange.transform.rotation = rotationQuaternion
			orange.position.y = -0.5
//orange.transform.scale = [0.02,0.02, 0.02]
			testAnchor.addChild(orange)
		}catch{
			
		}
		
		
		hopper.transform.scale = SIMD3(x: 0.3, y: 0.3, z: 0.3)
		hopper.transform.translation.y += 8
		hopper.position.y = 7
		hopper.playAnimation(animator.getAnimationByName(name: "fly"), transitionDuration: 0, blendLayerOffset: 0, separateAnimatedValue: false, startsPaused: false)
		let fc = FlyingMotionControl(entity: hopper, arView: arView)
		let lc = LandedMotionControl(entity: hopper, arView: arView)
		hopper.components.set(
			MotionComponent(groundTarget: SIMD3(x: 0, y: 0, z: 0),
							skyTarget: SIMD3(x: 4, y: 10, z: 0),
							animator: animator,
							state: .flyingUp,
							flying: fc,
							landing: lc
							
						   )
		)
		
		
		testAnchor.addChild(hopper)
		self.arView.scene.addAnchor(testAnchor)
	}
	
	func getUSDZModel(name:String) throws -> Entity  {
		guard let model = try? ModelEntity.load(named: name)
		else{
			print("error loading")
			throw RealityError.modelLoadingError
		}
		let translationVector = SIMD3<Float>(x: 0, y: 0.0, z: 0.0)
		model.transform.translation += translationVector
	
		return model
	}
}
