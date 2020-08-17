//
//  CreateImportViewController.swift
//  FinalApp
//
//  Created by TPS on 8/13/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit
import SideMenu

class CreateImportViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, MyImportCellDelegate {
    var products: [Product] = []
    var menu: SideMenuNavigationController?
    var listProducts: [Product] = []
    var picker: UIPickerView?
    var currentDistributor: Distributor?
    var distributors: [Distributor] = []
    var isLoadingDistributor = true
    var dirError: [Int:String] = [
        2000:"PRODUCT_NAME_IS_TAKEN",
        2001:"PRODUCT_NOT_FOUND",
        2002:"ANOTHER_PRODUCT_HAS_SAME_PRICE",
        3000:"DISTRIBUTOR_NAME_IS_TAKEN",
        3001:"DISTRIBUTOR_NOT_FOUND",
        3002:"DISTRIBUTOR_ID_IS_REQUIRED",
        5000:"IMPORT_RECEIPT_DETAILS_IS_REQUIRED",
        5001:"THE_ACTUAL_TOTAL_PRICE_DIFFERS_THE_IMPORT_RECEIPT_ONE",
        6000:"TOTAL_PRICE_IS_REQUIRED"
    ]
    //MARK: - Contants
    private var menuWidth: CGFloat = 250
    private var PageIndexParams = "pageIndex"
    private var PageSizeParams = "pageSize"
    private var PageSearchStringParams = "searchString"
    private var pageIndex = 1
    private var pageSize = 20

