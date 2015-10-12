//
//  NewRecordTableViewController.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 1/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class NewRecordTableViewController: UITableViewController {
	
	var selectedMethod : Method?
	
	let defaults = NSUserDefaults.standardUserDefaults()
	
	var descriptionTextField : UITextField!
	var moneyTextField : UITextField!
	
	var parentVC : DayTableViewController?

	var indexToEdit : Int?
	
	var recordToEdit : Record?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.tableFooterView = UIView()
		
		let tapRec = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
		tapRec.cancelsTouchesInView = false
		self.tableView.addGestureRecognizer(tapRec)
		
		if indexToEdit != nil{
			self.recordToEdit = self.parentVC!.records[self.indexToEdit!]
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(animated: Bool) {
		self.tableView.reloadData()
	}

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 3
		}
		else{
			return 1
		}
    }
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return ""
		}
		else{
			return " "
		}
	}
	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			if indexPath.row == 0 {
				let cell = tableView.dequeueReusableCellWithIdentifier("descriptionCell", forIndexPath: indexPath) as! DescriptionCell
				self.descriptionTextField = cell.descriptionTextField
				
				if self.recordToEdit != nil {
					self.descriptionTextField.text = self.recordToEdit!.name
				}
				
				return cell
			}
			else if indexPath.row == 1{
				let cell = tableView.dequeueReusableCellWithIdentifier("moneyCell", forIndexPath: indexPath) as! MoneyCell
				self.moneyTextField = cell.moneyTextField
				
				if self.recordToEdit != nil {
					if (self.recordToEdit!.money as NSString).doubleValue < 0 {
						cell.minusTapped()
					}
					else{
						cell.plusTapped()
					}
					self.moneyTextField.text = "\(abs((self.recordToEdit!.money as NSString).doubleValue))"
				}
				
				return cell
			}
			else if indexPath.row == 2 {
				let cell = tableView.dequeueReusableCellWithIdentifier("methodCell", forIndexPath: indexPath) as! MethodCell
				
				if self.selectedMethod != nil {
					cell.methodLabel.text = self.selectedMethod!.name
					cell.colorImageVIew.image = UIImage.imageWithColor(self.selectedMethod!.color)
					cell.colorImageVIew.layer.cornerRadius = cell.colorImageVIew.frame.size.width * 0.5
					cell.colorImageVIew.layer.masksToBounds = true
					return cell
				}
				else{
					
					if self.recordToEdit == nil {
						var defaultMethod : Method!
						if let data = self.defaults.objectForKey("defaultPaymentMethod") as! NSData? {
							if let stored = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Method? {
								defaultMethod = stored
								self.selectedMethod = defaultMethod
							}
						}

						cell.methodLabel.text = defaultMethod.name
						cell.colorImageVIew.image = UIImage.imageWithColor(defaultMethod.color)
						cell.colorImageVIew.layer.cornerRadius = cell.colorImageVIew.frame.size.width * 0.5
						cell.colorImageVIew.layer.masksToBounds = true
						return cell
					}
					else{
						
						cell.methodLabel.text = self.recordToEdit!.method.name
						cell.colorImageVIew.image = UIImage.imageWithColor(self.recordToEdit!.method.color)
						cell.colorImageVIew.layer.cornerRadius = cell.colorImageVIew.frame.size.width * 0.5
						cell.colorImageVIew.layer.masksToBounds = true
						return cell
					}
				}
			}
		}
		if indexPath.section == 1 {
			let cell = tableView.dequeueReusableCellWithIdentifier("saveCell", forIndexPath: indexPath) as! SaveButtonCell
			
			return cell
		}
		return UITableViewCell()
    }
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.row == 2 && indexPath.section == 0{
			self.performSegueWithIdentifier("segueToPaymentMethodTableVC", sender: self)
		}
		if indexPath.section == 1 {
			self.handleSave()
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "segueToPaymentMethodTableVC" {
			let destVC = segue.destinationViewController as! PaymentMethodTableViewController
			destVC.parentVC = self
		}
	}
	
	func hideKeyboard(){
		self.view.endEditing(true)
	}
	
	func handleSave(){
		if self.descriptionTextField.text == "" {
			self.showAlertWithOk(nil, message: "Description can't be empty")
		}
		else if self.moneyTextField.text == "" {
			self.showAlertWithOk(nil, message: "Amount can't be empty")
		}
		else{
			let isPlus : Bool = (self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! MoneyCell).isPlus
			var moneyText : String = ""
			if isPlus {
				moneyText = "+\(self.moneyTextField.text!)"
			}
			else{
				moneyText = "-\(self.moneyTextField.text!)"
			}
			self.saveRecord(self.descriptionTextField.text!, money: moneyText, method: self.selectedMethod!)
		}
	}
	
	func showAlertWithOk(title : String?, message : String?){
		let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	func saveRecord(description : String, money : String, method : Method) {
		
		if self.recordToEdit == nil {
		
			if let data = self.parentVC!.defaults.objectForKey(self.parentVC!.selectedDate!.toStringFromNonLocalDate()) as! NSData? {
				if let stored = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Record]? {
					self.parentVC!.records = stored
				}
			}
			
			self.parentVC!.records.append(Record(name: description, money: money, method: method))
		}
		else{
			self.parentVC!.records[self.indexToEdit!] = Record(name: description, money: money, method: method)
		}
		
		
		let data = NSKeyedArchiver.archivedDataWithRootObject(self.parentVC!.records)
		self.parentVC!.defaults.setObject(data, forKey: self.parentVC!.selectedDate!.toStringFromNonLocalDate())
		self.navigationController!.popViewControllerAnimated(true)
	}
}
