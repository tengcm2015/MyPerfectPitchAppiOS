import SpriteKit
import GameplayKit

class SpeedTestScene: MasterScene {

	//MARK: Properties

	var score       : Int = 0
	var questionNum : Int = 1
	var interval    : Int = 100

	private var title      : SKLabelNode?
	private var musicNodes : SpeedTestSceneMusicNodes?
	private var pauseNode  : SKLabelNode?
	private var keyboard   : KeyboardNode?
	private var pauseMenu  : SpeedTestScenePauseMenuNode?

	override func didMove(to view: SKView) {
		super.didMove(to: view)

		// Get label nodes from scene and store it for use later
		self.title      = self.childNode(withName: "//title"     ) as? SKLabelNode
		self.musicNodes = self.childNode(withName: "//musicNodes") as? SpeedTestSceneMusicNodes
		self.pauseNode  = self.childNode(withName: "//pause"     ) as? SKLabelNode
		self.keyboard   = self.childNode(withName: "//keyboard"  ) as? KeyboardNode
		self.pauseMenu  = self.childNode(withName: "//pauseMenu" ) as? SpeedTestScenePauseMenuNode

		if self.pauseMenu != nil {
			self.pauseMenu?.hide()
		}

		self.title?.text = "Question " + String(self.questionNum)

		self.appearAnimation {
			self.nextQuestion()
		}
	}

	override func handleClick(_ nodes: [SKNode]) {
		if let node = nodes.last {
			guard let name = node.name else {
				return
			}

			switch name {
			case "keyboard":
				guard let keyboard = self.keyboard else {
					return
				}

				var tmp = nodes
				tmp.removeLast()
				if let clicked = keyboard.clicked(tmp){
					self.musicNodes!.checkAnswer(clicked.pitch)
				}

			case "musicNodes":
				var tmp = nodes
				tmp.removeLast()
				if let musicNode = tmp.last as? MusicNode {
					print(musicNode.pitch)
				}

			case "pauseMenu":
				guard let pauseMenu = self.pauseMenu else {
					return
				}

				var tmp = nodes
				tmp.removeLast()
				if let clickName = pauseMenu.clicked(tmp)?.name {
					switch clickName {
					case "retry":
						self.retry()

					case "selectMode":
						self.goToModeSelectScene()

					case "mainMenu":
						self.goToStartMenuScene()

					case "resume":
						self.resume()

					default:
						print(clickName)

					}
				}

			case "pause":
				self.pause()

			default:
				print(name)
			}
		}
	}

	//MARK: Private Methods

	private func nextQuestion() {
		guard let musicNodes = self.musicNodes,
		      let keyboard = self.keyboard
		else {
			return
		}

		keyboard.reset()
		musicNodes.setPitch()
		musicNodes.play()

		self.title?.text = "Question " + String(self.questionNum)
	}

