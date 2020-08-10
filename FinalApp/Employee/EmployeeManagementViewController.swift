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
    private var default_name = "Default_name"
    private var roleAdmin = "admin"
    private var passwordPlacehold = "Enter password"
    private var cofirmPasswordPlacehold = "confirm Password"
    private var passwordLayerValue: CGFloat = 100
    private var passworParam = "password"
    private var confirmParam = "confirmPassword"
    private var defaultNameImage = "employee_example"
    private var noName = "NO_NAME"
    private var noPhoneNumber = "NO_PHONE_NUMBER"
    private var heightForRow: CGFloat = 120
    private enum Title: String {
        case delete = "Delete"
        case edit = "Edit"
        case changePassword = "Change Password"
        case cancel = "Cancel"
        case ok = "OK"
        case success = "Success"
        case error = "ERROR"
    }
    private enum Message: String {
        case edit = "Edit"
        case areYouSure = "Are you sure?"
        case changePassword = "Change Password"
        case unauthorized = "Unauthorized"
        case forbidden = "Forbidden"
        case oops = "Some thing went wrong!"
        case errorParseJSON = "Can't parse JSON"
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: EmployeeTableViewCell.name, bundle: nil), forCellReuseIdentifier: "cell")
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
            let alert = UIAlertController(title: nil, message: "\(Message.edit.rawValue) \(currentEmployee?.name ?? default_name)", preferredStyle: .actionSheet)
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
            let delete = UIAlertAction(title: Title.delete.rawValue, style: .default) { [weak self] (_) in
                guard let self = self else {return}
                self.alertDeleteProduct()
            }
            let edit = UIAlertAction(title: Title.edit.rawValue, style: .default) { [weak self] (_) in
                guard let self = self else {return}
                let vc = EditEmployeeViewController()
                if let newImageURL = self.currentEmployee?.image {
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: URL(string: newImageURL)!) {
                            if let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    vc.employeeImg.image = image
                                    
                                }
                            }
                        }
                    }
                }
                vc.name = self.currentEmployee?.name
                vc.email = self.currentEmployee?.email
                vc.phoneNumber = self.currentEmployee?.phoneNumber
                vc.isAdmin = self.currentEmployee?.role == self.roleAdmin ? true : false
                vc.id = self.currentEmployee?.id
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let changePasswd = UIAlertAction(title: Title.changePassword.rawValue, style: .default) { [weak self] (_) in
                guard let self = self else {return}
                self.changePassword(name: self.currentEmployee!.name ?? self.default_name)
            }
            let cancel = UIAlertAction(title: Title.cancel.rawValue, style: .cancel, handler: nil)
            
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
        let alert = UIAlertController(title: "\(Title.changePassword.rawValue) for \(name)", message: nil, preferredStyle: .alert)
        alert.addTextField { (uiTFpassword) in
            uiTFpassword.placeholder = self.passwordPlacehold
            uiTFpassword.isSecureTextEntry = true
            uiTFpassword.layer.cornerRadius = self.passwordLayerValue
            password = uiTFpassword
        }
        alert.addTextField { (uiTFconfirm) in
            uiTFconfirm.placeholder = self.cofirmPasswordPlacehold
            uiTFconfirm.isSecureTextEntry = true
            uiTFconfirm.layer.cornerRadius = self.passwordLayerValue
            confirm = uiTFconfirm
        }
        let action = UIAlertAction(title: Title.ok.rawValue, style: .default) { (_) in
            if let passwordTF = password.text, let confirmTF = confirm.text {
                let router = Router.changePassword
                let param = [
                    self.passworParam: "\(passwordTF)",
                    self.confirmParam: "\(confirmTF)"
                ]
                if let userId = self.currentEmployee?.id {
                    RequestService.shared.AFRequestChangePassWord(router: router, id: userId, params: param) { [weak self] (data, response, error) in
                        guard let self = self else {return}
                        do {
                            let statusCode = response?.response?.statusCode
                            if statusCode == 200 || statusCode == 204 {
                                self.alertResponseAPISuccess(tit: Title.success.rawValue, mess: "\(Message.changePassword.rawValue) for \(userId).")
                            } else if statusCode == 401 {
                                self.alertResponseAPIError(tit: Title.error.rawValue, mess: Message.unauthorized.rawValue)
                            } else if statusCode == 403 {
                                self.alertResponseAPIError(tit: Title.error.rawValue, mess: Message.forbidden.rawValue)
                            } else {
                                if let safeData = data {
                                    let json = try JSONDecoder.init().decode(ChangePasswordResponse.self, from: safeData)
                                    if let pass = json.Password, let confirm = json.ConfirmPassword {
                                        self.alertResponseAPIError(tit: Title.error.rawValue, mess: "\(pass), \(confirm)")
                                    } else {
                                        self.alertResponseAPIError(tit: Title.error.rawValue, mess: Message.oops.rawValue)
                                    }
                                    
                                }
                            }

                        } catch {
                            self.alertResponseAPIError(tit: Title.error.rawValue, mess: Message.errorParseJSON.rawValue)
                        }
                    }
                }
            }
        }
        let cancel = UIAlertAction(title: Title.cancel.rawValue, style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func loadEmployee(withPage: Int, withSize: Int, withString: String) {
        DispatchQueue.main.async {
            let param = [self.PageIndexParams: "\(String(withPage))", self.PageSizeParams: "\(String(withSize))", self.PageSearchStringParams: withString]
            let routerGetProduct = Router.getEmployee
            RequestService.shared.AFRequestProduct(router: routerGetProduct, params: param, objectType: EmployeeResponse.self) {
                [weak self] (bool, data, error) in
                guard let self = self else {return}
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
        let action = UIAlertAction(title: Title.ok.rawValue, style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    func alertResponseAPISuccess(tit: String, mess: String) {
        let alert = UIAlertController(title: tit, message: mess, preferredStyle: .alert)
        let action = UIAlertAction(title: Title.ok.rawValue, style: .default) { [weak self] (_) in
            guard let self = self else {return}
            self.loadEmployee(withPage: self.pageIndex, withSize: self.pageSize, withString: "")
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    func alertDeleteProduct() {
        let alert = UIAlertController(title: Title.delete.rawValue, message: Message.areYouSure.rawValue, preferredStyle: .alert)
        let delete = UIAlertAction(title: Title.delete.rawValue, style: .default) { [weak self] (_) in
            guard let self = self else {return}
            let router = Router.deleteEmployee
            RequestService.shared.request(router: router, id: (self.currentEmployee?.id)!) { [weak self] (response, error) in
                guard let self = self else {return}
                if let respon = response {
                    if respon.response?.statusCode == 204 || respon.response?.statusCode == 200 {
                        self.alertResponseAPISuccess(tit: Title.success.rawValue, mess: "Removed \(self.currentEmployee?.name ?? "")")
                    } else if respon.response?.statusCode == 401 {
                        self.alertResponseAPIError(tit: Title.error.rawValue, mess: Message.unauthorized.rawValue)
                    } else if respon.response?.statusCode == 403 {
                        self.alertResponseAPIError(tit: Title.error.rawValue, mess: Message.forbidden.rawValue)
                    } else {
                        self.alertResponseAPIError(tit: Title.error.rawValue, mess: Message.oops.rawValue)
                    }
                } else {
                    if let error = error {
                        self.alertResponseAPIError(tit: Title.error.rawValue, mess: "\(Message.oops.rawValue)\(error)")
                    }
                }
            }
        }
        let cancel = UIAlertAction(title: Title.cancel.rawValue, style: .default, handler: nil)
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
        if let newImageURL = employees[indexPath.row].image {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: URL(string: newImageURL)!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.employeeImage.image = image
                            cell.employeeImage.layer.cornerRadius = cell.employeeImage.frame.size.height / 2
                            cell.clipsToBounds = true
                            
                        }
                    }
                }
            }
        } else {
            cell.employeeImage.image = UIImage(named: defaultNameImage)
            cell.employeeImage.layer.cornerRadius = cell.employeeImage.frame.size.height / 2
            cell.clipsToBounds = true
        }
        cell.employeeName.text = employees[indexPath.row].name ?? noName
        cell.employeePhone.text = employees[indexPath.row].phoneNumber ?? noPhoneNumber
        cell.editButton.titleLabel?.text = employees[indexPath.row].id
        cell.employeeEmail.text = employees[indexPath.row].email
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow
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


