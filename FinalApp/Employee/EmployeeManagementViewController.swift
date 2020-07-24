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
    
    var menu: SideMenuNavigationController?
    
    // MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        navigationController?.isNavigationBarHidden = true
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        menu?.menuWidth = 300
        SideMenuManager.default.leftMenuNavigationController = menu
    }
    
    //MARK: - IBAction
    @IBAction func didTappedMenu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    @IBAction func editButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "Edit Employee", preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "Delete", style: .default) { (_) in
            self.alertDeleteProduct()
        }
        let edit = UIAlertAction(title: "Edit", style: .default) { (_) in
            let vc = EditEmployeeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let changePasswd = UIAlertAction(title: "Change Password", style: .default) { (_) in
            //self.changePassword()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(delete)
        alert.addAction(edit)
        alert.addAction(changePasswd)
        alert.addAction(cancel)
        present(alert, animated: true)
        
    }
//    func changePassword() {
//        let alert = UIAlertController(title: "Change your password", message: "", preferredStyle: .alert)
//        let oldPasswordTextField = UITextField()
//        oldPasswordTextField.placeholder = "Enter old password"
//        let newPasswordTextField = UITextField()
//        newPasswordTextField.placeholder = "New password"
//        newPasswordTextField.isSecureTextEntry = true
//        let comfirmPasswordTextField = UITextField()
//        comfirmPasswordTextField.placeholder = "Confirm new password"
//        comfirmPasswordTextField.isSecureTextEntry = true
//
//        let change = UIAlertAction(title: "Change", style: .default) { (_) in
//            //do some thing
//        }
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//        alert.addTextField { (olduiTextField) in
//            olduiTextField.placeholder = "Enter old password"
//        }
//        alert.addTextField { (newuiTextField) in
//            newuiTextField.placeholder = "Enter new password"
//        }
//        alert.addTextField { (confirmuiTextField) in
//            confirmuiTextField.placeholder = "Confirm new password"
//        }
//        alert.addAction(change)
//        alert.addAction(cancel)
//        present(alert, animated: true)
//
//    }
    func alertDeleteProduct() {
        let alert = UIAlertController(title: "Delete employee", message: "Are you sure?", preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let vc = CreateEmployeeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - tableView Delegate and Datasource
extension EmployeeManagementViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmployeeTableViewCell
        cell.employeeImage.image = UIImage(named: "employee_example")
        cell.employeeName.text = "Phan van Hung"
        cell.employeeEmail.text = "95dung95@gmail.com"
        cell.employeePhone.text = "089962863739"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
