//
//  Modified from ProgressNode.swift
//
//  Created by Tibor Bodecs on 06/02/15.
//  Copyright (c) 2015 Tibor Bodecs. All rights reserved.
//

import SpriteKit

class ProgressNode : SKShapeNode {

	//MARK: constants

	struct Constants {
		static let progress : CGFloat = 1.0
		static let actionKey = "_ProgressNodeActionKey"
	}


	//MARK: properties

	//the current progress of the progress node
	//end progress is 1.0 and start is 0.0
	public var progress : CGFloat = ProgressNode.Constants.progress {
		didSet {
			self.drawNode(node: self.timeNode, progress: self.progress)
		}
	}

	public var actionKey : String = ProgressNode.Constants.actionKey {
		willSet {
			self.stopCount()
		}
	}

	internal let timeNode = SKShapeNode()


	//MARK: init

	override init() {
		super.init()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}


	//MARK: helpers

	internal func drawNode(node: SKShapeNode, progress: CGFloat = 0.0) {
		print("drawNode not implemented")
	}


	//MARK: API

	public func countup(time: TimeInterval = 1.0,
	                    completionHandler: ((Void) -> Void)?) {
		self.countup (
			time: time, progressHandler: nil,
			completionHandler: completionHandler
		)
	}

	public func countup(time: TimeInterval = 1.0,
	                    progressHandler: ((Void) -> Void)?,
	                    completionHandler: ((Void) -> Void)?) {
		self.stopCount()

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

		}, withKey: self.actionKey)
	}

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
		self.stopCount()

		self.run(SKAction.customAction(withDuration: time) {
			(node: SKNode!, elapsedTime: CGFloat) in

			self.progress = 1.0 - elapsedTime / CGFloat(time)

			if let cb = progressHandler {
				DispatchQueue.main.async(execute: {
					cb()
				})
			}

			if self.progress == 0.0 {
				if let cb = completionHandler {
					DispatchQueue.main.async(execute: {
						cb()
					})
				}
			}

		}, withKey: self.actionKey)
	}

	public func stopCount() {
		self.removeAction(forKey: self.actionKey)
	}
}

class CircleProgressNode : ProgressNode {

	//MARK: constants

	struct Constants {
		static let radius     : CGFloat = 32
		static let width      : CGFloat = 2.0
		static let startAngle : CGFloat = CGFloat(Double.pi)
	}


	//MARK: properties

	/// the radius of the progress node
	public var radius: CGFloat = CircleProgressNode.Constants.radius {
		didSet {
			self.drawNode(node: self.timeNode, progress: self.progress)
			self.drawNode(node: self)
		}
	}

	//the active time color
	public var color: SKColor = DefaultConstants.color {
		didSet {
			self.timeNode.strokeColor = self.color
			self.drawNode(node: self.timeNode)
		}
	}

	//the background color of the timer (to hide: use clear color)
	public var backgroundColor: SKColor = DefaultConstants.backgroundColor {
		didSet {
			self.strokeColor = self.backgroundColor
			self.drawNode(node: self)
		}
	}

	///the line width of the progress node
	public var width: CGFloat = CircleProgressNode.Constants.width {
		didSet {
			self.timeNode.lineWidth = self.width
			self.lineWidth          = self.width
		}
	}

	// the start angle of the progress node
	public var startAngle: CGFloat = CircleProgressNode.Constants.startAngle {
		didSet {
			self.drawNode(node: self.timeNode, progress: self.progress)
		}
	}


	//MARK: init

	public init(radius: CGFloat = CircleProgressNode.Constants.radius,
	            color: SKColor = DefaultConstants.color,
	            backgroundColor: SKColor = DefaultConstants.backgroundColor,
	            width: CGFloat = CircleProgressNode.Constants.width,
	            progress: CGFloat = ProgressNode.Constants.progress) {

		super.init()

		self.radius          = radius
		self.color           = color
		self.backgroundColor = backgroundColor
		self.width           = width
		self.progress        = progress

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
		self.timeNode.lineWidth   = self.width
		self.timeNode.strokeColor = self.color
		self.timeNode.zPosition   = self.zPosition + 1
		self.timeNode.position    = CGPoint.zero

		self.addChild(self.timeNode)
		self.drawNode(node: self.timeNode, progress: self.progress)

		self.lineWidth   = self.width
		self.strokeColor = self.backgroundColor

		self.drawNode(node: self)
	}

	override internal func drawNode(node: SKShapeNode, progress: CGFloat = ProgressNode.Constants.progress) {
		let startAngle = self.startAngle - CGFloat(.pi / 2.0)
		let endAngle   = startAngle + progress*CGFloat(2.0 * .pi)
		node.path      = UIBezierPath(arcCenter: CGPoint.zero,
		                              radius: self.radius,
		                              startAngle: startAngle,
		                              endAngle: endAngle,
		                              clockwise: true).cgPath
	}
}

class BarProgressNode : ProgressNode {

	//MARK: constants

	struct Constants {
		static let length     : CGFloat = 50.0
		static let width      : CGFloat = 2.0
	}


	//MARK: properties

	/// the radius of the progress node
	public var length: CGFloat = BarProgressNode.Constants.length {
		didSet {
			self.drawNode(node: self.timeNode, progress: self.progress)
			self.drawNode(node: self)
		}
	}

	//the active time color
	public var color: SKColor = DefaultConstants.color {
		didSet {
			self.timeNode.strokeColor = self.color
			drawNode(node: self)
		}
	}

	//the background color of the timer (to hide: use clear color)
	public var backgroundColor: SKColor = DefaultConstants.backgroundColor {
		didSet {
			self.strokeColor = self.backgroundColor
			drawNode(node: self)
		}
	}

	///the line width of the progress node
	public var width: CGFloat = BarProgressNode.Constants.width {
		didSet {
			self.timeNode.lineWidth = self.width
			self.lineWidth          = self.width
		}
	}


	//MARK: init

	public init(length: CGFloat = BarProgressNode.Constants.length,
	            width: CGFloat = BarProgressNode.Constants.width,
	            color: SKColor = DefaultConstants.color,
	            backgroundColor: SKColor = DefaultConstants.backgroundColor,
	            progress: CGFloat = ProgressNode.Constants.progress) {

		super.init()

		self.length          = length
		self.width           = width
		self.color           = color
		self.backgroundColor = backgroundColor
		self.progress        = progress

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
		self.timeNode.lineWidth   = self.width
		self.timeNode.strokeColor = self.color
		self.timeNode.zPosition   = self.zPosition + 1
		self.timeNode.position    = CGPoint.zero

		self.addChild(self.timeNode)
		self.drawNode(node: self.timeNode, progress: self.progress)

		self.lineWidth   = self.width
		self.strokeColor = self.backgroundColor

		self.drawNode(node: self)
	}

	override internal func drawNode(node: SKShapeNode, progress: CGFloat = ProgressNode.Constants.progress) {
		let startPos = -self.length/2
		let endPos   = startPos + self.length * progress

		let path = UIBezierPath()
		path.move   (to: CGPoint(x: startPos, y: 0))
		path.addLine(to: CGPoint(x: endPos, y: 0))
		node.path = path.cgPath
	}
}
