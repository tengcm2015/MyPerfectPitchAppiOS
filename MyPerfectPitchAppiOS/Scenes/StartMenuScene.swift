import SpriteKit
import GameplayKit

class StartMenuScene: MasterScene {

	//MARK: Properties

	private var title    : SKLabelNode?
	private var training : SKLabelNode?
	private var trials   : SKLabelNode?
	private var vs       : SKLabelNode?
	private var setting  : SKLabelNode?

	override func didMove(to view: SKView) {
		super.didMove(to: view)

		// Get label nodes from scene and store it for use later
		self.title    = self.childNode(withName: "//title"   ) as? SKLabelNode
		self.training = self.childNode(withName: "//training") as? SKLabelNode
		self.trials   = self.childNode(withName: "//trials"  ) as? SKLabelNode
		self.vs       = self.childNode(withName: "//vs"      ) as? SKLabelNode
		self.setting  = self.childNode(withName: "//setting" ) as? SKLabelNode

		appearAnimation()
	}

	override func handleClick(_ nodes: [SKNode]) {
		let node = nodes.last
		if let name = node?.name {
			switch name {
			case "training":
				goToDiffcultyScene("Training")

			case "trials":
				goToModeSelectScene("Trials")

			case "vs":
				print(name)

			case "setting":
				goToSettingsScene()

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

	private func goToDiffcultyScene(_ mode : String) {
		let scene = SKScene(fileNamed: "DifficultyMenuScene") as! DifficultyMenuScene
		scene.mode = mode
		self.goToScene(scene)
	}

	private func goToModeSelectScene(_ mode : String) {
		let scene = SKScene(fileNamed: "ModeSelectScene") as! ModeSelectScene
		scene.mode = mode
		self.goToScene(scene)
	}

	private func goToSettingsScene() {
		let scene = SKScene(fileNamed: "SettingsScene") as! SettingsScene
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
