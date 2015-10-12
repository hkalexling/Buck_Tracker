//
//  DayTableViewController.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 1/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class DayTableViewController: UITableViewController {
	
	var selectedDate : NSDate?
	var records : [Record] = []
	
	var selectedIndex : Int?
	
	let defaults = NSUserDefaults.standardUserDefaults()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        self.tableView.tableFooterView = UIView()
		
		
		let formatter : NSDateFormatter = NSDateFormatter()
		formatter.dateFormat = "MMM dd, yyyy"
		formatter.timeZone = NSTimeZone.localTimeZone()
		self.title = formatter.stringFromDate(self.selectedDate!)
		
		self.navigationController?.title = "New Record"
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(animated: Bool) {
		
		if let data = defaults.objectForKey(self.selectedDate!.toStringFromNonLocalDate()) as! NSData? {
			if let stored = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Record]? {
				self.records = stored
			}
		}

		self.tableView.reloadData()
		
		let data = NSKeyedArchiver.archivedDataWithRootObject(self.records)
		defaults.setObject(data, forKey: self.selectedDate!.toStringFromNonLocalDate())
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if self.records.count == 0 {
			return ""
		}
		else{
			if section == 0 {
				return ""
			}
			else{
				return " "
			}
		}
	}
	
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		if section == 0 {
			return self.records.count
		}
		else{
			return 1
		}
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		if indexPath.section == 1 {
			let cell = tableView.dequeueReusableCellWithIdentifier("newRecordCell", forIndexPath: indexPath) as! NewRecordCell
			
			return cell
		}
		else{
			let cell = tableView.dequeueReusableCellWithIdentifier("recordCell", forIndexPath: indexPath) as! RecordCell
			
			let record = self.records[indexPath.row]
			cell.descriptionLabel.text = record.name
			if record.money.hasPrefix("+"){
				cell.typeLabel.textColor = UIColor.greenColor().soften(0.9)
			}
			else{
				cell.typeLabel.textColor = UIColor.redColor().soften(0.9)
			}
			let rawStr = record.money.stringByReplacingOccurrencesOfString("+", withString: "").stringByReplacingOccurrencesOfString("-", withString: "")
			cell.typeLabel.text = "\(rawStr)"
			
			let method = record.method
			cell.moneyLabel.text = method.name
			cell.colorImageView.image = UIImage.imageWithColor(method.color)
			cell.colorImageView.layer.cornerRadius = cell.colorImageView.frame.size.width * 0.5
			cell.colorImageView.layer.masksToBounds = true
			return cell
		}
    }
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		if indexPath.section == 1 {
			return false
		}
		else{
			return true
		}
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			self.records.removeAtIndex(indexPath.row)
			self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
			
			let data = NSKeyedArchiver.archivedDataWithRootObject(self.records)
			defaults.setObject(data, forKey: self.selectedDate!.toStringFromNonLocalDate())

		}
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 1 {
			self.performSegueWithIdentifier("segueToNewRecordTableVC", sender: self)
		}
		else{
			self.selectedIndex = indexPath.row
			self.performSegueWithIdentifier("segueToEditRecord", sender: self)
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "segueToNewRecordTableVC" {
			let destVC = segue.destinationViewController as! NewRecordTableViewController
			destVC.parentVC = self
		}
		if segue.identifier == "segueToEditRecord" {
			let destVC = segue.destinationViewController as! NewRecordTableViewController
			destVC.indexToEdit = self.selectedIndex
			destVC.parentVC = self
		}
	}
}
