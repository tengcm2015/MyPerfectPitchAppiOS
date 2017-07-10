import SpriteKit
import GameplayKit

class SettingsScene: SKScene {

	//MARK: Properties

	private var title : SKLabelNode?
	private var training : SKLabelNode?
	private var test : SKLabelNode?
	private var vs : SKLabelNode?

	private var spinnyNode : SKShapeNode?

	override func didMove(to view: SKView) {

		// Get label nodes from scene and store it for use later
		self.title 	  = self.childNode(withName: "//title"	 ) as? SKLabelNode
		self.training = self.childNode(withName: "//training") as? SKLabelNode
		self.test 	  = self.childNode(withName: "//test"	 ) as? SKLabelNode
		self.vs 	  = self.childNode(withName: "//vs"		 ) as? SKLabelNode

		appearAnimation()

		// Create shape node to use during mouse interaction
		let w = (self.size.width + self.size.height) * 0.05
		self.spinnyNode = SKShapeNode.init(
			rectOf: CGSize.init(width: w, height: w),
			cornerRadius: w * 0.3
		)

		if let spinnyNode = self.spinnyNode {
			spinnyNode.lineWidth = 2.5

			spinnyNode.run(SKAction.repeatForever(
				SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)
			))
			spinnyNode.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.5),
				SKAction.fadeOut(withDuration: 0.5),
				SKAction.removeFromParent()
			]))
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

	//MARK: Private Methods

	private func appearAnimation() {
		appearAnimation {
			print("appearAnimation() done.")
		}
	}

	private func appearAnimation(_ completion: @escaping () -> Void) {
		if let label = self.title {
			label.alpha = 0.0
			label.run(SKAction.fadeIn(withDuration: 1.0))
		}

		if let label = self.training {
			label.alpha = 0.0
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.2),
				SKAction.fadeIn(withDuration: 1.0)
			]))
		}

		if let label = self.test {
			label.alpha = 0.0
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.4),
				SKAction.fadeIn(withDuration: 1.0)
			]))
		}

		if let label = self.vs {
			label.alpha = 0.0
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.6),
				SKAction.fadeIn(withDuration: 1.0)
			]), completion: completion)
		}
	}

	private func dismissAnimation() {
		dismissAnimation {
			print("dismissAnimation() done.")
		}
	}

	private func dismissAnimation(_ completion: @escaping () -> Void) {
		if let label = self.title {
			label.run(SKAction.fadeOut(withDuration: 1.0))
		}

		if let label = self.training {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.2),
				SKAction.fadeOut(withDuration: 1.0)
			]))
		}

		if let label = self.test {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.4),
				SKAction.fadeOut(withDuration: 1.0)
			]))
		}

		if let label = self.vs {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.6),
				SKAction.fadeOut(withDuration: 1.0)
			]), completion: completion)
		}
	}

	private func touchDown(atPoint pos : CGPoint) {
		if let n = self.spinnyNode?.copy() as! SKShapeNode? {
			n.position = pos
			n.strokeColor = SKColor.green
			self.addChild(n)
		}
	}

	private func touchMoved(toPoint pos : CGPoint) {
		if let n = self.spinnyNode?.copy() as! SKShapeNode? {
			n.position = pos
			n.strokeColor = SKColor.blue
			self.addChild(n)
		}
	}

	private func touchUp(atPoint pos : CGPoint) {
		if let n = self.spinnyNode?.copy() as! SKShapeNode? {
			n.position = pos
			n.strokeColor = SKColor.red
			self.addChild(n)
		}

		let node = self.nodes(at: pos).last
		if let name = node?.name {
			switch name {
			case "training":
				goToDiffcultyScene("Training")
				break
			case "test":
				goToDiffcultyScene("Test")
				break
			case "vs":
				goToDiffcultyScene("Versus")
				break
			default:
				break
			}
		}
	}

	private func goToDiffcultyScene(_ mode : String) {
		if let scene = SKScene(fileNamed: "DifficultyMenuScene") as? DifficultyMenuScene {
			scene.mode = mode

			// Set the scale mode to scale to fit the window
			scene.scaleMode = .aspectFill

			dismissAnimation {
				// Present the scene
				self.view?.presentScene(scene)
			}
		}
	}
}
