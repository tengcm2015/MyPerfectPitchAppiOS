import SpriteKit
import GameplayKit

class MasterScene: SKScene {

	//MARK: Properties

	private var spinnyNode : SKShapeNode?

	override func didMove(to view: SKView) {
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

	public private(set) var frontColor = UIColor.white
	public private(set) var middleColor = UIColor.darkGray
	override public internal(set) var backgroundColor : UIColor {
		get {
			return super.backgroundColor
		}
		set(newColor) {
			super.backgroundColor = newColor
		}
	}

	public enum ColorSchemes {
		case dark, light, green, blue, red, purple
	}

	public var colorScheme : ColorSchemes = .dark {
		didSet {
			switch self.colorScheme {
			case .dark:
				break
			case .light:
				break
			case .green:
				break
			case .blue:
				break
			case .red:
				break
			case .purple:
				break
			}
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

	// override this method in subclasses to handle clicks
	func handleClick(_ nodes: [SKNode]) {
		print(nodes)
	}

	//MARK: Private Methods

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

		handleClick(self.nodes(at: pos))
	}

}
