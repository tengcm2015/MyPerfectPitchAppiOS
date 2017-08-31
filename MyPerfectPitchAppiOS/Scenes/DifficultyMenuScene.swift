import SpriteKit
import GameplayKit

class DifficultyMenuScene: MasterScene {

	//MARK: Properties

	var mode : String?

	private var title    : SKLabelNode?
	private var subtitle : SKLabelNode?
	private var easy     : SKLabelNode?
	private var normal   : SKLabelNode?
	private var hard     : SKLabelNode?
	private var lunatic  : SKLabelNode?
	private var menu     : SKLabelNode?

	override func didMove(to view: SKView) {
		super.didMove(to: view)

		// Get label node from scene and store it for use later
		self.title    = self.childNode(withName: "//title"    ) as? SKLabelNode
		self.subtitle = self.childNode(withName: "//subtitle" ) as? SKLabelNode
		self.easy     = self.childNode(withName: "//easy"     ) as? SKLabelNode
		self.normal   = self.childNode(withName: "//normal"   ) as? SKLabelNode
		self.hard     = self.childNode(withName: "//hard"     ) as? SKLabelNode
		self.lunatic  = self.childNode(withName: "//lunatic"  ) as? SKLabelNode
		self.menu     = self.childNode(withName: "//return"   ) as? SKLabelNode

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
			case "easy":
				goToQuestionScene(.easy)
				break
			case "normal":
				goToQuestionScene(.normal)
				break
			case "hard":
				goToQuestionScene(.hard)
				break
			case "lunatic":
				goToQuestionScene(.lunatic)
				break
			case "return":
				goToStartMenuScene()
				break
			default:
				break
			}
		}
	}

	//MARK: Scene Trasitions

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

	private func goToQuestionScene(_ difficulty : GameDifficulties) {
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
				switch label {
				case self.easy!:
					label.fontColor = SKColor.green

				case self.normal!:
					label.fontColor = SKColor.blue

				case self.hard!:
					label.fontColor = SKColor.red

				case self.lunatic!:
					label.fontColor = SKColor.purple

				default:
					label.fontColor = self.frontColor
				}
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
