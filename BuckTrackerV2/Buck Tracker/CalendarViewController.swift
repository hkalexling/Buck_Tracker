//
//  CalendarViewController.swift
//  Buck Tracker
//
//  Created by Alex Ling on 11/11/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, JTCalendarDelegate{
	
	//Calendar stuff
	@IBOutlet weak var contentView: JTVerticalCalendarView!
	@IBOutlet weak var weekdayView: JTCalendarWeekDayView!
	@IBOutlet weak var menuView: JTCalendarMenuView!
	@IBOutlet weak var holderView: UIView!
	
	let manager : JTCalendarManager = JTCalendarManager()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.setupCalendar()
    }

	override func viewWillAppear(animated: Bool) {
		self.manager.reload()
	}
	
	func setupCalendar(){
		self.contentView.backgroundColor = UIColor.themeColor()
		self.weekdayView.backgroundColor = UIColor.themeColor()
		self.menuView.backgroundColor = UIColor.themeColor()
		self.holderView.backgroundColor = UIColor.themeColor()
		
		self.manager.delegate = self
		self.manager.settings.pageViewHaveWeekDaysView = false
		self.manager.settings.pageViewNumberOfWeeks = 0
		
		self.weekdayView.manager = self.manager
		self.weekdayView.reload()
		
		self.manager.menuView = self.menuView
		self.manager.contentView = self.contentView
		self.manager.setDate(NSDate().toLocalTime())
		
		self.menuView.scrollView.scrollEnabled = false
	}
	
	func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
		let realDayView = dayView as! JTCalendarDayView
		
		realDayView.textLabel.font = UIFont(name: realDayView.textLabel.font.fontName, size: 20)
		
		
		//dateView is today
		if self.sameDay(realDayView.date.toLocalTime(), dayB: NSDate().toLocalTime()){
			realDayView.hidden = false
			realDayView.circleView.hidden = false
			realDayView.circleView.backgroundColor = self.contentView.date.toLocalTime().extract().month == NSDate().toLocalTime().extract().month ? UIColor.whiteColor() : UIColor.themeColor()
			realDayView.textLabel.textColor = UIColor.themeColor()
		}
		else {
			
			realDayView.circleView.hidden = true
			//dateView in other month
			if realDayView.date.toLocalTime().extract().month != self.contentView.date.toLocalTime().extract().month {
				realDayView.hidden = true
			}
			//dateView in other days in this month
			else{
				realDayView.hidden = false
				realDayView.textLabel.textColor = UIColor.whiteColor()
			}
		}
	}
	
	func calendar(calendar: JTCalendarManager!, prepareMenuItemView menuItemView: UIView!, date: NSDate!) {
		let realItemView = menuItemView as! UILabel
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "MMMM yyyy"
		dateFormatter.timeZone = NSTimeZone.localTimeZone()
		realItemView.text = dateFormatter.stringFromDate(date)
		realItemView.textColor = UIColor.whiteColor()
	}
	
	func sameDay(dayA: NSDate , dayB: NSDate) -> Bool{
		let a = dayA.extract()
		let b = dayB.extract()
		return a.year == b.year && a.month == b.month && a.day == b.day
	}
}
