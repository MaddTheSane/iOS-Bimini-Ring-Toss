//
//  Rope.swift
//  BiminiRingToss
//
//  Created by Christopher Flannagan on 8/19/17.
//  Copyright © 2017 Christopher Flannagan. All rights reserved.
//

import Foundation
import SceneKit

class Rope {
    
    let holder: SCNNode
    let rope: SCNNode
    
    init() {
        holder = SCNNode()
        
        let geometry = SCNSphere(radius: 0.1)
        geometry.materials.first?.diffuse.contents = UIColor.blue
        
        rope = SCNNode(geometry: geometry)
        rope.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        rope.physicsBody?.mass = 5.0
    }
    
    func getLink( y:Float ) -> SCNNode {        
        let geometry = SCNSphere(radius: 0.1)
        geometry.materials.first?.diffuse.contents = UIColor.green
        
        let link = SCNNode(geometry: geometry)
        link.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        link.physicsBody?.mass = 3.0
        return link
    }
}
