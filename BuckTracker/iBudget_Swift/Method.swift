//
//  Method.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 2/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//
//  For the brave souls who are maintaining this file: You are the chosen ones,
//  the valiant knights of programming who toil away, without rest,
//  fixing our most awful code.
// 
//  To you, true saviors, kings of men,
//  I say this: never gonna give you up, never gonna let you down,
//  never gonna run around and desert you. Never gonna make you cry,
//  never gonna say goodbye. Never gonna tell a lie and hurt you.
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

/*
struct Method {
	var name : String = ""
	var color : UIColor = UIColor.whiteColor()
}
*/