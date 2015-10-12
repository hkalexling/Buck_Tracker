//
//  SettingTableViewController.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 3/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

	let defaults = NSUserDefaults.standardUserDefaults()
	
	var dailyBudgetTextField : UITextField!
	var monthlyBudgetTextField : UITextField!
	
	var defaultMethod : Method!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.tableFooterView = UIView()
		
		let tapRec = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
		tapRec.cancelsTouchesInView = false
		self.tableView.addGestureRecognizer(tapRec)
    }
	
	func hideKeyboard(){
		self.view.endEditing(true)
		self.saveBudget()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	override func viewWillAppear(animated: Bool) {
		
		if let data = self.defaults.objectForKey("defaultPaymentMethod") as! NSData? {
			if let stored = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Method? {
				self.defaultMethod = stored
			}
		}
		
		self.tableView.reloadData()
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return ""
		}
		else{
			return " "
		}
	}

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		if section == 0 {
			return 1
		}
		if section == 1 {
			return 2
		}
		if section == 2 {
			return 2
		}
		return 0
    }

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier("defaultPaymentMethodCell", forIndexPath: indexPath) as! DefaultPaymentMethodCell
			
			cell.nameLabel.text = self.defaultMethod.name
			cell.colorImageView.image = UIImage.imageWithColor(self.defaultMethod.color)
			cell.colorImageView.layer.cornerRadius = cell.colorImageView.frame.size.height * 0.5
			cell.colorImageView.layer.masksToBounds = true
			
			return cell
		}
		if indexPath.section == 1 {
			let cell = tableView.dequeueReusableCellWithIdentifier("budgetCell", forIndexPath: indexPath) as! BudgetCell
			
			if indexPath.row == 0 {
				cell.budgetTypeLabel.text = "Daily Budget"
				self.dailyBudgetTextField = cell.budgetTextField
				
				if let stored = self.defaults.doubleForKey("dailyBudget") as Double? {
					cell.budgetTextField.placeholder = "\(stored)"
				}
			}
			else{
				cell.budgetTypeLabel.text = "Monthly Budget"
				self.monthlyBudgetTextField = cell.budgetTextField
				
				if let stored = self.defaults.doubleForKey("monthlyBudget") as Double? {
					cell.budgetTextField.placeholder = "\(stored)"
				}
			}
			
			return cell
		}
		if indexPath.section == 2 {
			if indexPath.row == 0 {
				let cell = tableView.dequeueReusableCellWithIdentifier("aboutCell", forIndexPath: indexPath)
				return cell
			}
			if indexPath.row == 1 {
				let cell = tableView.dequeueReusableCellWithIdentifier("supportCell", forIndexPath: indexPath)
				return cell
			}
		}
		return UITableViewCell()
    }
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 {
			if indexPath.row == 0 {
				self.performSegueWithIdentifier("segueToChangeDefaultPaymentMethod", sender: self)
			}
		}
		if indexPath.section == 2 {
			if indexPath.row == 0 {
				self.loadAboutVC()
			}
			if indexPath.row == 1 {
				let websiteAddress = NSURL(string: "http://hkalexling.com/2015/10/11/ibudgeter-support-page/")
				UIApplication.sharedApplication().openURL(websiteAddress!)
			}
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "segueToChangeDefaultPaymentMethod" {
			let destVC = segue.destinationViewController as! PaymentMethodTableViewController
			destVC.settingVC = self
		}
	}
	
	func saveBudget(){
		if !self.dailyBudgetTextField.text!.isEmpty {
			self.defaults.setDouble((self.dailyBudgetTextField.text! as NSString).doubleValue, forKey: "dailyBudget")
			let temp = self.dailyBudgetTextField.text!
			self.dailyBudgetTextField.text = ""
			self.dailyBudgetTextField.placeholder = temp
		}
		if !self.monthlyBudgetTextField.text!.isEmpty {
			self.defaults.setDouble((self.monthlyBudgetTextField.text! as NSString).doubleValue, forKey: "monthlyBudget")
			let temp = self.monthlyBudgetTextField.text!
			self.monthlyBudgetTextField.text = ""
			self.monthlyBudgetTextField.placeholder = temp
		}
	}
	
	func loadAboutVC(){
		let aboutVC = UIViewController()
		let webView = UIWebView(frame: aboutVC.view.frame)
		webView.backgroundColor = UIColor.whiteColor()
		aboutVC.view.addSubview(webView)
		
		let htmlFile = NSBundle.mainBundle().pathForResource("about", ofType: "html")!
		var htmlString : NSString!
		do {
			htmlString = try NSString(contentsOfFile: htmlFile, encoding: NSUTF8StringEncoding)
		}catch{}
		webView.loadHTMLString(htmlString as String, baseURL: nil)
		
		self.navigationController!.pushViewController(aboutVC, animated: true)
	}
}
