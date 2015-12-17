//
//  RecordCell.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 1/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class RecordCell: UITableViewCell {
	
	let screenWidth : CGFloat = UIScreen.mainScreen().bounds.width

	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var typeLabel: UILabel!
	@IBOutlet weak var moneyLabel: UILabel!
	@IBOutlet weak var colorImageView: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
