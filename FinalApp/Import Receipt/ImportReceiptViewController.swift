//
//  ImportReceiptViewController.swift
//  FinalApp
//
//  Created by TPS on 8/12/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit
import SideMenu

class ImportReceiptViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var menu: SideMenuNavigationController?
    var picker: UIPickerView?
    var datePicker: UIDatePicker?
    var currencyArray: [String] = []
    var employees: [Employee] = []
    var importReceipts: [Import] = []
    var currentImportDetail: [ImportReceiptDetail]?
    //MARK: - IBOutlet
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userSwitch: UISwitch!
    @IBOutlet weak var dateSwitch: UISwitch!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Life cycel
    override func viewDidLoad() {
        loadEmployee()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ImportTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        super.viewDidLoad()
        loadImportReceipt(searchString: "", pageIndex: 1, pageSize: 20, date: "")
        updateUI()
        
    }
    //MARK: - IBAction
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        loadImportReceipt(searchString: userLabel.text ?? "", pageIndex: 1, pageSize: 20, date: dateLabel.text ?? "")
    }
    @IBAction func menuBtnTapped(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    @IBAction func switchUserChanged(_ sender: UISwitch) {
        if sender.isOn == true {
            showPickerView()
        } else {
            userLabel.text = ""
        }
    }
    @IBAction func switchDateChanged(_ sender: UISwitch) {
        if sender.isOn == true {
            showDatePickerView()
        } else {
            dateLabel.text = ""
        }
    }
    @IBAction func addBtnTapped(_ sender: UIBarButtonItem) {
        let vc = CreateImportViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
    }
    //MARK: - Supporting func
    func loadImportReceipt(searchString: String, pageIndex: Int, pageSize: Int, date: String) {
        var day = ""
        var month = ""
        var year = ""
        if date != "" {
            let time = date.split(separator: "-").map(String.init)
            day = time[0]
            month = time[1]
            year = time[2]
        }
        let param = [
            "searchString" : searchString,
            "pageIndex" : "\(pageIndex)",
            "pageSize" : "\(pageSize)",
            "year" : year,
            "month" : month,
            "day" : day
        ]
        let route = Router.getImportReceipt
        RequestService.shared.AFRequestProduct(router: route, params: param, objectType: ImportResponse.self) { [weak self] (bool, data, error) in
            guard let self  = self else {return}
            do {
                if let unwrapError = error {
                    self.alertResponseErr(title: "Error", message: unwrapError.localizedDescription)
                } else {
                    let json = try JSONDecoder.init().decode(ImportResponse.self, from: data!)
                    self.importReceipts = json.items
                    self.tableView.reloadData()
                }
            } catch(let error) {
                self.alertResponseErr(title: "Error", message: error.localizedDescription)
            }
        }
    }
    func alertResponseErr(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    func updateUI() {
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        menu?.menuWidth = 250
        SideMenuManager.default.leftMenuNavigationController = menu
        userLabel.text = ""
        dateLabel.text = ""
        userSwitch.isOn = false
        dateSwitch.isOn = false
        searchBtn.layer.cornerRadius = 10
        searchBtn.backgroundColor = .systemBlue
        searchBtn.setTitleColor(.white, for: .normal)
        
    }
    func showDatePickerView() {
        let alertView = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.actionSheet)
        if let popoverController = alertView.popoverPresentationController {
            popoverController.sourceView = dateSwitch
            popoverController.sourceRect = dateSwitch.bounds
        }
        let pickerFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150)
        datePicker = UIDatePicker(frame: pickerFrame)
        datePicker!.center.x = self.view.center.x
        datePicker?.datePickerMode = .date
        alertView.view.addSubview(datePicker!)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let date = dateFormatter.string(from: self.datePicker!.date)
            self.dateLabel.text = date
        }
        alertView.addAction(action)
        present(alertView, animated: true, completion: nil)
    }
    func showPickerView() {
        let alertView = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.actionSheet)
        if let popoverController = alertView.popoverPresentationController {
            popoverController.sourceView = userSwitch
            popoverController.sourceRect = userSwitch.bounds
        }
        let pickerFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150)
        picker = UIPickerView(frame: pickerFrame)
        picker!.center.x = self.view.center.x
        
        picker!.delegate = self
        picker!.dataSource = self
        
        alertView.view.addSubview(picker!)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            let currentUser = self.currencyArray[(self.picker?.selectedRow(inComponent: 0))!]
            self.userLabel.text = currentUser
        }
        alertView.addAction(action)
        present(alertView, animated: true, completion: nil)
    }
    func addName() {
        for employee in employees {
            currencyArray.append(employee.name ?? employee.id)
        }
    }
    func loadEmployee() {
        DispatchQueue.main.async {

            let routerGetProduct = Router.getEmployee
            RequestService.shared.AFRequestProduct(router: routerGetProduct, params: nil, objectType: EmployeeResponse.self) {
                [weak self] (bool, data, error) in
                guard let self = self else {return}
                do {
                    let json = try JSONDecoder.init().decode(EmployeeResponse.self, from: data!)
                    self.employees += json.items
                    self.addName()
                } catch {
                    print("error to convert \(error.localizedDescription)")
                }
            }
        }
    }
    //MARK: - UIPickerViewDelegate and DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
}

//MARK: - UITableViewDataSource and UITabelViewDelegate
extension ImportReceiptViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importReceipts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ImportTableViewCell
        cell.distributor.text = importReceipts[indexPath.row].distributor
        cell.user.text = importReceipts[indexPath.row].user
        cell.price.text = "$\(importReceipts[indexPath.row].totalPrice)"
        cell.importReceipts.text = "Import Receipt Details: \(importReceipts[indexPath.row].importReceiptDetails?.count ?? 0)"
        cell.date.text = importReceipts[indexPath.row].dateTime
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ReceiptDetailViewController()
        vc.imports = importReceipts[indexPath.row].importReceiptDetails ?? []
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
}

