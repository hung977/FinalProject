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
    var productsReport: [ReportResponse] = []
    weak var axisFormatDelegate: IAxisValueFormatter?
    var productName: [String] = []
    var productAmount: [Double] = []
    
    //MARK: - IBOutlet
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var barChartView: BarChartView!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        navigationController?.isNavigationBarHidden = true
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        menu?.menuWidth = 300
        SideMenuManager.default.leftMenuNavigationController = menu
        axisFormatDelegate = self
    }
    //MARK: - IBAction
    @IBAction func didTappedMenu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    @IBAction func drawBtnTapped(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let from = dateFormatter.string(from: fromDatePicker.date)
        let to = dateFormatter.string(from: toDatePicker.date)
        let router = Router.getReport
        RequestService.shared.AFRequestReport(router: router, from: "\(from)", to: "\(to)") { [weak self] (data, response, error) in
            guard let self = self else {return}
            do {
                if let err = error {
                    self.alert(tit: "Error", mess: "\(err)")
                } else {
                    if let safeData = data {
                        let json = try JSONDecoder.init().decode([ReportResponse].self, from: safeData)
                        self.productsReport = json
                        self.setData()
                        self.setChart(dataPoints: self.productName, values: self.productAmount)
                    }
                }
            } catch {
                self.alert(tit: "Error", mess: "\(error)")
            }
        }
        
    }
    
    //MARK: - Supporting function
    func alert(tit: String, mess: String) {
        let alert = UIAlertController(title: tit, message: mess, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    func setUI() {
        fromDatePicker.layer.cornerRadius = 10
        fromDatePicker.maximumDate = Date()
        fromDatePicker.minimumDate = Date(timeIntervalSinceNow: -31556926)
        toDatePicker.maximumDate = Date()
        toDatePicker.layer.cornerRadius = 10
        drawButton.layer.cornerRadius = 10
        drawButton.alpha = 0.7
        drawButton.backgroundColor = .systemBlue
        drawButton.setTitleColor(.white, for: .normal)
    }
    
    func setData() {
        for item in productsReport {
            productName.append(item.product.name)
            productAmount.append(Double(item.revenue))
        }
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "NO DATA"
        
        var dataEntries = [BarChartDataEntry]()
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i], data: dataPoints)
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Revenue ($)")
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.xAxis.labelCount = productName.count
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelRotationAngle = 90.0
        barChartView.data = chartData
        barChartView.drawGridBackgroundEnabled = false
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false
        //barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        barChartView.backgroundColor = .white
        
        barChartView.xAxis.valueFormatter = axisFormatDelegate
        barChartView.animate(xAxisDuration: 0.3, yAxisDuration: 2.0)
    }
    
    
}

//MARK: - IAxisValueFormatter
extension ReportViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return productName[Int(value)]
    }
}

