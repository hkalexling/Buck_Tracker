//
//  AWScrollView.swift
//  AWScrollView-Lab
//
//  Created by Alex Ling on 8/11/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

extension CGFloat{
	func closeTo(anotherFloat : CGFloat)-> Bool {
		return abs(self - anotherFloat) <= 0.5
	}
}

class AWScrollView: UIScrollView, UIScrollViewDelegate{
	
	var xExtension : CGFloat = UIScreen.mainScreen().bounds.size.width/2
	var yExtension : CGFloat = UIScreen.mainScreen().bounds.size.height/2
	
	let screenWidth = UIScreen.mainScreen().bounds.size.width
	let screenHeight = UIScreen.mainScreen().bounds.size.height
	
	var upPoint : CGPoint!
	var leftPoint : CGPoint!
	var rightPoint : CGPoint!
	var downPoint : CGPoint!
	var centerPoint : CGPoint!
	
	var transitionTime : NSTimeInterval = 0.5
	
	var mainView : UIView!
	
	enum ScrollDirection {
		case Up
		case Down
		
		case Left
		case Right
		
		case None
	}
	
	func setUp(){
		
		self.upPoint = CGPointMake(self.xExtension, 0)
		self.leftPoint = CGPointMake(0, self.yExtension)
		self.rightPoint = CGPointMake(2 * self.xExtension, self.yExtension)
		self.downPoint = CGPointMake(self.xExtension, 2 * self.yExtension)
		self.centerPoint = CGPointMake(self.xExtension, self.yExtension)
		
		self.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight)
		self.contentOffset = CGPointMake(self.xExtension, self.yExtension)
		self.contentSize = CGSizeMake(self.screenWidth + 2 * self.xExtension, self.screenHeight + 2 * self.yExtension)
		self.delegate = self
		self.showsHorizontalScrollIndicator = false
		self.showsVerticalScrollIndicator = false
		self.directionalLockEnabled = true
		self.bounces = false
		self.scrollEnabled = false
		
		self.mainView = UIView(frame: CGRectMake(self.xExtension, self.yExtension, self.screenWidth, self.screenHeight))
		self.mainView.backgroundColor = UIColor.clearColor()
		
		let tapRec = UITapGestureRecognizer(target: self, action: Selector("mainViewTapped"))
		self.mainView.addGestureRecognizer(tapRec)
		
		self.addSubview(self.mainView)
		
		let panRec = UIPanGestureRecognizer(target: self, action: Selector("paned:"))
		self.addGestureRecognizer(panRec)
	}
	
	func mainViewTapped(){
		self.scrollTo(CGPointMake(self.xExtension, self.yExtension))
	}
	
	func paned(sender : UIPanGestureRecognizer){
		if sender.state == UIGestureRecognizerState.Began{
			var scrollDir = ScrollDirection.None
			let translation = sender.translationInView(self)
			if abs(translation.x) > abs(translation.y){
				if translation.x > 0 {
					scrollDir = .Left
				}
				else{
					scrollDir = .Right
				}
			}
			else if abs(translation.x) < abs(translation.y){
				if translation.y > 0 {
					scrollDir = .Up
				}
				else{
					scrollDir = .Down
				}
			}
			if scrollDir != .None {
				self.handleScrollDir(scrollDir)
			}
		}
	}
	
	func handleScrollDir(direction : ScrollDirection){
		var offset = self.contentOffset
		if direction == .Up {
			if self.contentOffset.x.closeTo(self.xExtension) {
				if self.contentOffset.y.closeTo(2 * self.yExtension) {
					offset = CGPointMake(self.xExtension, self.yExtension)
				}
				if self.contentOffset.y.closeTo(self.yExtension) {
					offset = CGPointMake(self.xExtension, 0)
				}
			}
		}
			
		else if direction == .Down {
			if self.contentOffset.x.closeTo(self.xExtension) {
				if self.contentOffset.y.closeTo(0) {
					offset = CGPointMake(self.xExtension, self.yExtension)
				}
				if self.contentOffset.y.closeTo(self.yExtension) {
					offset = CGPointMake(self.xExtension, 2 * self.yExtension)
				}
			}
		}
			
		else if direction == .Left {
			if self.contentOffset.y.closeTo(self.yExtension) {
				if self.contentOffset.x.closeTo(2 * self.xExtension) {
					offset = CGPointMake(self.xExtension, self.yExtension)
				}
				if self.contentOffset.x.closeTo(self.xExtension) {
					offset = CGPointMake(0, self.yExtension)
				}
			}
		}
			
		else if direction == .Right {
			if self.contentOffset.y.closeTo(self.yExtension) {
				if self.contentOffset.x.closeTo(0) {
					offset = CGPointMake(self.xExtension, self.yExtension)
				}
				if self.contentOffset.x.closeTo(self.xExtension) {
					offset = CGPointMake(2 * self.xExtension, self.yExtension)
				}
			}
		}
		self.scrollTo(offset)
	}
	
	func scrollTo(point : CGPoint){
		UIView.animateWithDuration(self.transitionTime, animations: {
			self.contentOffset = point
			}, completion: nil)
	}
}

