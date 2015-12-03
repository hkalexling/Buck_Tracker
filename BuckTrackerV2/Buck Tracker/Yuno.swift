//
//  Extension.swift
//  KonaBot
//
//  Created by Alex Ling on 1/11/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public extension UIImage {
	class func imageWithColor(color: UIColor) -> UIImage {
		let size = CGSizeMake(10, 10)
		let rect = CGRectMake(0, 0, size.width, size.height)
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		color.setFill()
		UIRectFill(rect)
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
	func coloredImage(color : UIColor) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		let context : CGContextRef? = UIGraphicsGetCurrentContext()
		CGContextTranslateCTM(context, 0, self.size.height)
		CGContextScaleCTM(context, 1.0, -1.0)
		CGContextSetBlendMode(context, .Normal)
		let rect : CGRect = CGRectMake(0, 0, self.size.width, self.size.height)
		CGContextClipToMask(context, rect, self.CGImage)
		color.setFill()
		CGContextFillRect(context, rect)
		let newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}
}

public extension Int{
	static func randInRange(range: Range<Int>) -> Int {
		return  Int(arc4random_uniform(UInt32(range.endIndex - range.startIndex))) + range.startIndex
	}
}

public extension CGSize {
	static func screenSize() -> CGSize {
		return UIScreen.mainScreen().bounds.size
	}
}

public extension NSDate {
	func toString() -> String{
		let dateFormatter: NSDateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "MM-dd-yyyy"
		
		return dateFormatter.stringFromDate(self)
	}
	func weekDay() -> String{
		let formatter = NSDateFormatter()
		formatter.dateFormat = "E"
		
		return formatter.stringFromDate(self)
	}
	func toLocalTime() -> NSDate {
		let tz = NSTimeZone.defaultTimeZone()
		let seconds = tz.secondsFromGMTForDate(self)
		let date : NSDate = self.dateByAddingTimeInterval(NSTimeInterval(seconds))
		return date
	}
	func extract() -> NSDateComponents {
		let cal = NSCalendar.currentCalendar()
		let comp = cal.components([.Calendar, .Day, .Era, .Hour, .Minute, .Month, .Nanosecond, .Year], fromDate: self)
		return comp
	}
}

public extension UIColor {
	class func softPink() -> UIColor{
		return UIColor(red:206/255.0, green:67/255.0, blue:130/255.0, alpha:1)
	}
	class func softYelow() -> UIColor{
		return UIColor(red: 253/255, green: 197/255, blue: 0, alpha: 1)
	}
	class func softOrange() -> UIColor{
		return UIColor(red: 1, green: 167/255, blue: 28/255, alpha: 1)
	}
	class func softGreen() -> UIColor{
		return UIColor(red: 158/255, green: 211/255, blue: 15/255, alpha: 1)
	}
	class func softBlue() -> UIColor{
		return UIColor(red: 100/255, green: 194/255, blue: 227/255, alpha: 1)
	}
	class func softPurple() -> UIColor{
		return UIColor(red: 124/255, green: 118/255, blue: 247/255, alpha: 1)
	}
	var components:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
		var r:CGFloat = 0
		var g:CGFloat = 0
		var b:CGFloat = 0
		var a:CGFloat = 0
		getRed(&r, green: &g, blue: &b, alpha: &a)
		return (r,g,b,a)
	}
	func soften(coeff : CGFloat) -> UIColor{
		let comp = self.components
		return UIColor(red: comp.red * coeff, green: comp.green * coeff, blue: comp.blue * coeff, alpha: comp.alpha)
	}
	static func themeColor() -> UIColor{
		return UIColor(red: 18/255, green: 187/255, blue: 249/255, alpha: 1)
	}
}

public extension UIAlertController {
	class func alertWithOKButton(title : String?, message : String?) -> UIAlertController {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
		return alert
	}
	
	class func alert(title : String?, message : String?, actions : [UIAlertAction]?) -> UIAlertController{
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
		
		for action in actions! {
			alert.addAction(action)
		}
		
		return alert
	}
}

public extension UIDevice {
	
	var modelName: String {
		var systemInfo = utsname()
		uname(&systemInfo)
		let machineMirror = Mirror(reflecting: systemInfo.machine)
		let identifier = machineMirror.children.reduce("") { identifier, element in
			guard let value = element.value as? Int8 where value != 0 else { return identifier }
			return identifier + String(UnicodeScalar(UInt8(value)))
		}
		
		switch identifier {
		case "iPod5,1":                                 return "iPod Touch 5"
		case "iPod7,1":                                 return "iPod Touch 6"
		case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
		case "iPhone4,1":                               return "iPhone 4s"
		case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
		case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
		case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
		case "iPhone7,2":                               return "iPhone 6"
		case "iPhone7,1":                               return "iPhone 6 Plus"
		case "iPhone8,1":                               return "iPhone 6s"
		case "iPhone8,2":                               return "iPhone 6s Plus"
		case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
		case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
		case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
		case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
		case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
		case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
		case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
		case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
		case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
		case "iPad6,7", "iPad6,8":                      return "iPad Pro"
		case "AppleTV5,3":                              return "Apple TV"
		default:                                        return identifier
		}
	}
}

