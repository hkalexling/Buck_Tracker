//
//  AppDelegate.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 30/9/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//
// For the brave souls who get this far: You are the chosen ones,
// the valiant knights of programming who toil away, without rest,
// fixing our most awful code. To you, true saviors, kings of men,
// I say this: never gonna give you up, never gonna let you down,
// never gonna run around and desert you. Never gonna make you cry,
// never gonna say goodbye. Never gonna tell a lie and hurt you.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	let defaults = NSUserDefaults.standardUserDefaults()

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		self.window!.backgroundColor = UIColor.whiteColor()
		
		let pageControl = UIPageControl.appearance()
		pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
		pageControl.currentPageIndicatorTintColor = UIColor.themeColor()
		pageControl.backgroundColor = UIColor.whiteColor()
		
		//set default payment method if hasn't been set
		if let _ = self.defaults.objectForKey("defaultPaymentMethod") as! NSData? {
		}
		else{
			let defaultMethod = Method.allMethods()[0]
			let data = NSKeyedArchiver.archivedDataWithRootObject(defaultMethod)
			self.defaults.setObject(data, forKey: "defaultPaymentMethod")
		}
		
		//set budget if hasn't been set
		if let _ = self.defaults.objectForKey("dailyBudget") as! Double? {
		}
		else{
			self.defaults.setDouble(150, forKey: "dailyBudget")
		}
		
		if let _ = self.defaults.objectForKey("monthlyBudget") as! Double? {
		}
		else{
			self.defaults.setDouble(4000, forKey: "monthlyBudget")
		}
		
		return true
	}
	
	
	@available(iOS 9.0, *)
	func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
		completionHandler( handleShortcut(shortcutItem) )
	}
	
	@available(iOS 9.0, *)
	func handleShortcut( shortcutItem:UIApplicationShortcutItem ) -> Bool {
		var succeeded = false
		if( shortcutItem.type == "newRecord" ) {
			succeeded = true
			
			self.defaults.setInteger(2, forKey: "tabToSelect")
		}
		return succeeded
	}
	
	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
}

