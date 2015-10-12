//
//  NewRecordCell.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 1/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class NewRecordCell: UITableViewCell {

	@IBOutlet weak var themeColorView: UIView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		self.themeColorView.backgroundColor = UIColor.themeColor()
		self.themeColorView.layer.cornerRadius = CGFloat.cornorRadius()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
