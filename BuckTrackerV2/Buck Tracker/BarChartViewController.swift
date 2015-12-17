//
//  BarChartViewController.swift
//  Buck Tracker
//
//  Created by Alex Ling on 4/12/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController: UIViewController {

	let screenSize : CGSize = UIScreen.mainScreen().bounds.size
	var barChartView : BarChartView!
	
	var dayStrings : [String] = []
	var moneySpend : [Double] = []
	var moneySpendPosiveVer : [Double] = []
	
	let defaults = NSUserDefaults.standardUserDefaults()
	
	var lastDate : NSDate = NSDate().toLocalTime()
	
	override func viewDidLoad() {
		super.viewDidLoad()
				
		self.barChartView = BarChartView(frame : CGRectMake(0, 60, self.screenSize.width, self.screenSize.height - CGFloat.tabBarHeight() - CGFloat.navitaionBarHeight() - 20))
		barChartView.legend.enabled = false
		barChartView.userInteractionEnabled = false
		
		let leftArrow = UIImage(named: "leftArrow")
		let rightArrow = UIImage(named: "rightArrow")
		
		let nextButton = UIBarButtonItem(image: rightArrow, style: .Done, target: self, action: Selector("nextButtonTapped"))
		let previousButton = UIBarButtonItem(image: leftArrow, style: .Done, target: self, action: Selector("previousButtonTapped"))
		
		self.navigationItem.leftBarButtonItem = previousButton
		self.navigationItem.rightBarButtonItem = nextButton
	}
	
	override func viewWillAppear(animated: Bool) {
		self.lastDate = NSDate().toLocalTime()
		self.reload()
	}
	
	func nextButtonTapped(){
		self.lastDate = self.lastDate.dateByAddingTimeInterval(604800)
		self.reload()
	}
	
	func previousButtonTapped(){
		self.lastDate = self.lastDate.dateByAddingTimeInterval(-604800)
		self.reload()
	}
	
	func reload(){
		self.barChartView.removeFromSuperview()
		self.dayStrings = []
		self.moneySpend = []
		
		let wholeWeekDate : [NSDate] = self.lastDate.getWholeWeek()
		self.navigationItem.title = "\(wholeWeekDate[0].toStringWithoutYear()) ~ \(wholeWeekDate.last!.toStringWithoutYear())"
		for i in wholeWeekDate {
			self.dayStrings.append(i.weekDay())
			
			let str = i.toString()
			var netMoney : Double = 0
			if let data = defaults.objectForKey(str) as! NSData? {
				if let stored = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Record]? {
					for s in stored {
						let moneyString : NSString = s.money as NSString
						netMoney += moneyString.doubleValue
					}
				}
			}
			
			self.moneySpend.append(netMoney)
		}
		
		self.moneySpendPosiveVer = self.moneySpend
		for var i : Int = 0; i < self.moneySpendPosiveVer.count; i += 1 {
			if self.moneySpendPosiveVer[i] < 0 {
				self.moneySpendPosiveVer[i] = self.moneySpendPosiveVer[i] * -1
			}
		}
		
		setChart(dayStrings, values: moneySpendPosiveVer)
		
		self.view.addSubview(self.barChartView)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func setChart(dataPoints: [String], values: [Double]) {
		barChartView.descriptionText = ""
		barChartView.noDataText = ""
		
		barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .EaseInOutQuad)
		
		var dataEntries: [BarChartDataEntry] = []
		
		for i in 0..<dataPoints.count {
			let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
			dataEntries.append(dataEntry)
		}
		
		let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "")
		
		for i in 0..<self.moneySpend.count {
			if i < chartDataSet.colors.count {
				if self.moneySpend[i] < 0 {
					chartDataSet.colors[i] = UIColor(red: 225/255, green: 14/255, blue: 70/255, alpha: 1)
				}
				else{
					chartDataSet.colors[i] = UIColor(red: 48/255, green: 188/255, blue: 123/255, alpha: 1)
				}
			}
			else{
				if self.moneySpend[i] < 0 {
					chartDataSet.colors.append(UIColor(red: 225/255, green: 14/255, blue: 70/255, alpha: 1))
				}
				else{
					chartDataSet.colors.append(UIColor(red: 48/255, green: 188/255, blue: 123/255, alpha: 1))
				}
			}
		}
		
		let chartData = BarChartData(xVals: dayStrings, dataSet: chartDataSet)
		barChartView.data = chartData
	}
}

