//
//  NPMSaveCell.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 9/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class NPMSaveCell: UITableViewCell {

	@IBOutlet weak var NPMThemeColorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
		
		self.NPMThemeColorView.layer.cornerRadius = CGFloat.cornorRadius()
		self.NPMThemeColorView.backgroundColor = UIColor.themeColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
