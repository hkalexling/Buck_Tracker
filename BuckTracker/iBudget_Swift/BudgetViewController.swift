//
//  BudgetViewController.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 5/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class BudgetViewController: UIViewController{
	
	@IBOutlet weak var heightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var progress: MCPercentageDoughnutView!
	@IBOutlet weak var upperDescriptionLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	var dayBudget : Double!
	var monthBudget : Double!
	
	var pageIndex : Int!
	
	var isDayBudget : Bool!
	
	let defaults = NSUserDefaults.standardUserDefaults()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if CGSize.screenSize().height < 500 {
			//4s
			self.heightConstraint.constant = 200
		}
		
    }
	
	override func viewWillAppear(animated: Bool) {
		
		self.dayBudget = self.defaults.doubleForKey("dailyBudget")
		self.monthBudget = self.defaults.doubleForKey("monthlyBudget")
		
		self.progress.linePercentage = 0.15
		self.progress.animationDuration = 0.5
		self.progress.decimalPlaces = 1
		self.progress.showTextLabel = true
		self.progress.animatesBegining = true
		self.progress.fillColor = UIColor.themeColor()
		self.progress.unfillColor = MCUtil.iOS7DefaultGrayColorForBackground()
		self.progress.enableGradient = true
		self.progress.gradientColor1 = UIColor.themeColor()
		self.progress.gradientColor2 = MCUtil.iOS7DefaultGrayColorForBackground()
		
		if self.isDayBudget == true {
			let moneySpend = self.moneySpendOfDay(NSDate())
			self.progress.percentage = CGFloat(moneySpend/self.dayBudget)
			let formatter : NSDateFormatter = NSDateFormatter()
			formatter.dateFormat = "MMM dd, yyyy".localized
			formatter.timeZone = NSTimeZone.localTimeZone()
			
			self.descriptionLabel.text = "\(moneySpend) / \(self.dayBudget)"
			self.upperDescriptionLabel.text = formatter.stringFromDate(NSDate())
		}
		else{
			let currentDay = NSDate().extractNonLocalDate().day
			var moneySpendInMonth : Double = 0
			for var i = 0; i < currentDay; i += 1 {
				let j = -i
				let cal = NSCalendar.currentCalendar()
				let comp = NSDateComponents()
				comp.day = j
				let date = cal.dateByAddingComponents(comp, toDate: NSDate(), options: NSCalendarOptions.MatchStrictly)!
				 moneySpendInMonth += self.moneySpendOfDay(date)
			}
			self.progress.percentage = CGFloat(moneySpendInMonth/self.monthBudget)
			
			let formatter : NSDateFormatter = NSDateFormatter()
			formatter.dateFormat = "MMM, yyyy"
			formatter.timeZone = NSTimeZone.localTimeZone()
			
			self.descriptionLabel.text = "\(moneySpendInMonth) / \(self.monthBudget)"
			self.upperDescriptionLabel.text = formatter.stringFromDate(NSDate())
		}
	}
	
	func moneySpendOfDay(didntlocalizedDate : NSDate) -> Double{
		let str : String = didntlocalizedDate.toStringFromNonLocalDate()
		var moneySpend : Double = 0
		if let data = defaults.objectForKey(str) as! NSData? {
			if let stored = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Record]? {
				for s in stored {
					let money = (s.money as NSString).doubleValue
					if money < 0 {
						moneySpend += money * -1
					}
				}
			}
		}
		return moneySpend
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
