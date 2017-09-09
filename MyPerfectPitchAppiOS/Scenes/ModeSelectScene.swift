import SpriteKit
import GameplayKit

class ModeSelectScene: MasterScene {

	//MARK: Properties

	var mode : String?

	private var title     : SKLabelNode?
	private var subtitle  : SKLabelNode?
	private var speedTest : SKLabelNode?
	private var timeTrial : SKLabelNode?
	private var menu      : SKLabelNode?

	override func didMove(to view: SKView) {
		super.didMove(to: view)

		// Get label node from scene and store it for use later
		self.title     = self.childNode(withName: "//title"     ) as? SKLabelNode
		self.subtitle  = self.childNode(withName: "//subtitle"  ) as? SKLabelNode
		self.speedTest = self.childNode(withName: "//speedTest" ) as? SKLabelNode
		self.timeTrial = self.childNode(withName: "//timeTrial" ) as? SKLabelNode
		self.menu      = self.childNode(withName: "//return"    ) as? SKLabelNode

		if let titleText = self.mode {
			print(titleText)
			self.title?.text = titleText
		}

		appearAnimation()

	}


	override func handleClick(_ nodes: [SKNode]) {
		let node = nodes.last
		if let name = node?.name {
			switch name {
			case "speedTest":
				goToSpeedTestScene()

			case "timeTrial":
				goToSpeedTestScene()

			case "return":
				goToStartMenuScene()

			default:
				print(name)
			}
		}
	}

	//MARK: Scene Trasitions

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
