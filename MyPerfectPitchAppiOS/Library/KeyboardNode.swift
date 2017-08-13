import SpriteKit

class KeyboardKeyNode: SKNode {
	
	//  MARK: constants
	
	struct Constants {
		static let sideLength : CGFloat = 50
	}
	
	
	//  MARK: properties
	
	private let label = SKLabelNode()
	
	private let shape = SKShapeNode()
	
	public var sideLength: CGFloat = KeyboardKeyNode.Constants.sideLength {
		didSet {
			setSideLength()
		}
	}
	
	override public var name: String? {
		didSet {
			self.label.text = self.name
		}
	}
	
	//  MARK: init
	
	public init(sideLength: CGFloat = KeyboardKeyNode.Constants.sideLength) {
		self.sideLength = sideLength
		
		super.init()
		
		self._init()
	}
	
	override init() {
		super.init()
		
		self._init()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self._init()
	}
	
	
	//  MARK: helpers
	
	private func setSideLength() {
		self.label.fontSize = self.sideLength / 2
		
		let path = UIBezierPath()
		let coordinate = self.sideLength / 2
		path.move(to: CGPoint(x: coordinate, y: coordinate))
		path.addLine(to: CGPoint(x: coordinate, y: -coordinate))
		path.addLine(to: CGPoint(x: -coordinate, y: -coordinate))
		path.addLine(to: CGPoint(x: -coordinate, y: coordinate))
		path.addLine(to: CGPoint(x: coordinate, y: coordinate))
		
		self.shape.path = path.cgPath
	}
	
	private func _init() {
		setSideLength()
		self.shape.lineWidth = 3
		
		self.addChild(self.shape)
		
		self.label.position = CGPoint.zero
		self.label.text = self.name
		self.label.fontName = "Helvetica Neue Thin"
		self.label.verticalAlignmentMode = .center
		self.label.horizontalAlignmentMode = .center
		
		self.addChild(self.label)
	}
	
}

class KeyboardNode: SKNode {

	//MARK: Properties

	private var C    : KeyboardKeyNode?
	private var D    : KeyboardKeyNode?
	private var E    : KeyboardKeyNode?
	private var F    : KeyboardKeyNode?
	private var G    : KeyboardKeyNode?
	private var A    : KeyboardKeyNode?
	private var B    : KeyboardKeyNode?
	private var Cs   : KeyboardKeyNode?
	private var Ds   : KeyboardKeyNode?
	private var Fs   : KeyboardKeyNode?
	private var Gs   : KeyboardKeyNode?
	private var As   : KeyboardKeyNode?


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

	private func getKeyNode(_ name: String) -> KeyboardKeyNode? {
		if let node = self.childNode(withName: "//" + name) as? KeyboardKeyNode {
			if let keySize = self.userData?.value(forKey: "keySize") as? Float {
				print(keySize)
				node.sideLength = CGFloat(keySize)
			}
			
			return node
		} else {
			return nil
		}
	}
	
	private func _init() {
		self.C    = getKeyNode("C")
		self.D    = getKeyNode("D")
		self.E    = getKeyNode("E")
		self.F    = getKeyNode("F")
		self.G    = getKeyNode("G")
		self.A    = getKeyNode("A")
		self.B    = getKeyNode("B")
		self.Cs   = getKeyNode("C#")
		self.Ds   = getKeyNode("D#")
		self.Fs   = getKeyNode("F#")
		self.Gs   = getKeyNode("G#")
		self.As   = getKeyNode("A#")
	}


	//  MARK: API

	public func hide () {
		self.isHidden = true
	}

	public func show () {
		self.isHidden = false
	}

	public func appearAnimation () {
		appearAnimation {
			print("keyboard appeared")
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
			print("keyboard dismissed")
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

	public func clicked(_ nodes: [SKNode]) -> SKNode? {
		return nodes.last
	}
}
