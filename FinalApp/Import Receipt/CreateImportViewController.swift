//
//  CreateImportViewController.swift
//  FinalApp
//
//  Created by TPS on 8/13/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class CreateImportViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, MyImportCellDelegate {
    var products: [Product] = []
    var listProducts: [Product] = []
    var picker: UIPickerView?
    var distributors: [Distributor] = []
    var isLoadingDistributor = true
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CreateImportTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        updateUI()
        loadDistributor(withPage: pageIndex, withSize: pageSize, withString: "")
        loadProduct(withPage: pageIndex, withSize: pageSize, withString: "")
    }
    
    //MARK: - IBAction
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        if listProducts.count > 0 {
            showAlertCancel(title: "", message: "Are you sure?")
        } else {
            dismiss(animated: true, completion: nil)
        }
        
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
            dismiss(animated: true, completion: nil)
        }
        
    }
    @IBAction func createBtnTapped(_ sender: UIButton) {
    }
    
    //MARK: - Supporting Function
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
            let currentDistributor = self.distributors[(self.picker?.selectedRow(inComponent: 0))!]
            self.distributorLabel.text = currentDistributor.name
        }
        alertView.addAction(action)
        present(alertView, animated: true)
        
        
    }
    func showAlertCancel(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            self.dismiss(animated: true, completion: nil)
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
        cell.priceTextField.text = "\(listProducts[indexPath.row].price)"
        cell.delegate = self
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

