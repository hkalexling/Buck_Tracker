//
//  CalendarViewController.swift
//  Buck Tracker
//
//  Created by Alex Ling on 11/11/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, JTCalendarDelegate{

	@IBOutlet weak var contentView: JTVerticalCalendarView!
	@IBOutlet weak var weekdayView: JTCalendarWeekDayView!
	@IBOutlet weak var menuView: JTCalendarMenuView!
	
	let manager : JTCalendarManager = JTCalendarManager()
	
    override func viewDidLoad() {
        super.viewDidLoad()

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

	override func viewWillAppear(animated: Bool) {
		self.manager.reload()
	}
	
	func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
		let realDayView = dayView as! JTCalendarDayView
		
		realDayView.textLabel.font = UIFont(name: realDayView.textLabel.font.fontName, size: 20)
		//today
		if self.sameDay(realDayView.date, nonLocalDayB: NSDate()) {
			realDayView.circleView.hidden = false
			realDayView.circleView.backgroundColor = UIColor.themeColor()
			realDayView.textLabel.textColor = UIColor.whiteColor()
			
			realDayView.dotView.hidden = true
		}
		else{
			realDayView.circleView.hidden = true
			
			//days in other months
			if realDayView.date.toLocalTime().extract().month != self.contentView.date.toLocalTime().extract().month {
				realDayView.textLabel.textColor = UIColor.whiteColor()
				realDayView.dotView.hidden = true
			}
				//other days in the same month
			else if realDayView.date.toLocalTime().extract().month == self.contentView.date.toLocalTime().extract().month {
				realDayView.textLabel.textColor = UIColor.blackColor()
				realDayView.dotView.hidden = true
			}
		}
	}
	
	func sameDay(nonLocalDayA: NSDate , nonLocalDayB: NSDate) -> Bool{
		let a = nonLocalDayA.toLocalTime().extract()
		let b = nonLocalDayB.toLocalTime().extract()
		return a.year == b.year && a.month == b.month && a.day == b.day
	}

}
