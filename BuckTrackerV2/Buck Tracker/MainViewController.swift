//
//  MainViewController.swift
//  Buck Tracker
//
//  Created by Alex Ling on 11/11/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

	@IBOutlet weak var awScrollView: AWScrollView!
	
	var screenWidth : CGFloat!
	var screenHeight : CGFloat!
	
	var mainButtonView : UIButton!
	
	var buttons : [UIButton] = []
	var buttonNum : Int = 4
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.setupAWScrollView()
		self.setupAWButton()
		
    }
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	func setupAWScrollView(){
		self.awScrollView.xExtension = CGSize.screenSize().width * 0.75
		self.awScrollView.yExtension = CGSize.screenSize().height * 0.75
		
		self.awScrollView.backgroundColor = UIColor.themeColor()
		self.awScrollView.transitionTime = 0.8
		
		self.awScrollView.setUp()
		
		
		let calendarView = UIView(frame: CGRectMake(CGSize.screenSize().width/2 - 175, CGSize.screenSize().height/2 - 175, 350, 350))
		self.awScrollView.mainView.addSubview(calendarView)
		
		self.awScrollView.mainView.backgroundColor = UIColor.themeColor()
		
		
		let calendarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("calendarVC") as! CalendarViewController
		self.addChildViewController(calendarVC)
		calendarVC.view.frame = CGRectMake(0, 0, calendarView.frame.width, calendarView.frame.height)
		calendarView.addSubview(calendarVC.view)
	}
	
	func setupAWButton(){
		self.screenWidth = UIScreen.mainScreen().bounds.size.width
		self.screenHeight = UIScreen.mainScreen().bounds.size.height
		
		let buttonSize : CGFloat = 30
		self.mainButtonView = UIButton(frame: CGRectMake(30, self.screenHeight - 60, buttonSize, buttonSize))
		self.mainButtonView.backgroundColor = UIColor.clearColor()
		self.mainButtonView.layer.cornerRadius = buttonSize/2
		self.mainButtonView.clipsToBounds = true
		self.mainButtonView.addTarget(self, action: Selector("mainButtonTapped"), forControlEvents: .TouchDown)
		self.mainButtonView.setImage(UIImage(named: "more"), forState: .Normal)
		self.mainButtonView.adjustsImageWhenHighlighted = false
		self.view.addSubview(self.mainButtonView)
		
		for i in 0..<buttonNum {
			let button = UIButton(frame: self.mainButtonView.frame)
			button.backgroundColor = UIColor.clearColor()
			button.layer.cornerRadius = buttonSize/2
			button.clipsToBounds = true
			button.setTitle("\(i)", forState: .Normal)
			button.setImage(UIImage(named: "\(i)"), forState: .Normal)
			button.addTarget(self, action: Selector("optionButtonTapped:"), forControlEvents: .TouchDown)
			button.adjustsImageWhenHighlighted = false
			self.buttons.append(button)
			self.view.addSubview(button)
		}
		
		self.view.bringSubviewToFront(self.mainButtonView)
	}
	
	func mainButtonTapped(){
		if self.buttons.first!.center == self.mainButtonView.center {
			self.openButtons()
		}
		else{
			self.closeButtons()
		}
	}
	
	func optionButtonTapped(sender : UIButton){
		let id = sender.currentTitle!
		switch id{
		case "0":
			self.awScrollView.scrollTo(self.awScrollView.upPoint)
		case "1":
			self.awScrollView.scrollTo(self.awScrollView.leftPoint)
		case "2":
			self.awScrollView.scrollTo(self.awScrollView.rightPoint)
		case "3":
			self.awScrollView.scrollTo(self.awScrollView.downPoint)
		default:
			return
		}
		self.closeButtons()
	}
	
	func openButtons(){
		for i in 0..<self.buttonNum{
			
			let theta : CGFloat = -CGFloat(i) * CGFloat(M_PI/2)/CGFloat(self.buttonNum - 1)
			let button = self.buttons[i]
			let point = CGPointMake(self.buttons[i].center.x + 100 * cos(theta), self.buttons[i].center.y + 100 * sin(theta))
			let delay = NSTimeInterval(i) * 0.05
			
			UIView.animateWithDuration(0.5, delay: 0.05 * NSTimeInterval(self.buttonNum - 1) - delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {
				button.center = point
				}, completion:  nil)
		}
	}
	
	func closeButtons(){
		for i in 0..<self.buttonNum{

			let button = self.buttons[i]
			let delay = NSTimeInterval(i) * 0.05
			
			UIView.animateWithDuration(0.5, delay: delay + 0.1, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: [], animations: {
				button.center = self.mainButtonView.center
				}, completion:  {(finished) in
					button.transform = CGAffineTransformMakeRotation(0)
			})
			let animation = CABasicAnimation(keyPath: "transform.rotation")
			animation.duration = 0.5
			animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
			animation.toValue = NSNumber(float: Float(M_PI) * 8)
			button.layer.addAnimation(animation, forKey: nil)
		}
	}

}
