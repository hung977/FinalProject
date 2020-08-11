//
//  DistributorViewController.swift
//  FinalApp
//
//  Created by TPS on 8/11/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit
import SideMenu

class DistributorViewController: UIViewController, MyDistributorCellDelegate {
    
    var menu: SideMenuNavigationController?
    var distributors: [Distributor] = []
    var currentDistributor: Distributor?
    //MARK: - Contants
    private var totalDistributor = 0
    private var menuWidth: CGFloat = 300
    private var PageIndexParams = "pageIndex"
    private var PageSizeParams = "pageSize"
    private var PageSearchStringParams = "searchString"
    private var pageIndex = 1
    private var pageSize = 20
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Life cycel
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(UINib(nibName: DistributorTableViewCell.name, bundle: nil), forCellReuseIdentifier: "cell")
        navigationController?.isNavigationBarHidden = true
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        menu?.menuWidth = menuWidth
        SideMenuManager.default.leftMenuNavigationController = menu
        loadDistributor(withPage: pageIndex, withSize: pageSize, withString: "")
    }
    
    //MARK: - IBAction
    @IBAction func menuTapped(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    @IBAction func addBtnTapped(_ sender: UIBarButtonItem) {
    }
    func editButtonTapped(cell: DistributorTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        currentDistributor = distributors[indexPath!.row]
        let alert = UIAlertController(title: currentDistributor?.name, message: nil, preferredStyle: .actionSheet)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = cell
            popoverController.sourceRect = cell.bounds
        }
        let edit = UIAlertAction(title: "Edit", style: .default) { (_) in
            self.alertEditDistributor(for: self.currentDistributor!)
        }
        let delete = UIAlertAction(title: "Delete", style: .default) { (_) in
            //
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(edit)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    //MARK: - Supporting Func
    func alertEditDistributor(for distributor: Distributor) {
        var name = UITextField()
        var address = UITextField()
        let alert = UIAlertController(title: distributor.name, message: nil, preferredStyle: .alert)
        alert.addTextField { (uiTextField) in
            uiTextField.placeholder = "Enter distributor name"
            uiTextField.text = distributor.name
            uiTextField.layer.cornerRadius = 10
            name = uiTextField
        }
        alert.addTextField { (uiTextField) in
            uiTextField.placeholder = "Enter distributor address"
            uiTextField.text = distributor.address
            uiTextField.layer.cornerRadius = 10
            address = uiTextField
        }
        let action = UIAlertAction(title: "Change", style: .default) { (_) in
            if let nameStr = name.text, let addressStr = address.text {
                let route = Router.editDistributor
                let param = [
                    "Name" : nameStr,
                    "Address" : addressStr
                ]
                RequestService.shared.AFRequestChangePassWord(router: route, id: distributor.id, params: param) { [weak self] (data, response, error) in
                    guard let self = self else {return}
                    
                    let statusCode = response?.response?.statusCode
                    if statusCode == 200 || statusCode == 204 {
                        self.alertResponseAPISuccess(tit: "Success", mess: "Edited for \(distributor.name).")
                    } else if statusCode == 401 {
                        self.alertResponseAPIError(tit: "Error", mess: "Unauthorized")
                    } else if statusCode == 403 {
                        self.alertResponseAPIError(tit: "Error", mess: "Forbidden")
                    } else {
                        if let safeData = data {
                            self.alertResponseAPIError(tit: "Error", mess: "\(String(data: safeData, encoding: .utf8) ?? "Something went wrong!")")
                            
                        }
                    }
                }
                
            } else {
                self.alertResponseAPIError(tit: "Error", mess: "Missing Field")
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated:  true)
    }
    func alertResponseAPIError(tit: String, mess: String) {
        let alert = UIAlertController(title: tit, message: mess, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    func alertResponseAPISuccess(tit: String, mess: String) {
        let alert = UIAlertController(title: tit, message: mess, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            self.loadDistributor(withPage: self.pageIndex, withSize: self.pageSize, withString: "")
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    func loadDistributor(withPage: Int, withSize: Int, withString: String) {
        let param = [self.PageIndexParams: "\(String(withPage))", self.PageSizeParams: "\(String(withSize))", self.PageSearchStringParams: withString]
        let route = Router.getDistributor
        RequestService.shared.AFRequestProduct(router: route, params: param, objectType: DistributorResponse.self) { [weak self] (bool, data, error) in
            guard let self = self else {return}
            do {
                let json = try JSONDecoder.init().decode(DistributorResponse.self, from: data!)
                self.distributors += json.items
                self.totalDistributor = json.totalItems
                self.tableView.reloadData()
            } catch {
                print("error to convert \(error.localizedDescription)")
            }
        }
    }
    
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension DistributorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return distributors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DistributorTableViewCell
        cell.nameLabel.text = distributors[indexPath.row].name
        cell.addressLabel.text = distributors[indexPath.row].address
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        currentDistributor = distributors[indexPath.row]
        
        //        let vc = CreateEditProductViewController()
        //        vc.tit = titleEdit
        //        vc.productName = currentProduct?.name
        //        vc.productAmout = currentProduct?.amount
        //        vc.productPrice = currentProduct?.price
        //        vc.productId = currentProduct?.id
        //        let newImageURL = currentProduct!.image
        //        vc.productImageName = newImageURL
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == distributors.count - 1 && distributors.count < totalDistributor {
            loadDistributor(withPage: pageIndex + 1, withSize: pageSize + 1, withString: "")
        }
    }
}

//MARK: - UISearchBarDelegate
extension DistributorViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            distributors = []
            pageIndex = 1
            loadDistributor(withPage: pageIndex, withSize: pageSize, withString: searchText)
        }
        tableView.reloadData()
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            distributors = []
            loadDistributor(withPage: pageIndex, withSize: pageSize, withString: "")
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

