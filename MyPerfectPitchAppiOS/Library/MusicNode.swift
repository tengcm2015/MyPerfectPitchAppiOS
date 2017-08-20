//
//  MusicNode.swift
//  SpriteKit extension
//
//  Reference: ProgressNode.swift
//  Created by Tibor Bodecs on 06/02/15.
//  Copyright (c) 2015 Tibor Bodecs. All rights reserved.
//

import SpriteKit


public class MusicNode : SKNode {

	//  MARK: constants

	struct Constants {
		static let size : CGFloat  = 50
		static let color : SKColor = SKColor.white
	}


	//  MARK: properties

	private let countdownNode = CountdownNode()

	private let label = SKLabelNode()

	private let shape = SKShapeNode()

	public enum MusicNodeState {
		case waiting, correct, error
	}

	public private(set) var state : MusicNodeState = .waiting

	public var pitch : MusicNodePitch = .c

	public private(set) var countingDown : Bool = false

	public var size: CGFloat = MusicNode.Constants.size {
		didSet {
			self.label.fontSize	      = self.size / 2
			self.shape.lineWidth      = self.size / 20
			self.countdownNode.radius = self.size / 2
			self.countdownNode.width  = self.size / 20
		}
	}


	//  MARK: init

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


	//  MARK: helpers

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

		self.shape.position = CGPoint.zero

		self.addChild(self.shape)

		self.countdownNode.color  = UIColor.white
		self.countdownNode.backgroundColor = UIColor.darkGray

		self.addChild(self.countdownNode)

		awaitAnswer()
	}


	//  MARK: API

	public func countdown(time: TimeInterval = 1.0,
	                      completionHandler: ((Void) -> Void)?) {
		self.countingDown = true
		self.countdownNode.countdown(time: time,
		                             completionHandler: completionHandler)
	}

	public func countdown(time: TimeInterval = 1.0,
	                      progressHandler: ((Void) -> Void)?,
	                      completionHandler: ((Void) -> Void)?) {
		self.countingDown = true
		self.countdownNode.countdown(time: time,
		                             progressHandler: progressHandler,
		                             completionHandler: completionHandler)
	}

	public func stopCountdown() {
		self.countingDown = false
		self.countdownNode.stopCountdown()
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

	public func awaitAnswer() {
		self.state = .waiting

		self.label.text = "?"
		self.label.isHidden = false
		self.shape.isHidden = true
	}

	public func correct() {
		self.state = .correct

		self.label.isHidden = true
		self.shape.isHidden = false

		let shapeSize = self.size / 2 / 1.41421356
		let path = UIBezierPath()
		path.move   (to: CGPoint(x: -shapeSize, y: -shapeSize / 3))
		path.addLine(to: CGPoint(x: -shapeSize / 3, y: -shapeSize))
		path.addLine(to: CGPoint(x: shapeSize, y: shapeSize))

		self.shape.path = path.cgPath
	}

	public func error() {
		self.state = .error

		self.label.isHidden = true
		self.shape.isHidden = false

		let shapeSize = self.size / 2 / 1.41421356
		let path = UIBezierPath()
		path.move   (to: CGPoint(x: shapeSize, y: shapeSize))
		path.addLine(to: CGPoint(x: -shapeSize, y: -shapeSize))
		path.move   (to: CGPoint(x: shapeSize, y: -shapeSize))
		path.addLine(to: CGPoint(x: -shapeSize, y: shapeSize))

		self.shape.path = path.cgPath
	}
}

public class CountdownNode : SKShapeNode {

	//  MARK: constants

	struct Constants {
		static let radius : CGFloat          = 32
		static let color : SKColor           = SKColor.white
		static let backgroundColor : SKColor = SKColor.darkGray
		static let width : CGFloat           = 2.0
		static let progress : CGFloat        = 0.0
		static let startAngle : CGFloat      = CGFloat(Double.pi)
		static let actionKey         = "_CountdownNodeActionKey"
	}


	//  MARK: properties

