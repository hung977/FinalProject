//
//  EmployeeManagementViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit
import SideMenu

class EmployeeManagementViewController: UIViewController {
    
    var employees: [Employee] = []
    var currentEmployee: Employee?
    var menu: SideMenuNavigationController?
    
    //MARK: - Contants
    private var totalProducts = 0
    private var pageIndex = 1
    private var pageSize = 20
    private var menuWidth: CGFloat = 300
    private var PageIndexParams = "pageIndex"
    private var PageSizeParams = "pageSize"
    private var PageSearchStringParams = "searchString"
    
    // MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "EmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        loadEmployee(withPage: pageIndex, withSize: pageSize, withString: "")
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        navigationController?.isNavigationBarHidden = true
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        menu?.menuWidth = menuWidth
        SideMenuManager.default.leftMenuNavigationController = menu
    }
    
    //MARK: - IBAction
    @IBAction func didTappedMenu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    @IBAction func editButtonTapped(_ sender: UIButton) {
        
        for employee in employees {
            if employee.id == String((sender.titleLabel?.text)!) {
                currentEmployee = employee
            }
        }
        if currentEmployee != nil {
            let alert = UIAlertController(title: nil, message: "Edit \(currentEmployee?.name ?? "Default_name")", preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "Delete", style: .default) { (_) in
                self.alertDeleteProduct()
            }
            let edit = UIAlertAction(title: "Edit", style: .default) { (_) in
                let vc = EditEmployeeViewController()
                vc.name = self.currentEmployee?.name
                vc.email = self.currentEmployee?.email
                vc.phoneNumber = self.currentEmployee?.phoneNumber
                vc.isAdmin = self.currentEmployee?.role == "admin" ? true : false
                vc.id = self.currentEmployee?.id
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let changePasswd = UIAlertAction(title: "Change Password", style: .default) { (_) in
                self.changePassword(name: self.currentEmployee!.name)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(delete)
            alert.addAction(edit)
            alert.addAction(changePasswd)
            alert.addAction(cancel)
            present(alert, animated: true)
        } else {
            print("Employee is loading...")
        }
        
        
    }
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let vc = CreateEmployeeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - Supporting funciton
    func changePassword(name: String) {
        var password = UITextField()
        var confirm = UITextField()
        let alert = UIAlertController(title: "Change Password for \(name)", message: nil, preferredStyle: .alert)
        alert.addTextField { (uiTFpassword) in
            uiTFpassword.placeholder = "Enter password"
            uiTFpassword.isSecureTextEntry = true
            uiTFpassword.layer.cornerRadius = 100
            password = uiTFpassword
        }
        alert.addTextField { (uiTFconfirm) in
            uiTFconfirm.placeholder = "confirm Password"
            uiTFconfirm.isSecureTextEntry = true
            uiTFconfirm.layer.cornerRadius = 100
            confirm = uiTFconfirm
        }
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            if let passwordTF = password.text, let confirmTF = confirm.text {
                let router = Router.changePassword
                let param = [
                    "password": "\(passwordTF)",
                    "confirmPassword": "\(confirmTF)"
                ]
                if let userId = self.currentEmployee?.id {
                    RequestService.shared.AFRequestChangePassWord(router: router, id: userId, params: param) { (data, response, error) in
//                        if let safeData = data {
//                            let json = try? JSONDecoder.init().decode(ChangePasswordResponse.self, from: safeData)
//                            print(json?.Password)
//                        }
                    }
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func loadEmployee(withPage: Int, withSize: Int, withString: String) {
        DispatchQueue.main.async {
            let param = [self.PageIndexParams: "\(String(withPage))", self.PageSizeParams: "\(String(withSize))", self.PageSearchStringParams: withString]
            let routerGetProduct = Router.getEmployee
            RequestService.shared.AFRequestProduct(router: routerGetProduct, params: param, objectType: EmployeeResponse.self) { (bool, data, error) in
                do {
                    let json = try JSONDecoder.init().decode(EmployeeResponse.self, from: data!)
                    self.employees += json.items
                    self.totalProducts = json.totalItems
                    self.tableView.reloadData()
                    
                    
                } catch {
                    print("error to convert \(error.localizedDescription)")
                }
            }
        }
    }
    func alertResponseAPIError(tit: String, mess: String) {
        let alert = UIAlertController(title: tit, message: mess, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    func alertResponseAPISuccess(tit: String, mess: String) {
        let alert = UIAlertController(title: tit, message: mess, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            self.loadEmployee(withPage: self.pageIndex, withSize: self.pageSize, withString: "")
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    func alertDeleteProduct() {
        let alert = UIAlertController(title: "Delete employee", message: "Are you sure?", preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete", style: .default) { (_) in
            let router = Router.deleteEmployee
            RequestService.shared.request(router: router, id: (self.currentEmployee?.id)!) { (response, error) in
                if let respon = response {
                    if respon.response?.statusCode == 204 || respon.response?.statusCode == 200 {
                        self.alertResponseAPISuccess(tit: "Success", mess: "Removed \(self.currentEmployee?.name ?? "")")
                    } else if respon.response?.statusCode == 401 {
                        self.alertResponseAPIError(tit: "Error", mess: "Error: Unauthorized")
                    } else if respon.response?.statusCode == 403 {
                        self.alertResponseAPIError(tit: "Error", mess: "Error: Forbidden")
                    } else {
                        self.alertResponseAPIError(tit: "Error", mess: "_SERVER_ERROR_")
                    }
                } else {
                    if let error = error {
                        self.alertResponseAPIError(tit: "Error", mess: "_SERVER_ERROR_\(error)")
                    }
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
}

// MARK: - tableView Delegate and Datasource
extension EmployeeManagementViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmployeeTableViewCell
        cell.employeeImage.image = UIImage(named: "employee_example")
        cell.employeeName.text = employees[indexPath.row].name
        cell.employeeEmail.text = employees[indexPath.row].email
        cell.employeePhone.text = employees[indexPath.row].phoneNumber
        cell.editButton.titleLabel?.text = employees[indexPath.row].id
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == employees.count - 1 && employees.count < totalProducts {
            loadEmployee(withPage: pageIndex + 1, withSize: pageSize, withString: "")
        }
    }
    
    
}

// MARK: - SearchBar Delegate
//hide keyboard
extension EmployeeManagementViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            employees = []
            pageIndex = 1
            loadEmployee(withPage: pageIndex, withSize: pageSize, withString: searchText)
        }
        tableView.reloadData()
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            employees = []
            loadEmployee(withPage: pageIndex, withSize: pageSize, withString: "")
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


