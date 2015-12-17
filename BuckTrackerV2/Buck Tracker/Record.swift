//
//  Record.swift
//  Buck Tracker
//
//  Created by Alex Ling on 4/12/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
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