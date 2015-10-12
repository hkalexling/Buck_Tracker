//
//  MonthPickerViewController.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 5/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class MonthPickerViewController: UIViewController {

	@IBOutlet weak var monthPicker: SRMonthPicker!
	@IBOutlet weak var okButton: GBFlatButton!
	var parentVC : CalendarViewController!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        self.okButton.tintColor = UIColor.themeColor()
		
		self.okButton.selected = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func okButtonTapped(sender: UIButton) {
		self.parentVC.dismissViewControllerAnimated(true, completion: nil)
		self.parentVC.manager.setDate(self.monthPicker.date)
	}
}