    //MARK: - Life cycel
    @IBOutlet weak var createbtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var distributorLabel: UITextField!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        menu?.menuWidth = 250
        SideMenuManager.default.leftMenuNavigationController = menu
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CreateImportTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        updateUI()
        loadDistributor(withPage: pageIndex, withSize: pageSize, withString: "")
        loadProduct(withPage: pageIndex, withSize: pageSize, withString: "")
    }
    
    //MARK: - IBAction
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
        
    }
    @IBAction func chooseDistributorTapped(_ sender: UIButton) {
        isLoadingDistributor = true
        showPickerView()
    }
    @IBAction func addProductTapped(_ sender: UIButton) {
        isLoadingDistributor = false
        showProductPickerView()
    }
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        if listProducts.count > 0 {
            showAlertCancel(title: "", message: "Are you sure?")
        } else {
            //
        }
        
    }
    @IBAction func createBtnTapped(_ sender: UIButton) {
        if !checkNil() {
            return
        }
        var dirc: [String:Any] = [:]
        var array: [Dictionary<String, Any>] = []
        for i in listProducts {
            dirc["productId"] = "\(i.id)"
            dirc["productAmount"] = i.amount
            dirc["productPrice"] = i.price
            array.append(dirc)
            
        }
        var totalPrice = 0.0
        for index in listProducts {
            totalPrice += index.price * Double(index.amount)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = Date()
        let currentDate = dateFormatter.string(from: date)
        let param: [String:Any] = [
            "dateTime": "\(currentDate)",
            "totalPrice": totalPrice,
            "distributorId": currentDistributor?.id ?? "",
            "importReceiptDetails": array
        ]
        let route = Router.createImportReceipt
        RequestService.shared.AFRequestPostReceipt(router: route, params: param) { [weak self] (data, response, error) in
            guard let self = self else {return}
            if let respon = response {
                if respon.response?.statusCode == 200 {
                    self.alertResponse(tit: "Success", mess: "")
                } else if respon.response?.statusCode == 400 {
                    if let data = data {
                        do {
                            let json = try JSONDecoder.init().decode(PostReceiptResponse.self, from: data)
                            for (key, value) in self.dirError {
                                if key == json.code {
                                    self.alertResponseErr(tit: "Error", mess: value)
                                }
                            }
                            
                        } catch {
                            self.alertResponseErr(tit: "Oops!", mess: "Something went wrong :<")
                        }
                    } else {
                        self.alertResponseErr(tit: "Oops!", mess: "Something went wrong :<")
                    }
                } else {
                    self.alertResponseErr(tit: "Oops!", mess: "Something went wrong :<")
                }
            }
        }
    }
    
    //MARK: - Supporting Function
    func checkNil() -> Bool {
        if distributorLabel.text == "" || listProducts.count == 0 {
            alertt()
            return false
        } else {
            return true
        }
    }
    func alertt() {
        let alert = UIAlertController(title: "Error", message: "Distributor or Product can't be null", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    func alertResponse(tit: String, mess: String) {
        let alert = UIAlertController(title: tit, message: mess, preferredStyle: .alert)
        let actio = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            self.listProducts = []
            self.distributorLabel.text = ""
            self.tableView.reloadData()
        }
        alert.addAction(actio)
        present(alert, animated: true)
    }
    func alertResponseErr(tit: String, mess: String) {
        let alert = UIAlertController(title: tit, message: mess, preferredStyle: .alert)
        let actio = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actio)
        present(alert, animated: true)
    }
    func loadProduct(withPage: Int, withSize: Int, withString: String) {
        
        let param = [self.PageIndexParams: "\(String(withPage))", self.PageSizeParams: "\(String(withSize))", self.PageSearchStringParams: withString]
        let routerGetProduct = Router.getProducts
        RequestService.shared.AFRequestProduct(router: routerGetProduct, params: param, objectType: ProductResponse.self) { [weak self] (bool, data, error) in
            guard let self = self else {return}
            do {
                let json = try JSONDecoder.init().decode(ProductResponse.self, from: data!)
                self.products += json.items
            } catch {
                print("error to convert \(error.localizedDescription)")
            }
        }
        
    }
    func updateUI() {
        createbtn.layer.cornerRadius = 10
        createbtn.backgroundColor = .systemBlue
        createbtn.setTitleColor(.white, for: .normal)
    }
    func loadDistributor(withPage: Int, withSize: Int, withString: String) {
        let param = [self.PageIndexParams: "\(String(withPage))", self.PageSizeParams: "\(String(withSize))", self.PageSearchStringParams: withString]
        let route = Router.getDistributor
        RequestService.shared.AFRequestProduct(router: route, params: param, objectType: DistributorResponse.self) { [weak self] (bool, data, error) in
            guard let self = self else {return}
            do {
                let json = try JSONDecoder.init().decode(DistributorResponse.self, from: data!)
                self.distributors += json.items
            } catch {
                print("error to convert \(error.localizedDescription)")
            }
        }
    }
    func showProductPickerView() {
        let alertView = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        let pickerFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150)
        picker = UIPickerView(frame: pickerFrame)
        picker!.center.x = view.center.x
        picker!.delegate = self
        picker!.dataSource = self
        alertView.view.addSubview(picker!)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            let currentProduct = self.products[(self.picker?.selectedRow(inComponent: 0))!]
            self.listProducts.append(currentProduct)
            self.products.remove(at: (self.picker?.selectedRow(inComponent: 0))!)
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertView.addAction(action)
        alertView.addAction(cancel)
        present(alertView, animated: true)
    }
    
    func showPickerView() {
        let alertView = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        let pickerFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150)
        picker = UIPickerView(frame: pickerFrame)
        picker!.center.x = view.center.x
        picker!.delegate = self
        picker!.dataSource = self
        alertView.view.addSubview(picker!)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            self.currentDistributor = self.distributors[(self.picker?.selectedRow(inComponent: 0))!]
            self.distributorLabel.text = self.currentDistributor?.name
        }
        alertView.addAction(action)
        present(alertView, animated: true)
        
        
    }
    func showAlertCancel(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            self.listProducts = []
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    // MARK: - UIPickerViewDelegate and Datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isLoadingDistributor {
            return distributors[row].name
        } else {
            return "\(products[row].name) - $\(products[row].price)"
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isLoadingDistributor {
            return distributors.count
        } else {
            return products.count
        }
        
    }
    
    //MARK: - Cell delegate
    func deleteBtntapped(cell: CreateImportTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            products.append(listProducts[indexPath.row])
            listProducts.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
    }
    
    func amountTFDidChanged(cell: CreateImportTableViewCell, textfield: UITextField) {
        let indexPath = self.tableView.indexPath(for: cell)
        if let text = textfield.text {
            let amount = Int(text) ?? 1
            if amount != 0 {
                cell.amountTextField.text = "\(amount)"
                listProducts[indexPath!.row].amount = amount
            } else {
                listProducts.remove(at: indexPath!.row)
            }
            tableView.reloadData()
        }
    }
    
    func priceTFDidChanged(cell: CreateImportTableViewCell, textfield: UITextField) {
        let indexPath = self.tableView.indexPath(for: cell)
        if let text = textfield.text {
            let price = Double(text) ?? 1
            if price != 0 {
                cell.priceTextField.text = "\(price)"
                listProducts[indexPath!.row].price = price
            } else {
                listProducts.remove(at: indexPath!.row)
            }
            tableView.reloadData()
        }
    }

}
//MARK: - UITableViewDelegate and Datasource
extension CreateImportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listProducts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CreateImportTableViewCell
        cell.productName.text = listProducts[indexPath.row].name
        cell.amountTextField.text = "\(listProducts[indexPath.row].amount)"
        cell.priceTextField.text = "\(listProducts[indexPath.row].price)"
        cell.delegate = self
        cell.selectionStyle = .none
        let queue = DispatchQueue(label: "queue")
        queue.async {
            if let imgURL = URL(string: self.listProducts[indexPath.row].image) {
                do {
                    let imgData = try Data(contentsOf: imgURL)
                    DispatchQueue.main.async {
                        cell.productImage.image = UIImage(data: imgData)
                    }
                    
                } catch {}
            }
        }
        return cell
    }
    
    
}

