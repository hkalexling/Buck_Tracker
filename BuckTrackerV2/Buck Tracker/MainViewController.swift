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
	
    override func viewDidLoad() {
        super.viewDidLoad()

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
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
}
