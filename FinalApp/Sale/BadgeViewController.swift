//
//  BadgeViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit
import SideMenu

class BadgeViewController: UIViewController, MyBadgeCellDelegate {
    
    // MARK: - Contants
    var dirError: [Int:String] = [
        4000:"SALE_RECEIPT_DETAILS_IS_REQUIRED",
        4001:"THE_SALE_RECEIPT_PRODUCT_AMOUNT_IS_GREATER_THE_ACTUAL_ONE",
        4002:"THE_ACTUAL_TOTAL_PRICE_DIFFERS_THE_SALE_RECEIPT_ONE",
        5000:"IMPORT_RECEIPT_DETAILS_IS_REQUIRED",
        5001:"THE_ACTUAL_TOTAL_PRICE_DIFFERS_THE_IMPORT_RECEIPT_ONE",
        6000:"TOTAL_PRICE_IS_REQUIRED"
    ]
    
    //MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var totalPayout: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variable
    var menu: SideMenuNavigationController?
    var products: [ListProduct] = []
    var totalPrice = 0.0
    let dataFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("products.plist")
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadListProduct()
        updateUI()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(UINib(nibName: "BadgeTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        navigationController?.isNavigationBarHidden = true
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        menu?.menuWidth = 300
        SideMenuManager.default.leftMenuNavigationController = menu
    }
    
    //MARK: - Supporting Function
    func updateUI() {
        totalPrice = 0.0
        for index in products {
            totalPrice += index.price * Double(index.amount)
        }
        totalPayout.text = "Total: $\(totalPrice)"
    }
    func loadListProduct() {
        if let data = try? Data(contentsOf: dataFile!) {
            let decoder = PropertyListDecoder()
            do {
                products = try decoder.decode([ListProduct].self, from: data)
            } catch {
                print("Error decoding listProducts, \(error)")
            }
        }
    }
    func saveListProduct() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(products)
            try data.write(to: dataFile!)
        } catch {
            print("Error encoding products array, \(error)")
        }
    }
    func deleteButtonTapped(cell: BadgeTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        products.remove(at: indexPath!.row)
        saveListProduct()
        loadListProduct()
        updateUI()
        tableView.reloadData()
    }
    
    func amountTextFieldDidChanged(cell: BadgeTableViewCell, textField: UITextField) {
        let indexPath = self.tableView.indexPath(for: cell)
        if let text = textField.text {
            let amount = Int(text) ?? 1
            if amount != 0 {
                products[indexPath!.row].amount = amount
            } else {
                products.remove(at: indexPath!.row)
            }
            saveListProduct()
            loadListProduct()
            NotificationCenter.default.post(name: Notification.Name("didUpdateNumberCart"), object: totalItem())
            updateUI()
            tableView.reloadData()
        }
    }
    func totalItem() -> Int {
        var total = 0
        loadListProduct()
        for item in products {
            total += item.amount
        }
        return total
    }
    func alertResponse(tit: String, mess: String) {
        let alert = UIAlertController(title: tit, message: mess, preferredStyle: .alert)
        let actio = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            do {
                try FileManager.default.removeItem(at: self.dataFile!)
                self.products = []
                self.updateUI()
                self.tableView.reloadData()
            } catch {
                print(error)
            }
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
    
    
    
    //MARK: - IBAction
    @IBAction func didTappedMenu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func cancelPaymentTapped(_ sender: UIButton) {
        alertCancel()
    }
    func alertCancel() {
        let alert = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            do {
                try FileManager.default.removeItem(at: self.dataFile!)
                self.products = []
                self.updateUI()
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    @IBAction func paymentTapped(_ sender: UIButton) {
        
        loadListProduct()
        var dirc: [String:Any] = [:]
        var array: [Dictionary<String, Any>] = []
        for i in products {
            dirc["productId"] = "\(i.id)"
            dirc["productAmount"] = i.amount
            dirc["productPrice"] = i.price
            array.append(dirc)
            
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = Date()
        let currentDate = dateFormatter.string(from: date)
        let param: [String:Any] = [
            "dateTime": "\(currentDate)",
            "totalPrice": totalPrice,
            "saleReceiptDetails": array
        ]
        let router = Router.postSaleReceipt
        RequestService.shared.AFRequestPostReceipt(router: router, params: param) { [weak self] (data, response, error) in
            guard let self = self else {return}
            if let respon = response {
                if respon.response?.statusCode == 200 {
                    self.alertResponse(tit: "Payment complete", mess: "You payed: ($\(self.totalPrice))")
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
}

//MARK: - UITableViewDelegate and Datasource
extension BadgeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BadgeTableViewCell
        let newImageURL = products[indexPath.row].image
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: URL(string: newImageURL)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imageViewItem.image = image
                        
                    }
                }
            }
        }
        cell.productName.text = products[indexPath.row].name
        cell.amoutTextField.text = "\(products[indexPath.row].amount)"
        cell.totalLabel.text = "Total: $\(products[indexPath.row].price * Double(products[indexPath.row].amount))"
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

//MARK: - UISearchBarDelegate
extension BadgeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if let text = searchBar.text {
            products = products.filter({$0.name.lowercased().contains(text.lowercased())})
            tableView.reloadData()
        }
    }
}


