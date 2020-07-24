//
//  ReportViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit
import SideMenu
import Charts
class ReportViewController: UIViewController {
    
    var menu: SideMenuNavigationController?
    var months = [String]()
    var unitsSold = [Double]()
    @IBOutlet weak var barChartView: BarChartView!
    weak var axisFormatDelegate: IAxisValueFormatter?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        menu?.menuWidth = 300
        SideMenuManager.default.leftMenuNavigationController = menu
        axisFormatDelegate = self
        
        months = ["Jan",
                  "Feb",
                  "Mar",
                  "Apr",
                  "May",
                  "Jun",
                  "Jul",
                  "Aug",
                  "Sep",
                  "Oct",
                  "Nov",
                  "Dec"
        ]
        
        unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 38.0, 2.0, 4.0, 5.0, 4.0]
        
        setChart(dataPoints: months, values: unitsSold)
    }
    
    @IBAction func didTappedMenu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "NO DATA"
        
        var dataEntries = [BarChartDataEntry]()
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i], data: dataPoints)
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Units Sold")
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.xAxis.labelCount = 12
        barChartView.xAxis.labelPosition = .bottom
        barChartView.data = chartData
        barChartView.drawGridBackgroundEnabled = false
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false
        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)

        barChartView.xAxis.valueFormatter = axisFormatDelegate
        barChartView.animate(xAxisDuration: 0.3, yAxisDuration: 2.0)
    }
    
    
}
extension ReportViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]
    }
}