public class Yuno{
	
	var imageCoreData = [NSManagedObject]()
	var favoriteCoreData = [NSManagedObject]()
	
	func baseUrl() -> String{
		
		let r18 = NSUserDefaults.standardUserDefaults().boolForKey("r18")
		
		if r18 {
			return "http://konachan.com"
		}
		else{
			return "http://konachan.net"
		}
	}
	
	public func saveImageWithKey(entity : String, image : UIImage, key : String){
		let data = NSKeyedArchiver.archivedDataWithRootObject(image)
		let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
		let entity = NSEntityDescription.entityForName(entity,
			inManagedObjectContext: managedContext)
		let options = NSManagedObject(entity: entity!,
			insertIntoManagedObjectContext:managedContext)
		
		options.setValue(data, forKey: "image")
		options.setValue(key, forKey: "key")
		
		self.imageCoreData.append(options)
		do {
			try managedContext.save()
		}
		catch{
			print (error)
		}
	}
	
	public func fetchImageWithKey(entity : String, key : String) -> UIImage?{
		let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
		let fetchRequest = NSFetchRequest(entityName: entity)
		fetchRequest.predicate = NSPredicate(format: "key == %@", key)
		
		var fetchedResults : [NSManagedObject] = []
		do {
			fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
		}
		catch{
			print (error)
		}
		if fetchedResults.count == 1 {
			return NSKeyedUnarchiver.unarchiveObjectWithData(fetchedResults[0].valueForKey("image") as! NSData) as? UIImage
		}
		return nil
	}
	
	public func checkFullsSizeWithKey(key : String) -> Bool {
		let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
		let fetchRequest = NSFetchRequest(entityName: "FavoritedImage")
		fetchRequest.predicate = NSPredicate(format: "key == %@", key)
		
		var fetchedResults : [NSManagedObject] = []
		do {
			fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
		}
		catch{
			print (error)
		}
		
		if fetchedResults.count == 1 {
			return fetchedResults[0].valueForKey("isFullSize") as! Bool
		}
		
		return false
	}
	
	public func deleteRecordForKey(entity : String, key : String) {
		let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
		let fetchRequest = NSFetchRequest(entityName: entity)
		fetchRequest.predicate = NSPredicate(format: "key == %@", key)
		
		var fetchedResults : [NSManagedObject] = []
		do {
			fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
		}
		catch{
			print (error)
		}
		if fetchedResults.count == 1 {
			managedContext.deleteObject(fetchedResults[0])
			do {
				try managedContext.save()
			}
			catch{
				print (error)
			}
		}
	}
	
	public func saveFavoriteImageIfNecessary(key : String, image : UIImage){
		let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
		let fetchRequest = NSFetchRequest(entityName: "FavoritedImage")
		fetchRequest.predicate = NSPredicate(format: "key == %@", key)
		
		var fetchedResults : [NSManagedObject] = []
		do {
			fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
		}
		catch{
			print (error)
		}
		
		if fetchedResults.count > 0 {
			self.deleteRecordForKey("FavoritedImage", key: key)
			
			let data = NSKeyedArchiver.archivedDataWithRootObject(image)
			let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
			let entity = NSEntityDescription.entityForName("FavoritedImage",
				inManagedObjectContext: managedContext)
			let options = NSManagedObject(entity: entity!,
				insertIntoManagedObjectContext:managedContext)
			
			options.setValue(data, forKey: "image")
			options.setValue(key, forKey: "key")
			options.setValue(true, forKey: "isFullSize")
			
			self.imageCoreData.append(options)
			do {
				try managedContext.save()
			}
			catch{
				print (error)
			}
		}
	}
	
	public func favoriteList() -> [String]{
		var returnAry : [String] = []
		
		let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
		let fetchRequest = NSFetchRequest(entityName: "FavoritedImage")
		
		var fetchedResults : [NSManagedObject] = []
		do {
			fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
		}
		catch{
			print (error)
		}
		
		for result in fetchedResults{
			returnAry.append(result.valueForKey("key") as! String)
		}
		
		return returnAry
	}
	
	public func deleteEntity(entity : String){
		let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
		let fetchRequest = NSFetchRequest(entityName: entity)
		
		var fetchedResults : [NSManagedObject] = []
		do {
			fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
		}
		catch{
			print (error)
		}
		
		if fetchedResults.count > 0 {
			for result in fetchedResults{
				managedContext.deleteObject(result)
			}
		}
		
		do {
			try managedContext.save()
		}
		catch{
			print (error)
		}
	}
	
	public func backgroundThread(background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if(background != nil){ background!(); }
			
			dispatch_async(dispatch_get_main_queue()){
				if(completion != nil){ completion!(); }
			}
		}
	}
}