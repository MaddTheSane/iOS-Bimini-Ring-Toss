import UIKit
import SceneKit

class GameViewController: UIViewController {
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()
        setupLight()
        spawnNodes()
    }
    
    func setupView() {
        scnView = self.view as! SCNView
        scnView.showsStatistics = true
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
    }
    
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
    }
    
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: -3, z: 10)
        //cameraNode.eulerAngles = SCNVector3(-0.2, 0, 0); if we want to tilt down
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func setupLight() {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scnScene.rootNode.addChildNode(ambientLightNode)
    }
    
    func spawnNodes() {
        let ringObject = Ring()
        let ropeObject = Rope()
        
        /** Setup ceiling and floor **/
        let ceilingObject = Ceiling()
        let floorObject = Floor()
        let anchor = SCNPhysicsBallSocketJoint(bodyA: ropeObject.rope.physicsBody!, anchorA: SCNVector3( -0.05, -0.05, -0.05), bodyB: ceilingObject.ceiling.physicsBody!, anchorB: SCNVector3(0, -0.1, 0))
        scnScene.physicsWorld.addBehavior(anchor)
        
        /** Generate our rope links **/
        var previousLink = ropeObject.rope
        var links = [SCNNode]()
        for cnt in stride(from: Float(0.0), to: 2.0, by: 0.1) {
            let link = ropeObject.getLink( y: cnt )
            links.append(link)
            
            let joint = SCNPhysicsBallSocketJoint(
                bodyA: link.physicsBody!,
                anchorA: SCNVector3(x: -0.05, y: -0.05, z: -0.05),
                bodyB: previousLink.physicsBody!,
                anchorB: SCNVector3(x: 0.05, y: 0.05, z: 0.05)
            )
            scnScene.physicsWorld.addBehavior(joint)
            
            previousLink = link
        }
    
        /** Attach Ring to end of Rope **/
        let joint = SCNPhysicsBallSocketJoint(
            bodyA: ringObject.ring.physicsBody!,
            anchorA: SCNVector3(x: 0.6 , y: 0, z: 0),
            bodyB: previousLink.physicsBody!,
            anchorB: SCNVector3(x: 0.05, y: 0.05, z: 0.05)
        )
        scnScene.physicsWorld.addBehavior(joint)
        
        /** Add All Nodes To Scene **/
        scnScene.rootNode.addChildNode(ropeObject.holder)
        ropeObject.holder.addChildNode(ceilingObject.ceiling)
        ropeObject.holder.addChildNode(ropeObject.rope)
        links.forEach { link in
            ropeObject.holder.addChildNode( link )
        }
        scnScene.rootNode.addChildNode(ringObject.ring)
        scnScene.rootNode.addChildNode(floorObject.floor)
    }
}
