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
    var menu: SideMenuNavigationController?
    
    //MARK: - Contants
    private var totalProducts = 0
    private var pageIndex = 1
    private var pageSize = 20
    private var menuWidth: CGFloat = 250
    private var PageIndexParams = "pageIndex"
    private var PageSizeParams = "pageSize"
    private var PageSearchStringParams = "searchString"
    private let titleAdd = "Add new product"
    private let titleEdit = "Edit product"
    private let heightForRow: CGFloat = 120
    private let messageConfirmDelete = "Are you sure?"
    private enum Title: String {
        case delete = "Delete"
        case cancel = "Cancel"
        case edit = "Edit"
    }
    
    // MARK: - Iboutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: ProductTableViewCell.name, bundle: nil), forCellReuseIdentifier: "cell")
        loadProduct(withPage: pageIndex, withSize: pageSize, withString: "")
        searchBar.delegate = self
        navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateProduct), name: .didUpdateProduct, object: nil)
        
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        menu?.menuWidth = menuWidth
        SideMenuManager.default.leftMenuNavigationController = menu
        
    }
    
    @objc func loadProduct(withPage: Int, withSize: Int, withString: String) {
        
        let param = [self.PageIndexParams: "\(String(withPage))", self.PageSizeParams: "\(String(withSize))", self.PageSearchStringParams: withString]
        let routerGetProduct = Router.getProducts
        RequestService.shared.AFRequestProduct(router: routerGetProduct, params: param, objectType: ProductResponse.self) { [weak self] (bool, data, error) in
            guard let self = self else {return}
            do {
                let json = try JSONDecoder.init().decode(ProductResponse.self, from: data!)
                self.products += json.items
                self.totalProducts = json.totalItems
                self.tableView.reloadData()
            } catch {
                print("error to convert \(error.localizedDescription)")
            }
        }
        
    }
    func alertDeleteProduct(_ forProduct: Product) {
        let alert = UIAlertController(title: "\(Title.delete.rawValue) \(forProduct.name)", message: messageConfirmDelete, preferredStyle: .alert)
        let delete = UIAlertAction(title: Title.delete.rawValue, style: .default) { [weak self] (_) in
            guard let self = self else {return}
            let routerDeleteProduct = Router.deleteProducts
            if let id = self.currentProduct?.id {
                RequestService.shared.request(router: routerDeleteProduct, id: id) { [weak self] (response, error) in
                    self!.products = []
                    self?.loadProduct(withPage: 1, withSize: 20, withString: "")
                }
                
            }
        }
        let cancel = UIAlertAction(title: Title.cancel.rawValue, style: .default, handler: nil)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    // MARK: - IBAction
    @objc func didUpdateProduct() {
        loadProduct(withPage: pageIndex, withSize: pageSize, withString: "")
    }
    @IBAction func addProductTapped(_ sender: UIBarButtonItem) {
        let vc = CreateEditProductViewController()
        vc.tit = titleAdd
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTappedMenu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    @IBAction func editButtonTapped(_ sender: UIButton) {
        for item in products {
            if item.id == String((sender.titleLabel?.text)!) {
                currentProduct = item
            }
        }
        if currentProduct != nil {
            let optionMenu = UIAlertController(title: nil, message: currentProduct?.name, preferredStyle: .actionSheet)
            if let popoverController = optionMenu.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
            let edit = UIAlertAction(title: Title.edit.rawValue, style: .default) { [weak self] (_) in
                guard let self = self else {return}
                let vc = CreateEditProductViewController()
                vc.tit = self.titleEdit
                vc.productName = self.currentProduct?.name
                vc.productAmout = self.currentProduct?.amount
                vc.productPrice = self.currentProduct?.price
                vc.productId = self.currentProduct?.id
                let newImageURL = self.currentProduct!.image
                vc.productImageName = newImageURL
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let cancel = UIAlertAction(title: Title.cancel.rawValue, style: .cancel, handler: nil)
            let delete = UIAlertAction(title: Title.delete.rawValue, style: .default) { [weak self] (_) in
                guard let self = self else {return}
                self.alertDeleteProduct(self.currentProduct!)
                
            }
            optionMenu.addAction(edit)
            optionMenu.addAction(cancel)
            optionMenu.addAction(delete)
            present(optionMenu, animated: true)
        }
        else {
            print("product is loading...")
        }
    }
}
// MARK: - TableViewDelegate and Datasource
extension ProductManagerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableViewCell
        let newImageURL = products[indexPath.row].image
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
        cell.editButton.titleLabel?.text = products[indexPath.row].id
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        currentProduct = products[indexPath.row]
        
        let vc = CreateEditProductViewController()
        vc.tit = titleEdit
        vc.productName = currentProduct?.name
        vc.productAmout = currentProduct?.amount
        vc.productPrice = currentProduct?.price
        vc.productId = currentProduct?.id
        let newImageURL = currentProduct!.image
        vc.productImageName = newImageURL
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == products.count - 1 && products.count < totalProducts {
            loadProduct(withPage: pageIndex + 1, withSize: pageSize, withString: "")
        }
    }
}
// MARK: - SearchBar Delegate
//hide keyboard
extension ProductManagerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            products = []
            pageIndex = 1
            loadProduct(withPage: pageIndex, withSize: pageSize, withString: searchText)
        }
        tableView.reloadData()
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            products = []
            loadProduct(withPage: pageIndex, withSize: pageSize, withString: "")
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
//MARK: - Extension Notification
extension Notification.Name {
    static let didCreateProduct = Notification.Name("didCreateProduct")
    static let didUpdateProduct = Notification.Name("didUpdateProduct")
    static let didDeleteProduct = Notification.Name("didDeleteProduct")
}
