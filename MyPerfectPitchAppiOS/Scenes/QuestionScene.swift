import SpriteKit
import GameplayKit

class PauseMenuNode: SKNode {

	//MARK: Properties

	private var retry      : SKLabelNode?
	private var difficulty : SKLabelNode?
	private var mainMenu   : SKLabelNode?
	private var resume     : SKLabelNode?

	//  MARK: init

	override init() {
		super.init()

		self._init()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		self._init()
	}

	//  MARK: helpers

	private func _init () {
		self.retry      = self.childNode(withName: "//retry"     ) as? SKLabelNode
		self.difficulty = self.childNode(withName: "//difficulty") as? SKLabelNode
		self.mainMenu   = self.childNode(withName: "//mainMenu"  ) as? SKLabelNode
		self.resume     = self.childNode(withName: "//resume"    ) as? SKLabelNode
	}

	//  MARK: API

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

	fileprivate func appearAnimation () {
		appearAnimation {
			print("pause menu appeared")
		}
	}

	fileprivate func appearAnimation(_ completion: @escaping () -> Void) {
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

	fileprivate func dismissAnimation () {
		dismissAnimation {
			print("pause menu dismissed")
		}
	}

	fileprivate func dismissAnimation(_ completion: @escaping () -> Void) {
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

class MusicNodes: SKNode {

	//MARK: Properties

	public var difficulty: GameDifficulties = .easy {
		didSet {
			var musicNodeXPos = [CGFloat]()

			switch self.difficulty {
			case .easy:
				musicNodeXPos = [0]

			case .normal:
				musicNodeXPos = [-60, 60]

			case .hard:
				musicNodeXPos = [-110, 0, 110]

			case .lunatic:
				musicNodeXPos = [-220, -110, 0, 110, 220]
			}

			self.removeAllChildren()
			for xPos in musicNodeXPos {
				let node = MusicNode()
				if let customSize = self.userData?.value(forKey: "size") as? Float {
					node.size = CGFloat(customSize)
				}
				node.position.x = xPos
				self.addChild(node)
			}
		}
	}

	//  MARK: init

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	public func play() {
		for case let musicNode as MusicNode in self.children {
			musicNode.play()
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
			musicNode.awaitAnswer()
		}
	}

	public func setColor(color: SKColor?, backgroundColor: SKColor?) {
		if let c = color {
			for case let musicNode as MusicNode in self.children {
				musicNode.color = c
			}
		}
		if let c = backgroundColor {
			for case let musicNode as MusicNode in self.children {
				musicNode.backgroundColor = c
			}
		}
	}

	public func checkAnswer(_ selectedPitch: [MusicNodePitch]) -> Int {
		var point = 0

		if selectedPitch.count > self.children.count {
			for case let musicNode as MusicNode in self.children {
				musicNode.error()
			}

		} else {
			for case let musicNode as MusicNode in self.children {
				if selectedPitch.contains(musicNode.pitch) {
					point += 1
					musicNode.correct()
				} else {
					musicNode.error()
				}
			}

			if point > 0 {
				point = 1
			}
		}

		return point
	}

}

class QuestionScene: MasterScene {

	//MARK: Properties

	var score : Int = 0
	var questionNum : Int = 1
	var difficulty : GameDifficulties?

	private var title          : SKLabelNode?
	private var musicNodes     : MusicNodes?
	private var confirm        : SKLabelNode?
	private var pauseNode      : SKLabelNode?
	private var keyboard       : KeyboardNode?
	private var pauseMenu      : PauseMenuNode?

	override func didMove(to view: SKView) {
		super.didMove(to: view)

		// Get label nodes from scene and store it for use later
		self.title          = self.childNode(withName: "//title"     ) as? SKLabelNode
		self.musicNodes     = self.childNode(withName: "//musicNodes" ) as?
			MusicNodes
		self.confirm        = self.childNode(withName: "//confirm"   ) as? SKLabelNode
		self.pauseNode      = self.childNode(withName: "//pause"     ) as? SKLabelNode
		self.keyboard       = self.childNode(withName: "//keyboard"  ) as? KeyboardNode
		self.pauseMenu      = self.childNode(withName: "//pauseMenu" ) as? PauseMenuNode

		if self.pauseMenu != nil {
			self.pauseMenu?.hide()
		}

		self.title?.text = "Question " + String(self.questionNum)
		self.musicNodes?.difficulty = self.difficulty!

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
					print(clicked.name ?? "x")
					clicked.toggle()
				}
				if let selected = self.keyboard?.selected() {
					print(selected)
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

					case "difficulty":
						self.goToDifficultyScene()

					case "mainMenu":
						self.goToStartMenuScene()

					case "resume":
						self.resume()

					default:
						print(clickName)

					}
				}

			case "confirm":
				guard let musicNodes = self.musicNodes,
				      let keyboard = self.keyboard,
				      let confirmNode = self.confirm
				else {
					return
				}

				if confirmNode.text == "continue" {
					self.questionNum += 1
					if self.questionNum > 20 {
						switch self.score {
						case 0:
							self.goToResultScene(":(")
						case 1..<10:
							self.goToResultScene("Keep it on!")
						case 10..<15:
							self.goToResultScene("Well Done!")
						case 15..<19:
							self.goToResultScene("So close!")
						case 20:
							self.goToResultScene("Fantastic!")
						default:
							self.goToResultScene("WTF!?")
						}
					} else {
						confirmNode.text = "confirm"
						self.nextQuestion()
					}

				} else {
					var selectedPitches = [MusicNodePitch]()
					let selected = keyboard.selected()
					for node in selected {
						selectedPitches.append(node.pitch)
					}

					self.score += musicNodes.checkAnswer(selectedPitches)
					confirmNode.text = "continue"
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

		if let label = self.confirm {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.6),
				SKAction.fadeOut(withDuration: 1.0)
			]), completion: {
				label.isHidden = true
			})
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

			if let label = self.confirm {
				label.alpha = 0.0
				label.isHidden = false
				label.run(SKAction.sequence([
					SKAction.wait(forDuration: 0.6),
					SKAction.fadeIn(withDuration: 1.0)
				]))
			}

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

	//MARK: Scene Transitions

	private func goToDifficultyScene() {
		if let scene = SKScene(fileNamed: "DifficultyMenuScene") as? DifficultyMenuScene {
			// Set the scale mode to scale to fit the window
			scene.scaleMode = .aspectFill

			dismissAnimation {
				// Present the scene
				self.view?.presentScene(scene)
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

	//MARK: Animations

	private func appearAnimation() {
		appearAnimation {
			print("appearAnimation() done.")
		}
	}

	private func appearAnimation(_ completion: @escaping () -> Void) {
		switch self.difficulty! {
		case .easy:
			self.colorScheme = .green

		case .normal:
			self.colorScheme = .blue

		case .hard:
			self.colorScheme = .red

		case .lunatic:
			self.colorScheme = .purple

		}

		let sortedChildren = self.children.sorted(by: {$0.position.y > $1.position.y})

		for (i, child) in sortedChildren.enumerated() {
			if let label = child as? SKLabelNode {
				label.fontColor = self.frontColor

			} else if let nodes = child as? MusicNodes {
				nodes.setColor(color: self.frontColor,
				               backgroundColor: self.middleColor)
			}

			if let kbd = child as? KeyboardNode {
				kbd.color = self.frontColor
				kbd.backgroundColor = self.backgroundColor
				kbd.appearAnimation()

			} else if let menu = child as? PauseMenuNode {
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

			} else if let menu = child as? PauseMenuNode {
				menu.dismissAnimation()

			} else if i == sortedChildren.count - 1 {
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

}
