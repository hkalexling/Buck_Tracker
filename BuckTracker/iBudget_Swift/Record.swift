//
//  Record.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 1/10/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//
// For the brave souls who get this far: You are the chosen ones,
// the valiant knights of programming who toil away, without rest,
// fixing our most awful code. To you, true saviors, kings of men,
// I say this: never gonna give you up, never gonna let you down,
// never gonna run around and desert you. Never gonna make you cry,
// never gonna say goodbye. Never gonna tell a lie and hurt you.
//

import Foundation

class Record : NSObject {
	var name : String = ""
	var money : String = ""
	var method : Method = Method(name: "", color: UIColor())
	
	init(name : String, money : String, method : Method){
		self.name = name
		self.money = money
		self.method = method
	}
	
	init(coder aDecoder : NSCoder!) {
		if let name = aDecoder.decodeObjectForKey("name") as? String {
			self.name = name
		}
		if let money = aDecoder.decodeObjectForKey("money") as? String {
			self.money = money
		}
		if let method = aDecoder.decodeObjectForKey("method") as? Method {
			self.method = method
		}
	}
	
	func encodeWithCoder(aCoder : NSCoder){
		let name = self.name
		aCoder.encodeObject(name, forKey: "name")
		
		let money = self.money
		aCoder.encodeObject(money, forKey: "money")
		
		let method = self.method
		aCoder.encodeObject(method, forKey: "method")
	}
}

/*
struct Record {
	var description : String
	var money : String
	var method : Method
}
*/

