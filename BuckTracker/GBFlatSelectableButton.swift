//
//  GBFlatSelectableButton.swift
//  GBFlatButtonSwiftExample
//
//  Created by Gustavo Barbosa on 6/10/14.
//  Copyright (c) 2014 Gustavo Barbosa. All rights reserved.
//

import UIKit

class GBFlatSelectableButton: GBFlatButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSelectionHandler()
    }
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
        self.addSelectionHandler()
    }
    
    func addSelectionHandler() {
        self.addTarget(self, action: "toggleButtonSelection", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func toggleButtonSelection() {
        self.selected = !self.selected
        
        if self.selected {
            _ = UIControlState.Selected
        } else {
            _ = UIControlState.Normal
        }
        
        let title = self.titleForState(state)
        self.setTitle(title, forState: state)
        
        self.invalidateIntrinsicContentSize()
    }
}

