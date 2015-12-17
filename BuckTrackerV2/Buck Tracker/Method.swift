//
//  Method.swift
//  Buck Tracker
//
//  Created by Alex Ling on 4/12/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import Foundation
import UIKit

class Method : NSObject {
	var name : String = ""
	var color : UIColor = UIColor.whiteColor()
	
	init(name : String, color : UIColor){
		self.name = name
		self.color = color
	}
	
	init(coder aDecoder : NSCoder!) {
		if let name = aDecoder.decodeObjectForKey("name") as? String {
			self.name = name
		}
		if let color = aDecoder.decodeObjectForKey("color") as? UIColor {
			self.color = color
		}
	}
	
	func encodeWithCoder(aCoder : NSCoder){
		let name = self.name
		aCoder.encodeObject(name, forKey: "name")
		
		let color = self.color
		aCoder.encodeObject(color, forKey: "color")
	}
}