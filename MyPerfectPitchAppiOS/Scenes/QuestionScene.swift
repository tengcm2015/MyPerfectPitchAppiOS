import SpriteKit
import GameplayKit

class Keyboard {
	
	//MARK: Properties
	
	private var node : SKNode
	private var C : SKNode?
	private var D : SKNode?
	private var E : SKNode?
	private var F : SKNode?
	private var G : SKNode?
	private var A : SKNode?
	private var B : SKNode?
	private var Cs : SKNode?
	private var Ds : SKNode?
	private var Fs : SKNode?
	private var Gs : SKNode?
	private var As : SKNode?
	
	init (_ node: SKNode) {
		self.node = node
		self.C = node.childNode(withName: "//C")
		self.D = node.childNode(withName: "//D")
		self.E = node.childNode(withName: "//E")
		self.F = node.childNode(withName: "//F")
		self.G = node.childNode(withName: "//G")
		self.A = node.childNode(withName: "//A")
		self.B = node.childNode(withName: "//B")
		self.Cs = node.childNode(withName: "//C#")
		self.Ds = node.childNode(withName: "//D#")
		self.Fs = node.childNode(withName: "//F#")
		self.Gs = node.childNode(withName: "//G#")
		self.As = node.childNode(withName: "//A#")
	}
	
	func hide () {
		node.isHidden = true
	}
	
	func show () {
		node.isHidden = false
	}
	
	func appearAnimation () {
		for child in node.children {
			child.alpha = 0.0
			child.run(SKAction.fadeIn(withDuration: 1.0))
		}
	}
	
	func dismissAnimation () {
		for child in node.children {
			child.run(SKAction.fadeOut(withDuration: 1.0))
		}
	}
}

class PauseMenu {
	
	//MARK: Properties
	
	private var node : SKNode
	private var retry : SKLabelNode?
	private var difficulty : SKLabelNode?
	private var mainMenu : SKLabelNode?
	private var resume : SKLabelNode?
	
	init (_ node: SKNode) {
		self.node = node
		self.retry		= node.childNode(withName: "//retry"	 ) as? SKLabelNode
		self.difficulty = node.childNode(withName: "//difficulty") as? SKLabelNode
		self.mainMenu	= node.childNode(withName: "//mainMenu"	 ) as? SKLabelNode
		self.resume		= node.childNode(withName: "//resume"	 ) as? SKLabelNode
	}
	
	func hide () {
		node.isHidden = true
	}
	
	func show () {
		node.isHidden = false
	}
	
	func appearAnimation () {
		for child in node.children {
			child.alpha = 0.0
			child.run(SKAction.fadeIn(withDuration: 1.0))
		}
	}
	
	func dismissAnimation () {
		for child in node.children {
			child.run(SKAction.fadeOut(withDuration: 1.0))
		}
	}
}

class QuestionScene: SKScene {
	
	//MARK: Properties
	
	var score : Int = 0
	var difficulty : String?
	
	private var title : SKLabelNode?
	private var status : SKLabelNode?
	private var confirm : SKLabelNode?
	private var difficultyNode : SKLabelNode?
	private var quit : SKLabelNode?
	private var keyboard : Keyboard?
	private var pauseMenu : PauseMenu?
	
	private var spinnyNode : SKShapeNode?
	
	override func didMove(to view: SKView) {
		
		// Get label nodes from scene and store it for use later
		self.title			= self.childNode(withName: "//title"	 ) as? SKLabelNode
		self.status			= self.childNode(withName: "//status"	 ) as? SKLabelNode
		self.confirm		= self.childNode(withName: "//confirm"	 ) as? SKLabelNode
		self.difficultyNode = self.childNode(withName: "//difficulty") as? SKLabelNode
		self.quit			= self.childNode(withName: "//quit"		 ) as? SKLabelNode
		self.keyboard		= Keyboard (self.childNode(withName: "//keyboard")!)
		self.pauseMenu		= PauseMenu(self.childNode(withName: "//pauseMenu")!)
		
		if pauseMenu != nil {
			pauseMenu?.hide()
		}

		if difficultyNode != nil {
			difficultyNode?.text = difficulty
		}
		
		appearAnimation()
		
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

		if self.keyboard != nil {
			self.keyboard?.appearAnimation()
		}
		
		if let label = self.status {
			label.alpha = 0.0
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.2),
				SKAction.fadeIn(withDuration: 1.0)
			]))
		}
		
		if let label = self.confirm {
			label.alpha = 0.0
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.4),
				SKAction.fadeIn(withDuration: 1.0)
			]))
		}
		
		if let label = self.difficultyNode {
			label.alpha = 0.0
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.6),
				SKAction.fadeIn(withDuration: 1.0)
			]))
		}
		
		if let label = self.quit {
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

		if self.keyboard != nil {
			self.keyboard?.dismissAnimation()
		}
		
		if let label = self.status {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.2),
				SKAction.fadeOut(withDuration: 1.0)
			]))
		}
		
		if let label = self.confirm {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.4),
				SKAction.fadeOut(withDuration: 1.0)
			]))
		}
		
		if let label = self.difficultyNode {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.6),
				SKAction.fadeOut(withDuration: 1.0)
			]))
		}
		
		if let label = self.quit {
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
			case "confirm":
				score += 1
				break
			case "quit":
				goToResultScene("Well done!")
				break
			case "keyboard":
				break
			default:
				break
			}
		}
	}
	
	private func goToStartMenuScene() {
		if let scene = SKScene(fileNamed: "StartMenuScene") as? StartMenuScene {
			// Set the scale mode to scale to fit the window
			scene.scaleMode = .aspectFill
			
			dismissAnimation {
				// Present the scene
				self.view?.presentScene(scene)
			}
		}
	}
	
	private func goToResultScene(_ message : String) {
		if let scene = SKScene(fileNamed: "ResultScene") as? ResultScene {
			scene.score = self.score
			scene.message = message
			scene.difficulty = self.difficulty!
			
			// Set the scale mode to scale to fit the window
			scene.scaleMode = .aspectFill
			
			dismissAnimation {
				// Present the scene
				self.view?.presentScene(scene)
			}
		}
	}
}
