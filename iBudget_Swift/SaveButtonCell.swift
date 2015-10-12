//
//  SaveButtonCell.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 6/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class SaveButtonCell: UITableViewCell {

	@IBOutlet weak var themeColorCell: UIView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		self.themeColorCell.backgroundColor = UIColor.themeColor()
		self.themeColorCell.layer.cornerRadius = CGFloat.cornorRadius()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
