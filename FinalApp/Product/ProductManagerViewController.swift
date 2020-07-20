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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
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
        let optionMenu = UIAlertController(title: nil, message: "Product One", preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit", style: .default) { (_) in
            let vc = CreateEditProductViewController()
            vc.tit = "Edit product"
            vc.productName = "Product One"
            vc.productAmout = "100"
            vc.productPrice = "$99.99"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        //let edit = UIAlertAction(title: "Edit", style: .default, handler: nil)
        let delete = UIAlertAction(title: "Delete", style: .default) { (_) in
            self.alertDeleteProduct()
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        optionMenu.addAction(edit)
        optionMenu.addAction(delete)
        optionMenu.addAction(cancel)
        present(optionMenu, animated: true)
    }
    func alertDeleteProduct() {
        let alert = UIAlertController(title: "Delete product one", message: "Are you sure?", preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
}
// MARK: - TableViewDelegate and Datasource
extension ProductManagerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableViewCell
        cell.productImage.image = UIImage(named: "hamburger")
        cell.amoutLabel.text = "100"
        cell.productName.text = "Product One"
        cell.productPrice.text = "Price: $99.99"
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
        //print(searchBar.text!)
    }
}
