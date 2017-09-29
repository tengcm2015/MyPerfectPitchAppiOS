import SpriteKit

class MusicNode : SKNode {

	//MARK: constants

	struct Constants {
		static let size : CGFloat  = 50
	}


	//MARK: properties

	private let countdownNode = CircleProgressNode()

	private let label = SKLabelNode()

	// private let shape = SKShapeNode()

	public enum MusicNodeState {
		case waiting, correct, error, disabled
	}

	public var color = DefaultConstants.color {
		didSet {
			setColor(self.color)
		}
	}

	public var state : MusicNodeState = .disabled {
		didSet {
			switch self.state {
			case .waiting:
				self.setColor(self.color)
				self.label.text = "?"
				// self.label.isHidden = false
				// self.shape.isHidden = true

			case .correct:
				self.setColor(SKColor.green)
				self.label.text = self.pitch.signature(.english)
				// self.label.isHidden = true
				// self.shape.isHidden = false

				// let shapeSize = self.size / 2 / 1.41421356
				// let path = UIBezierPath()
				// path.move   (to: CGPoint(x: -shapeSize, y: -shapeSize / 3))
				// path.addLine(to: CGPoint(x: -shapeSize / 3, y: -shapeSize))
				// path.addLine(to: CGPoint(x: shapeSize, y: shapeSize))

				// self.shape.path = path.cgPath

			case .error:
				self.setColor(SKColor.red)
				self.label.text = self.pitch.signature(.english)
				// self.label.isHidden = true
				// self.shape.isHidden = false

				// let shapeSize = self.size / 2 / 1.41421356
				// let path = UIBezierPath()
				// path.move   (to: CGPoint(x: shapeSize, y: shapeSize))
				// path.addLine(to: CGPoint(x: -shapeSize, y: -shapeSize))
				// path.move   (to: CGPoint(x: shapeSize, y: -shapeSize))
				// path.addLine(to: CGPoint(x: -shapeSize, y: shapeSize))

				// self.shape.path = path.cgPath

			case .disabled:
				self.setColor(self.color)
				self.label.text = "X"
			}
		}
	}

	public var pitch : MusicNodePitch = .c

	public private(set) var countingDown : Bool = false

	public var size: CGFloat = MusicNode.Constants.size {
		didSet {
			self.label.fontSize       = self.size / 2
			// self.shape.lineWidth      = self.size / 20
			self.countdownNode.radius = self.size / 2
			self.countdownNode.width  = self.size / 20
		}
	}


	//MARK: init

	public init(size: CGFloat = MusicNode.Constants.size) {
		super.init()

		self.userData?.setValue(size, forKey: "size")

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


	//MARK: helpers

	private func _init() {
		if let customSize = self.userData?.value(forKey: "size") as? Float {
			self.size = CGFloat(customSize)
		} else {
			self.size = MusicNode.Constants.size
		}

		self.label.position = CGPoint.zero
		self.label.fontName = "Helvetica Neue Thin"
		self.label.verticalAlignmentMode = .center
		self.label.horizontalAlignmentMode = .center

		self.addChild(self.label)

		// self.shape.position = CGPoint.zero

		// self.addChild(self.shape)

		self.addChild(self.countdownNode)

		self.setColor(self.color)

		self.label.text = "X"
	}

	private func setColor(_ color : SKColor) {
		if self.state == .disabled {
			self.label.fontColor      = color.withAlphaComponent(0.5)
			// self.shape.strokeColor    = color.withAlphaComponent(0.5)
			self.countdownNode.color  = color.withAlphaComponent(0)
		} else {
			self.label.fontColor      = color
			// self.shape.strokeColor    = color
			self.countdownNode.color  = color
		}
		self.countdownNode.backgroundColor
		                              = color.withAlphaComponent(0.5)
	}


	//MARK: API

	public func countdown(time: TimeInterval = 1.0,
	                      completionHandler: (() -> Void)?) {
		self.countingDown = true
		self.countdownNode.countdown(time: time,
		                             completionHandler: completionHandler)
	}

	public func countdown(time: TimeInterval = 1.0,
	                      progressHandler: (() -> Void)?,
	                      completionHandler: (() -> Void)?) {
		self.countingDown = true
		self.countdownNode.countdown(time: time,
		                             progressHandler: progressHandler,
		                             completionHandler: completionHandler)
	}

	public func stopCountdown() {
		self.countingDown = false
		self.countdownNode.stopCount()
	}

	public func play() {
		var fileName: String
		switch self.pitch {
		case .a:
			fileName = "piano_a.wav"
		case .b:
			fileName = "piano_b.wav"
		case .c:
			fileName = "piano_c.wav"
		case .d:
			fileName = "piano_d.wav"
		case .e:
			fileName = "piano_e.wav"
		case .f:
			fileName = "piano_f.wav"
		case .g:
			fileName = "piano_g.wav"
		case .asharp:
			fileName = "piano_as.wav"
		case .csharp:
			fileName = "piano_cs.wav"
		case .dsharp:
			fileName = "piano_ds.wav"
		case .fsharp:
			fileName = "piano_fs.wav"
		case .gsharp:
			fileName = "piano_gs.wav"
		}

		self.run(SKAction.playSoundFileNamed(
			fileName, waitForCompletion: false
		))
	}
}
