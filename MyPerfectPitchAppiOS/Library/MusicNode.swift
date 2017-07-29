//
//  MusicNode.swift
//  SpriteKit extension
//
//  Reference: ProgressNode.swift
//  Created by Tibor Bodecs on 06/02/15.
//  Copyright (c) 2015 Tibor Bodecs. All rights reserved.
//

import SpriteKit



public class MusicNode : SKShapeNode {
	///////////////////////////////////////////////////////////////////////////////////////////////////
	//  MARK: constants
	///////////////////////////////////////////////////////////////////////////////////////////////////
	struct Constants {
		static let radius : CGFloat          = 32
		static let color : SKColor           = SKColor.darkGray
		static let backgroundColor : SKColor = SKColor.lightGray
		static let width : CGFloat           = 2.0
		static let progress : CGFloat        = 0.0
		static let startAngle : CGFloat      = CGFloat(Double.pi)
		static let actionKey         = "_MusicNodeCountdownActionKey"
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////
	//  MARK: properties
	///////////////////////////////////////////////////////////////////////////////////////////////////
	/// the radius of the progress node
	public var radius: CGFloat = MusicNode.Constants.radius {
		didSet {
			self.updateProgress(node: self.timeNode, progress: self.progress)
			self.updateProgress(node: self)
		}
	}

	//the active time color
	public var color: SKColor = MusicNode.Constants.color {
		didSet {
			self.timeNode.strokeColor = self.color
		}
	}

	//the background color of the timer (to hide: use clear color)
	public var backgroundColor: SKColor = MusicNode.Constants.backgroundColor {
		didSet {
			self.strokeColor = self.backgroundColor
		}
	}

	///the line width of the progress node
	public var width: CGFloat = MusicNode.Constants.width {
		didSet {
			self.timeNode.lineWidth = self.width
			self.lineWidth          = self.width
		}
	}

	//the current progress of the progress node end progress is 1.0 and start is 0.0
	public var progress: CGFloat = MusicNode.Constants.progress {
		didSet {
			self.updateProgress(node: self.timeNode, progress: self.progress)
		}
	}

	// the start angle of the progress node
	public var startAngle: CGFloat = MusicNode.Constants.startAngle {
		didSet {
			self.updateProgress(node: self.timeNode, progress: self.progress)
		}
	}

	private let timeNode = SKShapeNode()

	///////////////////////////////////////////////////////////////////////////////////////////////////
	//  MARK: init
	///////////////////////////////////////////////////////////////////////////////////////////////////
	public init(radius: CGFloat,
	            color: SKColor = MusicNode.Constants.color,
	            backgroundColor: SKColor = MusicNode.Constants.backgroundColor,
	            width: CGFloat = MusicNode.Constants.width,
	            progress: CGFloat = MusicNode.Constants.progress) {

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


	///////////////////////////////////////////////////////////////////////////////////////////////////
	//  MARK: helpers
	///////////////////////////////////////////////////////////////////////////////////////////////////
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

	///////////////////////////////////////////////////////////////////////////////////////////////////
	//  MARK: API
	///////////////////////////////////////////////////////////////////////////////////////////////////
	/*!
	 The countdown method counts down from a time interval to zero,
	 and it calls a callback on the main thread if its finished

	 :param: time     The time interval to count
	 :param: progressHandler   An optional callback method (always called on main thread)
	 :param: callback An optional callback method (always called on main thread)
	 */
	public func countdown(time: TimeInterval = 1.0, completionHandler: ((Void) -> Void)?) {
		self.countdown(time: time, progressHandler: nil, completionHandler: completionHandler)
	}

	public func countdown(time: TimeInterval = 1.0, progressHandler: ((Void) -> Void)?, completionHandler: ((Void) -> Void)?) {
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
		}, withKey: MusicNode.Constants.actionKey)
	}

	public func stopCountdown() {
		self.removeAction(forKey: MusicNode.Constants.actionKey)
	}
}
