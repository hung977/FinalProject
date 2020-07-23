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
    
    var products: [Product] = []
    var currentProduct: Product?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var menu: SideMenuNavigationController?
    override func viewDidLoad() {
        
        let routerGetProduct = Router.getProducts
        RequestService.shared.AFRequestWithRawData(router: routerGetProduct, parameters: nil, objectType: ProductResponse.self) { (bool, json, error) in
            if let json = json as? ProductResponse {
                self.products = json.items
                self.tableView.reloadData()
            }
        }
        
        
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
                let newImageURL = self.currentProduct!.image.replacingOccurrences(of: "https://localhost:44393", with: "http://192.168.30.101:8081")
                vc.productImageName = newImageURL
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
                    break
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
        let newImageURL = products[indexPath.row].image.replacingOccurrences(of: "https://localhost:44393", with: "http://192.168.30.101:8081")
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: URL(string: newImageURL)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.productImage.image = image
                        
                    }
                }
            }
        }
        
        cell.amoutLabel.text = "Amount: \(products[indexPath.row].amount)"
        cell.productName.text = products[indexPath.row].name
        cell.productPrice.text = "Price: $\(products[indexPath.row].price)"
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
