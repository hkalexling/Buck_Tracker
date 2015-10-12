//
//  PaymentMethodCell.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 2/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

class PaymentMethodCell: UITableViewCell {

	@IBOutlet weak var colorImageView: UIImageView!
	@IBOutlet weak var descriptionLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