	private func pause() {
		keyboard?.dismissAnimation {
			self.keyboard?.hide()
			self.pauseMenu?.show()
			self.pauseMenu?.appearAnimation()
		}

		if let label = self.pauseNode {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.8),
				SKAction.fadeOut(withDuration: 1.0)
			]), completion: {
				label.isHidden = true
			})
		}
	}

	private func resume() {
		pauseMenu?.dismissAnimation {
			self.pauseMenu?.hide()
			self.keyboard?.show()
			self.keyboard?.appearAnimation()

			if let label = self.pauseNode {
				label.alpha = 0.0
				label.isHidden = false
				label.run(SKAction.sequence([
					SKAction.wait(forDuration: 0.8),
					SKAction.fadeIn(withDuration: 1.0)
				]))
			}
		}
	}

	private func retry() {
		let scene = SKScene(fileNamed: "SpeedTestScene") as! SpeedTestScene
		scene.score = 0
		self.goToScene(scene)
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

	private func goToModeSelectScene() {
		let scene = SKScene(fileNamed: "ModeSelectScene") as! ModeSelectScene
		self.goToScene(scene)
	}

	private func goToStartMenuScene() {
		let scene = SKScene(fileNamed: "StartMenuScene") as! StartMenuScene
		self.goToScene(scene)
	}

	private func goToResultScene(_ message : String) {
		let scene = SKScene(fileNamed: "SpeedTestResultScene") as! SpeedTestResultScene
		scene.score = self.score
		scene.message = message
		self.goToScene(scene)
	}

	//MARK: Animations

	private func appearAnimation() {
		appearAnimation {
			print("appearAnimation() done.")
		}
	}

	private func appearAnimation(_ completion: @escaping () -> Void) {

		self.colorScheme = .green

		let sortedChildren = self.children.sorted(by: {$0.position.y > $1.position.y})

		for (i, child) in sortedChildren.enumerated() {
			if let label = child as? SKLabelNode {
				label.fontColor = self.frontColor

			} else if let nodes = child as? SpeedTestSceneMusicNodes {
				nodes.setColor(self.frontColor)
			}

			if let kbd = child as? KeyboardNode {
				kbd.color = self.frontColor
				kbd.backgroundColor = self.backgroundColor
				kbd.appearAnimation()

			} else if let menu = child as? SpeedTestScenePauseMenuNode {
				menu.hide()
				menu.setColor(self.frontColor)

			} else if i == sortedChildren.count - 1 {
				child.alpha = 0.0
				child.run(SKAction.sequence([
					SKAction.wait(forDuration: 0.1 * Double(i)),
					SKAction.fadeIn(withDuration: 1.0)
				]), completion: completion)

			} else {
				child.alpha = 0.0
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
			if let kbd = child as? KeyboardNode {
				kbd.dismissAnimation()

			} else if let menu = child as? SpeedTestScenePauseMenuNode {
				menu.dismissAnimation()

			} else if i == sortedChildren.count - 1 {
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

class SpeedTestSceneMusicNodes: SKNode {

	//MARK: Properties

	private var currentIndex : Int = 0
	private var progressBar : BarProgressNode?

	//MARK: init

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		self._init()
	}

	private func _init() {
		guard
			let progressBar = self.childNode(withName: "//progressBar") as? BarProgressNode
		else {
			return
		}
		self.progressBar = progressBar
		progressBar.progress = 0
		progressBar.width = 10
		progressBar.length = 600

		let musicNodeXPos : [CGFloat] = [-220, -110, 0, 110, 220]

		for xPos in musicNodeXPos {
			let node = MusicNode()
			if let customSize = self.userData?.value(forKey: "size") as? Float {
				node.size = CGFloat(customSize)
			}
			node.position.x = xPos
			self.addChild(node)
		}

	}


	//MARK: API

	public func play() {
		self.progressBar?.countup(time: 10, completionHandler: {
			print("pbar cd done")
		})
		for case let musicNode as MusicNode in self.children {
			musicNode.play()
			musicNode.countdown(time: 10, completionHandler: {
				print("musicnode cd done")
			})
		}
	}

	public func setPitch() {
		let shuffled = GKShuffledDistribution(lowestValue: 0,
		                                      highestValue: 11)
		for case let musicNode as MusicNode in self.children {
			switch shuffled.nextInt() {
			case 0:
				musicNode.pitch = .a

			case 1:
				musicNode.pitch = .b

			case 2:
				musicNode.pitch = .c

			case 3:
				musicNode.pitch = .d

			case 4:
				musicNode.pitch = .e

			case 5:
				musicNode.pitch = .f

			case 6:
				musicNode.pitch = .g

			case 7:
				musicNode.pitch = .asharp

			case 8:
				musicNode.pitch = .csharp

			case 9:
				musicNode.pitch = .dsharp

			case 10:
				musicNode.pitch = .fsharp

			case 11:
				musicNode.pitch = .gsharp

			default:
				print("nextQuestion(): switch error")
				return
			}
			print(musicNode.pitch)
			musicNode.state = .waiting
		}
	}

	public func setColor(_ color: SKColor?) {
		if let c = color {
			for case let musicNode as MusicNode in self.children {
				musicNode.color = c
			}
			self.progressBar?.color = c
			self.progressBar?.backgroundColor = c.withAlphaComponent(0.5)
		}
	}

	public func checkAnswer(_ selectedPitch: MusicNodePitch) -> Int {
		var point : Int = 0
		for case let musicNode as MusicNode in self.children {
			if musicNode.state != .waiting {
				continue
			}

			if selectedPitch == musicNode.pitch {
				musicNode.state = .correct
				point = 1
			} else {
				musicNode.state = .error
			}
			break
		}
		return point
	}

}

class SpeedTestScenePauseMenuNode: SKNode {

	//MARK: Properties

	private var retry      : SKLabelNode?
	private var selectMode : SKLabelNode?
	private var mainMenu   : SKLabelNode?
	private var resume     : SKLabelNode?

	//MARK: init

	override init() {
		super.init()

		self._init()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		self._init()
	}

	//MARK: helpers

	private func _init () {
		self.retry      = self.childNode(withName: "//retry"     ) as? SKLabelNode
		self.selectMode = self.childNode(withName: "//selectMode") as? SKLabelNode
		self.mainMenu   = self.childNode(withName: "//mainMenu"  ) as? SKLabelNode
		self.resume     = self.childNode(withName: "//resume"    ) as? SKLabelNode
	}

	//MARK: API

	public func hide () {
		self.isHidden = true
	}

	public func show () {
		self.isHidden = false
	}

	public func clicked(_ nodes: [SKNode]) -> SKNode? {
		return nodes.last
	}

	public func setColor(_ color: SKColor) {
		for case let label as SKLabelNode in self.children {
			label.fontColor = color
		}
	}

	//MARK: Animations

	public func appearAnimation () {
		appearAnimation {
			print("pause menu appeared")
		}
	}

	public func appearAnimation(_ completion: @escaping () -> Void) {
		let sortedChildren = self.children.sorted(by: {$0.position.y > $1.position.y})
		for (i, child) in sortedChildren.enumerated() {
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

	public func dismissAnimation () {
		dismissAnimation {
			print("pause menu dismissed")
		}
	}

	public func dismissAnimation(_ completion: @escaping () -> Void) {
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
