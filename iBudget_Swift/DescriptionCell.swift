//
//  DescriptionCell.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 1/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell {

	@IBOutlet weak var descriptionTextField: UITextField!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		//self.descriptionTextField.becomeFirstResponder()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
