//
//  NewPaymentMethodTableViewController.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 9/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class NewPaymentMethodTableViewController: UITableViewController {
	
	let defaults = NSUserDefaults.standardUserDefaults()
	
	var selectedColor : UIColor?
	var unchangedSelectedColor : UIColor?
	
	var textField : UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.tableView.tableFooterView = UIView()
		
		let tapRec = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
		tapRec.cancelsTouchesInView = false
		self.tableView.addGestureRecognizer(tapRec)
    }
	
	override func viewWillAppear(animated: Bool) {
		self.tableView.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func hideKeyboard(){
		self.view.endEditing(true)
	}

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		if section == 0 {
			return 2
		}
		else{
			return 1
		}
    }
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 1 {
			return " "
		}
		else{
			return ""
		}
	}
	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			if indexPath.row == 0 {
				let cell = self.tableView.dequeueReusableCellWithIdentifier("newPaymentMethodNameCell", forIndexPath: indexPath) as! NPMNameCell
				
				self.textField = cell.NPMTextField
				
				return cell
			}
			else{
				let cell = self.tableView.dequeueReusableCellWithIdentifier("newPaymentMethodColorCell", forIndexPath: indexPath) as! NPMColorCell
				
				if self.selectedColor != nil {
					self.unchangedSelectedColor = self.selectedColor!
					cell.NPMImageView.image = UIImage.imageWithColor(self.selectedColor!)
				}
				else{
					cell.NPMImageView.image = UIImage.imageWithColor(UIColor.lightGrayColor())
				}
				cell.NPMImageView.layer.cornerRadius = cell.NPMImageView.frame.width * 0.5
				cell.NPMImageView.layer.masksToBounds = true
				
				return cell
			}
		}
		else{
			let cell = self.tableView.dequeueReusableCellWithIdentifier("newPaymentMethodSaveCell", forIndexPath: indexPath) as! NPMSaveCell
			
			return cell
		}
    }
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 && indexPath.row == 1 {
			self.performSegueWithIdentifier("segueToColorVC", sender: self)
		}
		if indexPath.section == 1 {
			self.save()
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "segueToColorVC" {
			let colorVC = segue.destinationViewController as! SwiftColorPickerViewController
			colorVC.parentVC = self
			colorVC.nav = self.navigationController!
		}
	}
	
	func save(){
		if self.textField.text != nil{
			if self.textField.text != "" {
				var newMethod : Method!
				if self.selectedColor != nil {
					newMethod = Method(name: self.textField.text!, color: self.unchangedSelectedColor!)
				}
				else{
					newMethod = Method(name: self.textField.text!, color: UIColor.lightGrayColor())
				}
				
				var storedMethods : [Method] = []
				
				if let data = self.defaults.objectForKey("customMethods") as! NSData? {
					if let stored = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Method]? {
						storedMethods = stored
					}
				}
				
				storedMethods.append(newMethod)
				
				let newData = NSKeyedArchiver.archivedDataWithRootObject(storedMethods)
				self.defaults.setObject(newData, forKey: "customMethods")
				
				self.navigationController!.popViewControllerAnimated(true)
			}
			else{
				self.showAlertWithOk(nil, message: "Please type in payment method name")
			}
		}
	}
	
	func showAlertWithOk(title : String?, message : String?){
		let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
		self.presentViewController(alert, animated: true, completion: nil)
	}
}
