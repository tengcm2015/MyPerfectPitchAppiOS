import SpriteKit
import GameplayKit

class SpeedTestResultScene: MasterScene {

	//MARK: Properties

	var score : Int?
	var message : String?

	private var title          : SKLabelNode?
	private var scoreNode      : SKLabelNode?
	private var messageNode    : SKLabelNode?
	private var retry          : SKLabelNode?
	private var menu           : SKLabelNode?

	override func didMove(to view: SKView) {
		super.didMove(to: view)

		// Get label nodes from scene and store it for use later
		self.title       = self.childNode(withName: "//title"      ) as? SKLabelNode
		self.scoreNode   = self.childNode(withName: "//score"      ) as? SKLabelNode
		self.messageNode = self.childNode(withName: "//message"    ) as? SKLabelNode
		self.retry       = self.childNode(withName: "//retry"      ) as? SKLabelNode
		self.menu        = self.childNode(withName: "//return"     ) as? SKLabelNode

		if let score = self.score {
			self.scoreNode?.text = String(score)
		}
		if let message = self.message {
			self.messageNode?.text = message
		}

		appearAnimation()

	}

	override func handleClick(_ nodes: [SKNode]) {
		let node = nodes.last
		if let name = node?.name {
			switch name {
			case "retry":
				goToSpeedTestScene()

			case "return":
				goToStartMenuScene()

			default:
				print(name)
			}
		}
	}

	//MARK: Scene Transitions

	private func goToScene(_ scene : SKScene) {
		// Set the scale mode to scale to fit the window
		scene.scaleMode = .aspectFill
		dismissAnimation {
			// Present the scene
			self.view?.presentScene(scene)
		}
	}

	private func goToStartMenuScene() {
		let scene = SKScene(fileNamed: "StartMenuScene") as! StartMenuScene
		self.goToScene(scene)
	}

	private func goToSpeedTestScene() {
		let scene = SKScene(fileNamed: "SpeedTestScene") as! SpeedTestScene
		scene.score = 0
		self.goToScene(scene)
	}

	//MARK: Animations

	private func appearAnimation() {
		appearAnimation {
			print("appearAnimation() done.")
		}
	}

	private func appearAnimation(_ completion: @escaping () -> Void) {

		self.colorScheme = .dark

		let sortedChildren = self.children.sorted(by: {$0.position.y > $1.position.y})
		for (i, child) in sortedChildren.enumerated() {
			if let label = child as? SKLabelNode {
				label.fontColor = self.frontColor
			}

			child.alpha = 0.0
			if i == sortedChildren.count - 1 {
				child.run(SKAction.sequence([
					SKAction.wait(forDuration: 0.1 * Double(i)),
					SKAction.fadeIn(withDuration: 1.0)
				]), completion: completion)

			} else {
				child.run(SKAction.sequence([
					SKAction.wait(forDuration: 0.1 * Double(i)),
					SKAction.fadeIn(withDuration: 1.0)
				]))
			}
		}
	}

	private func dismissAnimation() {
		dismissAnimation {
			print("dismissAnimation() done.")
		}
	}

	private func dismissAnimation(_ completion: @escaping () -> Void) {
		let sortedChildren = self.children.sorted(by: {$0.position.y > $1.position.y})

		for (i, child) in sortedChildren.enumerated() {
			if i == sortedChildren.count - 1 {
				child.run(SKAction.sequence([
					SKAction.wait(forDuration: 0.1 * Double(i)),
					SKAction.fadeOut(withDuration: 1.0)
				]), completion: completion)

			} else {
				child.run(SKAction.sequence([
					SKAction.wait(forDuration: 0.1 * Double(i)),
					SKAction.fadeOut(withDuration: 1.0)
				]))
			}
		}
	}

}
