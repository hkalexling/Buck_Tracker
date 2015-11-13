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
	
	var shouldShowTips : Bool = true
	
    override func viewDidLoad() {
        super.viewDidLoad()

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
		
		if defaults.boolForKey("dismissTips") || self.records.count == 0 {
			self.shouldShowTips = false
		}
		
		if self.shouldShowTips{
			let tipView = UIView(frame: CGRectMake(0, 0, CGSize.screenSize().width, 120))
			
			let label = UILabel(frame: CGRectMake(0, 30, CGSize.screenSize().width, 30))
			label.text = "Tap on a record to edit it"
			label.textAlignment = NSTextAlignment.Center
			label.textColor = UIColor.grayColor()
			tipView.addSubview(label)
			
			let label1 = UILabel(frame: CGRectMake(0, 60, CGSize.screenSize().width, 30))
			label1.text = "Swipe left on a record to delete it"
			label1.textAlignment = NSTextAlignment.Center
			label1.textColor = UIColor.grayColor()
			tipView.addSubview(label1)
			
			let button = UIButton(frame: CGRectMake(CGSize.screenSize().width/2 - 30, 90, 60, 30))
			button.setTitle("Got it!", forState: .Normal)
			button.titleLabel!.font = UIFont.systemFontOfSize(15)
			button.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), forState: .Normal)
			button.addTarget(self, action: Selector("tipButtonTapped"), forControlEvents: .TouchDown)
			tipView.addSubview(button)
			
			self.tableView.tableFooterView = tipView
		}
		else{
			self.tableView.tableFooterView = UIView()
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
		if (self.tableView.visibleCells.count == 1){
			self.tableView.reloadData()
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
	
	func tipButtonTapped(){
		defaults.setBool(true, forKey: "dismissTips")
		self.tableView.tableFooterView = UIView()
	}
}
