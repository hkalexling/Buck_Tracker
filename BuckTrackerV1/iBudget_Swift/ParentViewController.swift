//
//  ParentViewController.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 5/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController, UIPageViewControllerDataSource{

	var pageViewController: UIPageViewController!
	var pageTitles: NSArray!
	var pageImages: NSArray!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("pageVC") as! UIPageViewController
		self.pageViewController.dataSource = self
		
		let startVC = self.viewControllerAtIndex(0) as BudgetViewController
		let viewControllers = NSArray(object: startVC)
		
		self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
		
		self.addChildViewController(self.pageViewController)
		self.view.addSubview(self.pageViewController.view)
		self.pageViewController.didMoveToParentViewController(self)
		
		let frame : CGRect = self.pageViewController.view.frame
		self.pageViewController.view.frame = CGRectMake(0, 44, frame.width, frame.height - 50 - 44)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func viewControllerAtIndex(index : Int) -> BudgetViewController {
		let vc: BudgetViewController = self.storyboard?.instantiateViewControllerWithIdentifier("budgetVC") as! BudgetViewController
		
		vc.pageIndex = index
		
		if index == 0 {
			vc.isDayBudget = true
		}
		else{
			vc.isDayBudget = false
		}
		
		return vc
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?{
		
		let vc = viewController as! BudgetViewController
		var index = vc.pageIndex as Int
		
		if (index == 0 || index == NSNotFound){
			return nil
		}
		
		index--
		return self.viewControllerAtIndex(index)
	}
	
	
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		
		let vc = viewController as! BudgetViewController
		var index = vc.pageIndex as Int
		
		if (index == NSNotFound){
			return nil
		}
		
		index++
		
		if (index == 2){
			return nil
		}
		return self.viewControllerAtIndex(index)
	}
	
	
	
	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int{
		return 2
	}
	
	
	func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int{
		return 0
	}

}