	/// the radius of the progress node
	public var radius: CGFloat = CountdownNode.Constants.radius {
		didSet {
			self.updateProgress(node: self.timeNode, progress: self.progress)
			self.updateProgress(node: self)
		}
	}

	//the active time color
	public var color: SKColor = CountdownNode.Constants.color {
		didSet {
			self.timeNode.strokeColor = self.color
		}
	}

	//the background color of the timer (to hide: use clear color)
	public var backgroundColor: SKColor = CountdownNode.Constants.backgroundColor {
		didSet {
			self.strokeColor = self.backgroundColor
		}
	}

	///the line width of the progress node
	public var width: CGFloat = CountdownNode.Constants.width {
		didSet {
			self.timeNode.lineWidth = self.width
			self.lineWidth          = self.width
		}
	}

	//the current progress of the progress node end progress is 1.0 and start is 0.0
	public var progress: CGFloat = CountdownNode.Constants.progress {
		didSet {
			self.updateProgress(node: self.timeNode, progress: self.progress)
		}
	}

	// the start angle of the progress node
	public var startAngle: CGFloat = CountdownNode.Constants.startAngle {
		didSet {
			self.updateProgress(node: self.timeNode, progress: self.progress)
		}
	}

	private let timeNode = SKShapeNode()


	//  MARK: init

	public init(radius: CGFloat = CountdownNode.Constants.radius,
	            color: SKColor = CountdownNode.Constants.color,
	            backgroundColor: SKColor = CountdownNode.Constants.backgroundColor,
	            width: CGFloat = CountdownNode.Constants.width,
	            progress: CGFloat = CountdownNode.Constants.progress) {

		self.radius          = radius
		self.color           = color
		self.backgroundColor = backgroundColor
		self.width           = width
		self.progress        = progress

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

	private func _init() {
		self.timeNode.lineWidth   = self.width
		self.timeNode.strokeColor = self.color
		self.timeNode.zPosition   = self.zPosition + 1
		self.timeNode.position    = CGPoint.zero

		self.addChild(self.timeNode)
		self.updateProgress(node: self.timeNode, progress: self.progress)

		self.lineWidth   = self.width
		self.strokeColor = self.backgroundColor

		self.updateProgress(node: self)
	}

	private func updateProgress(node: SKShapeNode, progress: CGFloat = 0.0) {
		let progress   = 1.0 - progress
		let startAngle = self.startAngle - CGFloat(.pi / 2.0)
		let endAngle   = startAngle + progress*CGFloat(2.0 * .pi)
		node.path      = UIBezierPath(arcCenter: CGPoint.zero,
		                              radius: self.radius,
		                              startAngle: startAngle,
		                              endAngle: endAngle,
		                              clockwise: true).cgPath
	}


	//  MARK: API

	/*!
	 The countdown method counts down from a time interval to zero,
	 and it calls a callback on the main thread if its finished

	 :param: time     The time interval to count
	 :param: progressHandler
	                  An optional callback method (always called on main thread)
	 :param: callback An optional callback method (always called on main thread)
	 */
	public func countdown(time: TimeInterval = 1.0,
	                      completionHandler: ((Void) -> Void)?) {
		self.countdown (
			time: time, progressHandler: nil,
			completionHandler: completionHandler
		)
	}

	public func countdown(time: TimeInterval = 1.0,
	                      progressHandler: ((Void) -> Void)?,
	                      completionHandler: ((Void) -> Void)?) {
		self.stopCountdown()

		self.run(SKAction.customAction(withDuration: time) {
			(node: SKNode!, elapsedTime: CGFloat) in

			self.progress = elapsedTime / CGFloat(time)

			if let cb = progressHandler {
				DispatchQueue.main.async(execute: {
					cb()
				})
			}

			if self.progress == 1.0 {
				if let cb = completionHandler {
					DispatchQueue.main.async(execute: {
						cb()
					})
				}
			}

		}, withKey: CountdownNode.Constants.actionKey)
	}

	public func stopCountdown() {
		self.removeAction(forKey: CountdownNode.Constants.actionKey)
	}

	public func reset() {
		self.updateProgress(node: self.timeNode)
	}
}
