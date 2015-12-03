//
//  MoneyCell.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 1/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class MoneyCell: UITableViewCell, UITextFieldDelegate{

	@IBOutlet weak var plusImageView: UIImageView!
	@IBOutlet weak var minorImageView: UIImageView!
	@IBOutlet weak var moneyTextField: UITextField!
	
	var isPlus : Bool = false
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		self.moneyTextField.delegate = self
		moneyTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
		
		let plusRec = UITapGestureRecognizer(target: self, action: Selector("plusTapped"))
		let minusRec = UITapGestureRecognizer(target: self, action: Selector("minusTapped"))
		
		self.plusImageView.addGestureRecognizer(plusRec)
		self.minorImageView.addGestureRecognizer(minusRec)
		
		self.plusImageView.layer.cornerRadius = self.plusImageView.frame.width * 0.2
		self.minorImageView.layer.cornerRadius = self.minorImageView.frame.width * 0.2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func plusTapped(){
		self.isPlus = true
		
		plusImageView.image = UIImage(named: "GreenPlus")
		minorImageView.image = UIImage(named: "GrayMinus")
		
	}
	
	func minusTapped(){
		self.isPlus = false
		
		plusImageView.image = UIImage(named: "GrayPlus")
		minorImageView.image = UIImage(named: "RedMinus")
	}
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		let inverseSet = NSCharacterSet(charactersInString:"0123456789.").invertedSet
		let components = string.componentsSeparatedByCharactersInSet(inverseSet)
		let filtered = components.joinWithSeparator("")
		return string == filtered
	}
	
	func textFieldDidChange(textField: UITextField) {
		textField.invalidateIntrinsicContentSize()
	}
}
