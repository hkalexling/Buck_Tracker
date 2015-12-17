//
//  Extensions.swift
//  iBudget_Swift
//
//  Created by Alex Ling on 3/10/2015.
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

extension UIImage {
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

extension CGSize {
	static func screenSize() -> CGSize {
		return UIScreen.mainScreen().bounds.size
	}
}

extension Method {
	static func allMethods() -> [Method] {
		let cash = Method(name : "Cash", color : UIColor.greenColor().soften(0.98))
		let eps = Method(name : "EPS", color : UIColor.yellowColor().soften(0.98))
		let visa = Method(name : "VISA", color : UIColor.blueColor().soften(0.98))
		let master = Method(name : "Master", color : UIColor.redColor().soften(0.98))
		let payPal = Method(name : "PayPal", color : UIColor.orangeColor().soften(0.98))
		let americanExpress = Method(name : "American Express", color : UIColor.cyanColor().soften(0.98))
		let chinaUnionPay = Method(name : "China UnionPay", color : UIColor.magentaColor().soften(0.98))
		
		return [cash, eps, visa, master, payPal, americanExpress, chinaUnionPay]
	}
}

extension UINavigationController {
	public override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
}

extension CGFloat {
	static func cornorRadius() -> CGFloat{
		return 8
	}
	static func tabBarHeight() -> CGFloat{
		return 49
	}
	static func navitaionBarHeight() -> CGFloat{
		return 44
	}
}

extension NSDate {
	func toStringFromNonLocalDate() -> String{
		let dateFormatter: NSDateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "MM-dd-yyyy"
		dateFormatter.timeZone = NSTimeZone.localTimeZone()
		
		return dateFormatter.stringFromDate(self)
	}
	func toStringFromNonLocalDateWithoutYear() -> String{
		let dateFormatter: NSDateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "MM-dd"
		dateFormatter.timeZone = NSTimeZone.localTimeZone()
		
		return dateFormatter.stringFromDate(self)
	}
	func getWholeWeek() -> [NSDate] {
		var aryToReturn : [NSDate] = []
		let cal = NSCalendar.currentCalendar()
		cal.timeZone = NSTimeZone.localTimeZone()
		
		let comp = NSDateComponents()
		
		for var i = -6; i < 1; i += 1 {
			comp.weekday = i
			aryToReturn.append(cal.dateByAddingComponents(comp, toDate: self, options: NSCalendarOptions.MatchStrictly)!)
		}
		return aryToReturn
	}
	func weekDay() -> String{
		let formatter = NSDateFormatter()
		formatter.dateFormat = "E"
		formatter.timeZone = NSTimeZone.localTimeZone()
		
		return formatter.stringFromDate(self)
	}
	func toLocalTime() -> NSDate {
		let tz = NSTimeZone.defaultTimeZone()
		let seconds = tz.secondsFromGMTForDate(self)
		let date : NSDate = self.dateByAddingTimeInterval(NSTimeInterval(seconds))
		return date
	}
	func extractNonLocalDate() -> NSDateComponents {
		let cal = NSCalendar.currentCalendar()
		cal.timeZone = NSTimeZone.localTimeZone()
		let comp = cal.components([.Calendar, .Day, .Era, .Hour, .Minute, .Month, .Nanosecond, .Year], fromDate: self)
		return comp
	}
}

extension UIColor {
	func softPink() -> UIColor{
		return UIColor(red:206/255.0, green:67/255.0, blue:130/255.0, alpha:1)
	}
	func softYelow() -> UIColor{
		return UIColor(red: 253/255, green: 197/255, blue: 0, alpha: 1)
	}
	func softOrange() -> UIColor{
		return UIColor(red: 1, green: 167/255, blue: 28/255, alpha: 1)
	}
	func softGreen() -> UIColor{
		return UIColor(red: 158/255, green: 211/255, blue: 15/255, alpha: 1)
	}
	func softBlue() -> UIColor{
		return UIColor(red: 100/255, green: 194/255, blue: 227/255, alpha: 1)
	}
	func softPurple() -> UIColor{
		return UIColor(red: 124/255, green: 118/255, blue: 247/255, alpha: 1)
	}
	static func themeColor() -> UIColor{
		return UIColor(red: 18/255, green: 187/255, blue: 249/255, alpha: 1)
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
}

public class Yuno{
	public func backgroundThread(background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if(background != nil){ background!(); }
			
			dispatch_async(dispatch_get_main_queue()){
				if(completion != nil){ completion!(); }
			}
		}
	}
}