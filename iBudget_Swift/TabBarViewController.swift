//
//  TabBarViewController.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 1/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//
//  For the brave souls who are maintaining this file: You are the chosen ones,
//  the valiant knights of programming who toil away, without rest,
//  fixing our most awful code.
//
//  To you, true saviors, kings of men,
//  I say this: never gonna give you up, never gonna let you down,
//  never gonna run around and desert you. Never gonna make you cry,
//  never gonna say goodbye. Never gonna tell a lie and hurt you.
//

import UIKit
import Charts

class TabBarViewController: UITabBarController, UITabBarControllerDelegate{
	
	let defaults = NSUserDefaults.standardUserDefaults()
	
	var tabToSelect : Int?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.delegate = self
		
		self.tabBar.barTintColor = UIColor.themeColor()
		
		self.createAndAddCalendarVC()
		self.budgetTab()
		self.createAndAddNewRecordTab()
		self.chart()
		self.settingTab()
		
		let selectedColor = UIColor.whiteColor()
		
		self.tabBar.tintColor = selectedColor
		
		UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object: selectedColor, forKey: NSForegroundColorAttributeName) as? [String : AnyObject], forState: UIControlState.Selected)
		
		let unselectedColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
		
		UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object: unselectedColor, forKey: NSForegroundColorAttributeName) as? [String : AnyObject], forState: UIControlState.Normal)
		
		for item : UITabBarItem in self.tabBar.items! {
			item.image = item.selectedImage!.coloredImage(unselectedColor).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
		}
		
		if self.tabToSelect != nil {
			self.selectedIndex = self.tabToSelect!
		}
    }
	
	override func viewDidAppear(animated: Bool) {
		if let _ = self.defaults.objectForKey("tabToSelect") {
			if let stored = self.defaults.integerForKey("tabToSelect") as Int? {
				if stored != -1 {
					self.defaults.setInteger(-1, forKey: "tabToSelect")
					self.selectedIndex = stored
				}
			}
		}
	}

	func createAndAddCalendarVC(){
		let calendarVC : CalendarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("calendarVC") as! CalendarViewController
		
		let navController = UINavigationController()
		navController.title = "Calendar"
		navController.navigationBar.barTintColor = UIColor.themeColor()
		navController.navigationBar.tintColor = UIColor.whiteColor()
		navController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]

		navController.viewControllers.append(calendarVC)
		
		calendarVC.parentNacController = navController

		guard var VCs = self.viewControllers as [UIViewController]? else{
			self.setViewControllers([navController], animated: false)
			navController.tabBarItem.image = UIImage(named: "Calendar Icon")
			return
		}
		VCs.append(navController)
		self.setViewControllers(VCs, animated: false)

		navController.tabBarItem.image = UIImage(named: "Calendar Icon")
	}
	
	func budgetTab(){
		let budgetVC : ParentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("parentVC") as! ParentViewController
		let nav : UINavigationController = UINavigationController(rootViewController: budgetVC)
		nav.title = "Budget"
		nav.navigationBar.barTintColor = UIColor.themeColor()
		nav.navigationBar.tintColor = UIColor.whiteColor()
		
		guard var VCs = self.viewControllers as [UIViewController]? else{
			self.setViewControllers([nav], animated: false)
			nav.tabBarItem.image = UIImage(named: "Budget")
			return
		}
		VCs.append(nav)
		self.setViewControllers(VCs, animated: false)
		nav.tabBarItem.image = UIImage(named: "Budget")
	}
	
	func createAndAddNewRecordTab(){

		let dayVC : DayTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("dayTableVC") as! DayTableViewController
		dayVC.selectedDate = NSDate()
		let newVC : NewRecordTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("newRecordTableVC") as! NewRecordTableViewController
		newVC.parentVC = dayVC
		
		let navCon = UINavigationController()
		navCon.viewControllers.append(dayVC)
		navCon.viewControllers.append(newVC)
		
		navCon.title = "New Record"
		navCon.navigationBar.barTintColor = UIColor.themeColor()
		navCon.navigationBar.tintColor = UIColor.whiteColor()
		navCon.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
		
		guard var VCs = self.viewControllers as [UIViewController]? else{
			self.setViewControllers([navCon], animated: false)
			navCon.tabBarItem.image = UIImage(named: "New")
			return
		}
		VCs.append(navCon)
		self.setViewControllers(VCs, animated: false)
		navCon.tabBarItem.image = UIImage(named: "New")
	}
	
	func chart(){
		
		let chartVC : BarChartViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("chartVC") as! BarChartViewController
		let chartNavVC  = UINavigationController(rootViewController: chartVC)
		chartNavVC.title = "Stats"
		chartNavVC.navigationBar.barTintColor = UIColor.themeColor()
		chartNavVC.navigationBar.tintColor = UIColor.whiteColor()
		
		guard var VCs = self.viewControllers as [UIViewController]? else{
			self.setViewControllers([chartNavVC], animated: false)
			chartNavVC.tabBarItem.image = UIImage(named: "Stats")
			return
		}
		VCs.append(chartNavVC)
		self.setViewControllers(VCs, animated: false)
		chartNavVC.tabBarItem.image = UIImage(named: "Stats")
	}
	
	func settingTab(){
		
		let settingVC : SettingTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("settingTableVC") as! SettingTableViewController
		let settingNavVc = UINavigationController(rootViewController: settingVC)
		settingNavVc.title = "Settings"
		settingNavVc.navigationBar.barTintColor = UIColor.themeColor()
		settingNavVc.navigationBar.tintColor = UIColor.whiteColor()
		
		guard var VCs = self.viewControllers as [UIViewController]? else{
			self.setViewControllers([settingNavVc], animated: false)
			settingNavVc.tabBarItem.image = UIImage(named: "Settings")
			return
		}
		VCs.append(settingNavVc)
		self.setViewControllers(VCs, animated: false)
		settingNavVc.tabBarItem.image = UIImage(named: "Settings")
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
