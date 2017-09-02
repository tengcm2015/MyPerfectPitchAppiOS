import SpriteKit

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


	public var color = DefaultConstants.color {
		didSet {
			for case let child as KeyboardKeyNode in self.children {
				child.color = self.color
			}
		}
	}

	public var backgroundColor = DefaultConstants.backgroundColor {
		didSet {
			for case let child as KeyboardKeyNode in self.children {
				child.backgroundColor = self.backgroundColor
			}
		}
	}

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

	private func getKeyNode(_ pitch: MusicNodePitch) -> KeyboardKeyNode? {
		guard
			let node = self.childNode(withName: "//" + pitch.rawValue) as? KeyboardKeyNode
			else {
				return nil
		}

		node.pitch = pitch

		if let keySize = self.userData?.value(forKey: "keySize") as? Float {
			node.size = CGFloat(keySize)
		}

		return node
	}

	private func _init() {
		self.C    = getKeyNode(.c)
		self.D    = getKeyNode(.d)
		self.E    = getKeyNode(.e)
		self.F    = getKeyNode(.f)
		self.G    = getKeyNode(.g)
		self.A    = getKeyNode(.a)
		self.B    = getKeyNode(.b)
		self.Cs   = getKeyNode(.csharp)
		self.Ds   = getKeyNode(.dsharp)
		self.Fs   = getKeyNode(.fsharp)
		self.Gs   = getKeyNode(.gsharp)
		self.As   = getKeyNode(.asharp)
	}


	//MARK: API

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
		let sortedChildren = self.children
			.sorted(by: {$0.position.y > $1.position.y})
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
		let sortedChildren = self.children
			.sorted(by: {$0.position.y > $1.position.y})
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

	public func clicked(_ nodes: [SKNode]) -> KeyboardKeyNode? {
		return nodes.last as? KeyboardKeyNode
	}

	public func selected() -> [KeyboardKeyNode] {
		return self.children.filter {
			guard let keyNode = $0 as? KeyboardKeyNode else {
				return false
			}
			return keyNode.selected
		} as! [KeyboardKeyNode]
	}

	public func reset() {
		for node in self.selected() {
			node.toggle()
		}
	}
}

class KeyboardKeyNode: SKNode {

	//MARK: constants

	struct Constants {
		static let size : CGFloat = 50
	}


	//MARK: properties

	private let label = SKLabelNode()

	private let shape = SKShapeNode()

	public var color = DefaultConstants.color {
		didSet {
			self.shape.strokeColor = self.color
			let sel = self.selected
			self.selected = sel
		}
	}

	public var backgroundColor = DefaultConstants.backgroundColor {
		didSet {
			let sel = self.selected
			self.selected = sel
		}
	}

	public private(set) var selected : Bool = false {
		didSet {
			if self.selected {
				self.label.fontColor = self.backgroundColor
				self.shape.fillColor = self.color
			} else {
				self.label.fontColor = self.color
				self.shape.fillColor = self.backgroundColor
			}
		}
	}

	public var size: CGFloat = KeyboardKeyNode.Constants.size {
		didSet {
			self.label.fontSize = self.size / 2

			let path = UIBezierPath()
			let coordinate = self.size / 2
			path.move   (to: CGPoint(x: coordinate,  y: coordinate ))
			path.addLine(to: CGPoint(x: coordinate,  y: -coordinate))
			path.addLine(to: CGPoint(x: -coordinate, y: -coordinate))
			path.addLine(to: CGPoint(x: -coordinate, y: coordinate ))
			path.addLine(to: CGPoint(x: coordinate,  y: coordinate ))

			self.shape.path = path.cgPath
		}
	}

	public var pitch: MusicNodePitch = .c {
		didSet {
			switch self.pitch {
			case .a:
				self.label.text = "A"
			case .b:
				self.label.text = "B"
			case .c:
				self.label.text = "C"
			case .d:
				self.label.text = "D"
			case .e:
				self.label.text = "E"
			case .f:
				self.label.text = "F"
			case .g:
				self.label.text = "G"
			case .asharp:
				self.label.text = "A#"
			case .csharp:
				self.label.text = "C#"
			case .dsharp:
				self.label.text = "D#"
			case .fsharp:
				self.label.text = "F#"
			case .gsharp:
				self.label.text = "G#"
			}
		}
	}

	//MARK: init

	public init(size: CGFloat = KeyboardKeyNode.Constants.size,
	            pitch: MusicNodePitch = .c) {
		super.init()

		self._init()

		self.size = size
		self.pitch = pitch
	}

	override init() {
		super.init()

		self._init()

		self.size = KeyboardKeyNode.Constants.size
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		self._init()

		self.size = KeyboardKeyNode.Constants.size
	}


	//MARK: helpers

	private func _init() {
		self.shape.lineWidth = 3

		self.addChild(self.shape)

		self.label.position = CGPoint.zero
		self.label.text = self.name
		self.label.fontName = "Helvetica Neue Thin"
		self.label.verticalAlignmentMode = .center
		self.label.horizontalAlignmentMode = .center

		self.addChild(self.label)

		self.selected = false
	}

	//MARK: API

	public func toggle() {
		self.selected = !self.selected
	}

}
