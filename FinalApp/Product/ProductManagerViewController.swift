//
//  ProductManagerViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit
import SideMenu

class ProductManagerViewController: UIViewController {
    
    var products: [Product] = [Product(name: "iPhone XSMax", price: 999.99, amount: 12, image: "iphonexsmax"),
                               Product(name: "iPhone XS", price: 799.99, amount: 7, image: "iphonexs"),
                               Product(name: "iPhone 11", price: 809.99, amount: 9, image: "iphone11"),
                               Product(name: "iPhone 11 pro", price: 999.99, amount: 21, image: "iphone11pro"),
                               Product(name: "iPhone 11 pro max", price: 1099.99, amount: 14, image: "iphone11promax"),
                               Product(name: "Samsung P20", price: 599.99, amount: 4, image: "samsungp20"),
                               Product(name: "Samsung P20 pro", price: 999.99, amount: 22, image: "samsungp20pro"),
                               Product(name: "Samsung A350", price: 399.99, amount: 9, image: "samsunga350"),
                               Product(name: "Samsung S9 plus", price: 599.99, amount: 3, image: "samsungs9plus"),
                               Product(name: "Xiaomi P30", price: 499.99, amount: 1, image: "xiaomip30"),
                               Product(name: "Xiaomi P30 Pro", price: 799.99, amount: 4, image: "xiaomip30pro"),
                               Product(name: "Huawei", price: 199.99, amount: 7, image: "huawei"),
                               Product(name: "Huawei Pro", price: 399.99, amount: 18, image: "huaweipro"),
                               Product(name: "OPPO S9", price: 699.99, amount: 1, image: "oppos9"), ]
    var currentProduct: Product?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var menu: SideMenuNavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        searchBar.delegate = self
        navigationController?.isNavigationBarHidden = true
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        menu?.menuWidth = 300
        SideMenuManager.default.leftMenuNavigationController = menu
    }
    
    @IBAction func addProductTapped(_ sender: UIBarButtonItem) {
        let vc = CreateEditProductViewController()
        vc.tit = "Add new product"
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTappedMenu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    @IBAction func editButtonTapped(_ sender: UIButton) {
        if let currentCell = Int((sender.titleLabel?.text)!) {
            currentProduct = products[currentCell]
            let optionMenu = UIAlertController(title: nil, message: currentProduct?.name, preferredStyle: .actionSheet)
            let edit = UIAlertAction(title: "Edit", style: .default) { (_) in
                let vc = CreateEditProductViewController()
                vc.tit = "Edit product"
                vc.productName = self.currentProduct?.name
                vc.productAmout = self.currentProduct?.amount
                vc.productPrice = self.currentProduct?.price
                vc.productImageName = self.currentProduct?.image
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let delete = UIAlertAction(title: "Delete", style: .default) { (_) in
                self.alertDeleteProduct(self.currentProduct!)
                
            }
            optionMenu.addAction(edit)
            optionMenu.addAction(cancel)
            optionMenu.addAction(delete)
            present(optionMenu, animated: true)
        }
        
    }
    func alertDeleteProduct(_ forProduct: Product) {
        let alert = UIAlertController(title: "Delete \(forProduct.name)", message: "Are you sure?", preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete", style: .default) {(_) in
            for index in self.products.enumerated() {
                if self.products[index.offset].name == forProduct.name {
                    self.products.remove(at: index.offset)
                }
            }
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
}
// MARK: - TableViewDelegate and Datasource
extension ProductManagerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableViewCell
        cell.productImage.image = UIImage(named: products[indexPath.row].image)
        cell.amoutLabel.text = "Amount: \(products[indexPath.row].amount)"
        cell.productName.text = products[indexPath.row].name
        cell.productPrice.text = "$\(products[indexPath.row].price)"
        cell.editButton.titleLabel?.text = String(indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
// MARK: - SearchBar Delegate
//hide keyboard
extension ProductManagerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
