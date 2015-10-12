//
//  PaymentMethodTableViewController.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 2/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class PaymentMethodTableViewController: UITableViewController{
	
	var methods : [Method] = Method.allMethods()
	var parentVC : NewRecordTableViewController?
	var settingVC : SettingTableViewController?
	
	var customMethods : [Method] = []
	
	let defaults = NSUserDefaults.standardUserDefaults()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.tableView.tableFooterView = UIView()
    }
	
	override func viewWillAppear(animated: Bool) {
		
		if let data = self.defaults.objectForKey("customMethods") as! NSData? {
			if let stored = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Method]? {
				self.customMethods = stored
			}
		}
		
		self.tableView.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 1 {
			return " "
		}
		return ""
	}

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		
		if section == 0 {
			return self.methods.count + self.customMethods.count
		}
		else{
			return 1
		}
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier("paymentMethodCell", forIndexPath: indexPath) as! PaymentMethodCell
			
			if indexPath.row < self.methods.count {
				cell.descriptionLabel.text = self.methods[indexPath.row].name
				cell.colorImageView.image = UIImage.imageWithColor(self.methods[indexPath.row].color)
				cell.colorImageView.layer.cornerRadius = cell.colorImageView.frame.size.width * 0.5
				cell.colorImageView.layer.masksToBounds = true
			}
			else{
				let ind = indexPath.row - self.methods.count
				cell.descriptionLabel.text = self.customMethods[ind].name
				cell.colorImageView.image = UIImage.imageWithColor(self.customMethods[ind].color)
				cell.colorImageView.layer.cornerRadius = cell.colorImageView.frame.size.width * 0.5
				cell.colorImageView.layer.masksToBounds = true
			}
			
			return cell
		}
		else {
			let cell = tableView.dequeueReusableCellWithIdentifier("newPaymentMethodCell", forIndexPath: indexPath)
			
			return cell
		}
		
    }
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 {
			if self.settingVC == nil {
				if indexPath.row < self.methods.count {
					let selectedMethod = self.methods[indexPath.row]
					self.parentVC!.selectedMethod = selectedMethod
				}
				else{
					let selectedMethod = self.customMethods[indexPath.row - self.methods.count]
					self.parentVC!.selectedMethod = selectedMethod
				}
				
				self.navigationController?.popViewControllerAnimated(true)
			}
			else{
				if indexPath.row < self.methods.count {
					let data = NSKeyedArchiver.archivedDataWithRootObject(self.methods[indexPath.row])
					self.defaults.setObject(data, forKey: "defaultPaymentMethod")
				}
					
				else{
					let data = NSKeyedArchiver.archivedDataWithRootObject(self.customMethods[indexPath.row - self.methods.count])
					self.defaults.setObject(data, forKey: "defaultPaymentMethod")
				}

				
				self.navigationController?.popViewControllerAnimated(true)
			}
		}
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 48
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		if indexPath.section == 0 {
			
			if indexPath.row < self.methods.count {
				return false
			}
			else{
				return true
			}
		}
		else{
			return false
		}
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == UITableViewCellEditingStyle.Delete {
			self.customMethods.removeAtIndex(indexPath.row - self.methods.count)
			self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
			
			let data = NSKeyedArchiver.archivedDataWithRootObject(self.customMethods)
			self.defaults.setObject(data, forKey: "customMethods")
		}
	}
}
