//
//  BudgetCell.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 8/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class BudgetCell: UITableViewCell, UITextFieldDelegate{

	@IBOutlet weak var budgetTypeLabel: UILabel!
	@IBOutlet weak var budgetTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
		
		self.budgetTextField.delegate = self
		self.budgetTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func textFieldDidChange(textField: UITextField) {
		textField.invalidateIntrinsicContentSize()
	}
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		let inverseSet = NSCharacterSet(charactersInString:"0123456789.").invertedSet
		let components = string.componentsSeparatedByCharactersInSet(inverseSet)
		let filtered = components.joinWithSeparator("")
		return string == filtered
	}
}
