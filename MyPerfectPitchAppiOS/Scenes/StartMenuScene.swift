import SpriteKit
import GameplayKit

class StartMenuScene: SKScene {
    
	private var title : SKLabelNode?
	private var training : SKLabelNode?
	private var test : SKLabelNode?
	private var vs : SKLabelNode?
	
	private var spinnyNode : SKShapeNode?
	
    override func didMove(to view: SKView) {
        
        // Get label nodes from scene and store it for use later
        self.title = self.childNode(withName: "//title") as? SKLabelNode
		self.training = self.childNode(withName: "//training") as? SKLabelNode
		self.test = self.childNode(withName: "//test") as? SKLabelNode
		self.vs = self.childNode(withName: "//vs") as? SKLabelNode
		
        if let label = self.title {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }

		if let label = self.training {
			label.alpha = 0.0
			label.run(SKAction.fadeIn(withDuration: 2.0))
		}

		if let label = self.test {
			label.alpha = 0.0
			label.run(SKAction.fadeIn(withDuration: 2.0))
		}

		if let label = self.vs {
			label.alpha = 0.0
			label.run(SKAction.fadeIn(withDuration: 2.0))
		}
		
		// Create shape node to use during mouse interaction
		let w = (self.size.width + self.size.height) * 0.05
		self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
		
		if let spinnyNode = self.spinnyNode {
			spinnyNode.lineWidth = 2.5
			
			spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
			spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
			                                  SKAction.fadeOut(withDuration: 0.5),
			                                  SKAction.removeFromParent()]))
		}
	}
	
	
	func touchDown(atPoint pos : CGPoint) {
		if let n = self.spinnyNode?.copy() as! SKShapeNode? {
			n.position = pos
			n.strokeColor = SKColor.green
			self.addChild(n)
		}
	}
	
	func touchMoved(toPoint pos : CGPoint) {
		if let n = self.spinnyNode?.copy() as! SKShapeNode? {
			n.position = pos
			n.strokeColor = SKColor.blue
			self.addChild(n)
		}
	}
	
	func touchUp(atPoint pos : CGPoint) {
		if let n = self.spinnyNode?.copy() as! SKShapeNode? {
			n.position = pos
			n.strokeColor = SKColor.red
			self.addChild(n)
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchDown(atPoint: t.location(in: self)) }
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchUp(atPoint: t.location(in: self)) }
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchUp(atPoint: t.location(in: self)) }
	}
	
	
	override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
	}
}
