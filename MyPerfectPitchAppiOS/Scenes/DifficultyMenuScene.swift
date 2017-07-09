import SpriteKit
import GameplayKit

class DifficultyMenuScene: SKScene {
	
	//MARK: Properties

	var mode : String?
    
    private var title : SKLabelNode?
	private var subtitle : SKLabelNode?
	private var easy : SKLabelNode?
	private var normal : SKLabelNode?
	private var hard : SKLabelNode?
	private var lunatic : SKLabelNode?
	private var menu : SKLabelNode?
	
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.title = self.childNode(withName: "//title") as? SKLabelNode
		self.subtitle = self.childNode(withName: "//subtitle") as? SKLabelNode
		self.easy = self.childNode(withName: "//easy") as? SKLabelNode
		self.normal = self.childNode(withName: "//normal") as? SKLabelNode
		self.hard = self.childNode(withName: "//hard") as? SKLabelNode
		self.lunatic = self.childNode(withName: "//lunatic") as? SKLabelNode
		self.menu = self.childNode(withName: "//return") as? SKLabelNode
		
		if let titleText = self.mode {
			print(titleText)
			self.title?.text = titleText
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
		
		if let label = self.subtitle {
			label.alpha = 0.0
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.2),
				SKAction.fadeIn(withDuration: 1.0)
			]))
		}
		
		if let label = self.easy {
			label.alpha = 0.0
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.4),
				SKAction.fadeIn(withDuration: 1.0)
			]))
		}
		
		if let label = self.normal {
			label.alpha = 0.0
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.6),
				SKAction.fadeIn(withDuration: 1.0)
			]))
		}
		
		if let label = self.hard {
			label.alpha = 0.0
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.8),
				SKAction.fadeIn(withDuration: 1.0)
			]))
		}
		
		if let label = self.lunatic {
			label.alpha = 0.0
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 1.0),
				SKAction.fadeIn(withDuration: 1.0)
			]))
		}

		if let label = self.menu {
			label.alpha = 0.0
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 1.2),
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
		
		if let label = self.subtitle {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.2),
				SKAction.fadeOut(withDuration: 1.0)
			]))
		}
		
		if let label = self.easy {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.4),
				SKAction.fadeOut(withDuration: 1.0)
			]))
		}
		
		if let label = self.normal {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.6),
				SKAction.fadeOut(withDuration: 1.0)
			]))
		}
		
		if let label = self.hard {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.8),
				SKAction.fadeOut(withDuration: 1.0)
			]))
		}
		
		if let label = self.lunatic {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 1.0),
				SKAction.fadeOut(withDuration: 1.0)
			]))
		}

		if let label = self.menu {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 1.2),
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
			case "easy":
				goToQuestionScene("Easy")
				break
			case "normal":
				goToQuestionScene("Normal")
				break
			case "hard":
				goToQuestionScene("Hard")
				break
			case "lunatic":
				goToQuestionScene("Lunatic")
				break
			case "return":
				goToStartMenuScene()
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
	
	private func goToQuestionScene(_ difficulty : String) {
		if let scene = SKScene(fileNamed: "QuestionScene") as? QuestionScene {
			scene.score = 0
			scene.difficulty = difficulty
			
			// Set the scale mode to scale to fit the window
			scene.scaleMode = .aspectFill
			
			dismissAnimation {
				// Present the scene
				self.view?.presentScene(scene)
			}
		}
	}
}
