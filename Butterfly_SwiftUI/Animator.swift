//
//  File.swift
//  SparrowFly
//
//  Created by Peter Rogers on 28/06/2023.
//

import Foundation
import RealityKit

final class Animator{
    
    var animations:[Animation] = []
    
    func loadAnimations(){
        guard let fly = try? Entity.load(named: "bxFlying")else{
            fatalError("no fly")
        }
		
		animations.append(Animation(skel: fly.availableAnimations.first!.repeat(), name: "fly"))
		
        guard let land = try? Entity.load(named: "bxLanding")else{
            fatalError("no land")
        }
        animations.append(Animation(skel: land.availableAnimations.first!, name: "land"))
       
        guard let takeoff = try? Entity.load(named: "bxTakeOff")else{
            fatalError("no takeoff")
        }
        animations.append(Animation(skel: takeoff.availableAnimations.first!, name: "takeOff"))
        
        guard let idle = try? Entity.load(named: "bxIdle")else{
            fatalError("no IdleLookAround")
        }
        animations.append(Animation(skel: idle.availableAnimations.first!.repeat(), name: "idle"))
    }
    
	func setAnimation(entity:Entity, name:String, trans: TimeInterval)->AnimationPlaybackController{
		print(name)
        let anim = animations.filter{$0.name == name}[0].skel
        
        return entity.playAnimation(anim, transitionDuration: trans, blendLayerOffset: 0, separateAnimatedValue: false, startsPaused: false)
    }
    
    func getAnimationByName(name:String)->AnimationResource{
        let anim = animations.filter{$0.name == name}
        return anim[0].skel
    }
}

struct Animation{
    let skel:AnimationResource
    let name:String
}

