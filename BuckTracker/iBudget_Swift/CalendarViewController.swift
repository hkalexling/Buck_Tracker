//
//  CalendarViewController.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 4/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, JTCalendarDelegate, UIPopoverPresentationControllerDelegate{

	@IBOutlet weak var menuView: JTCalendarMenuView!
	@IBOutlet weak var weekDayView: JTCalendarWeekDayView!
	@IBOutlet weak var contentView: JTVerticalCalendarView!
	@IBOutlet weak var thisMonthButton: GBFlatButton!
	@IBOutlet weak var jumpToButton: GBFlatButton!
	
	@IBOutlet weak var menuViewTopCons: NSLayoutConstraint!
	@IBOutlet weak var menuViewHeightCons: NSLayoutConstraint!
	@IBOutlet weak var weekdayViewHeightCons: NSLayoutConstraint!
	@IBOutlet weak var weekDayViewLeftCons: NSLayoutConstraint!
	@IBOutlet weak var weekDayViewRightCons: NSLayoutConstraint!
	@IBOutlet weak var contentViewLeftCons: NSLayoutConstraint!
	@IBOutlet weak var contentViewRightCons: NSLayoutConstraint!
	
	@IBOutlet weak var thisMonthButtonWidthCons: NSLayoutConstraint!
	
	let defaults = NSUserDefaults.standardUserDefaults()
	let screenSize : CGSize = UIScreen.mainScreen().bounds.size
	
	var selectedDate : NSDate?
	var parentNacController : UINavigationController?
	
	let manager : JTCalendarManager = JTCalendarManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if "language".localized == "cn" {
			NSLayoutConstraint.deactivateConstraints([self.thisMonthButtonWidthCons])
		}
		
		if UIDevice.currentDevice().model.containsString("iPad"){
			
			self.menuViewHeightCons.constant = CGSize.screenSize().height/12
			
			self.menuViewHeightCons.constant *= 2
			self.weekdayViewHeightCons.constant *= 2
			
			self.weekDayViewLeftCons.constant = CGSize.screenSize().width/6
			self.weekDayViewRightCons.constant = CGSize.screenSize().width/6
			
			self.contentViewLeftCons.constant = CGSize.screenSize().width/6
			self.contentViewRightCons.constant = CGSize.screenSize().width/6
		}
		
		self.thisMonthButton.tintColor = UIColor.themeColor()
		self.jumpToButton.tintColor = UIColor.themeColor()
		
		self.thisMonthButton.selected = true
		self.jumpToButton.selected = true
		
		self.manager.delegate = self
		self.manager.settings.pageViewHaveWeekDaysView = false
		self.manager.settings.pageViewNumberOfWeeks = 0
		
		self.weekDayView.manager = self.manager
		self.weekDayView.reload()
		
		self.manager.menuView = self.menuView
		self.manager.contentView = self.contentView
		self.manager.setDate(NSDate().toLocalTime())
		
		self.menuView.scrollView.scrollEnabled = false
	}
	
	override func viewWillAppear(animated: Bool) {
		self.manager.reload()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
		let realDayView = dayView as! JTCalendarDayView
		
		realDayView.textLabel.font = UIFont(name: realDayView.textLabel.font.fontName, size: 20)
		//today
		if self.sameDay(realDayView.date, nonLocalDayB: NSDate()) {
			realDayView.circleView.hidden = false
			realDayView.circleView.backgroundColor = self.contentView.date.extractNonLocalDate().month == NSDate().extractNonLocalDate().month ? UIColor.themeColor() : UIColor.whiteColor()
			realDayView.textLabel.textColor = UIColor.whiteColor()
			
			realDayView.dotView.hidden = true
		}
		else{
			realDayView.circleView.hidden = true
			
			//days in other months
			if realDayView.date.extractNonLocalDate().month != self.contentView.date.extractNonLocalDate().month {
				realDayView.textLabel.textColor = UIColor.whiteColor()
				realDayView.dotView.hidden = true
			}
			//other days in the same month
			else if realDayView.date.extractNonLocalDate().month == self.contentView.date.extractNonLocalDate().month {
				realDayView.textLabel.textColor = UIColor.blackColor()
				realDayView.dotView.hidden = false
				var dotColor : UIColor = UIColor()
				Yuno().backgroundThread({
						dotColor = self.decideDotColor(realDayView.date)
					}, completion: {
						realDayView.dotView.backgroundColor = dotColor
				})
			}
		}
	}
	
	func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
		let realDayView = dayView as! JTCalendarDayView
		
		if realDayView.date.extractNonLocalDate().month != self.contentView.date.extractNonLocalDate().month {
			return
		}
		self.selectedDate = realDayView.date
		let dayVC : DayTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("dayTableVC") as! DayTableViewController
		dayVC.selectedDate = self.selectedDate
		self.parentNacController!.pushViewController(dayVC, animated: true)
	}
	
	func calendar(calendar: JTCalendarManager!, prepareMenuItemView menuItemView: UIView!, date: NSDate!) {
		let realItemView = menuItemView as! UILabel
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "MMMM yyyy"
		dateFormatter.timeZone = NSTimeZone.localTimeZone()
		realItemView.text = dateFormatter.stringFromDate(date)
	}
	
	func sameDay(nonLocalDayA: NSDate , nonLocalDayB: NSDate) -> Bool{
		let a = nonLocalDayA.extractNonLocalDate()
		let b = nonLocalDayB.extractNonLocalDate()
		return a.year == b.year && a.month == b.month && a.day == b.day
	}
	
	func decideDotColor(date : NSDate) -> UIColor{
		let str : String = date.toStringFromNonLocalDate()
		var netMoney : Double = 0
		if let data = defaults.objectForKey(str) as! NSData? {
			if let stored = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Record]? {
				for s in stored {
					let moneyString = s.money as NSString
					netMoney += moneyString.doubleValue
				}
			}
		}

		if netMoney > 0 {
			return UIColor.greenColor().soften(0.9)
		}
		else if netMoney < 0{
			return UIColor.redColor().soften(0.9)
		}
		else{
			return UIColor.whiteColor()
		}
	}
	
	func adaptivePresentationStyleForPresentationController(
		controller: UIPresentationController) -> UIModalPresentationStyle {
			return .None
	}
	
	@IBAction func thisMonthButtonTapped(sender: GBFlatButton) {
		self.manager.setDate(NSDate().toLocalTime())
	}
	
	@IBAction func jumpToButtonTapped(sender: GBFlatButton) {
		let pickerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("monthPickerVC") as! MonthPickerViewController
		pickerVC.parentVC = self
		pickerVC.modalPresentationStyle = UIModalPresentationStyle.Popover
		
		var height : CGFloat = 0
		var width = self.screenSize.width
		if self.screenSize.height < 600 {
			height = 230 //4s, 5, 5s
		}
		else if self.screenSize.height < 700 {
			height = 250 //6, 6s
		}
		else if self.screenSize.height < 1000{
			height = 280 //6+, 6s+
		}
		else{ //iPad
			width *= 2/3
			height = width * 4/6
		}
		pickerVC.preferredContentSize = CGSizeMake(width, height)
		
		let popoverMenuViewController = pickerVC.popoverPresentationController
		popoverMenuViewController?.permittedArrowDirections = .Any
		popoverMenuViewController?.delegate = self
		popoverMenuViewController?.sourceView = self.jumpToButton
		popoverMenuViewController?.sourceRect = self.jumpToButton.frame
		presentViewController(
			pickerVC,
			animated: true,
			completion: nil)
	}
}
