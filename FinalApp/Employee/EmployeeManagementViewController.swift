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
    
    // MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(UINib(nibName: "EmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        loadEmployee()
        navigationController?.isNavigationBarHidden = true
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        menu?.menuWidth = 300
        SideMenuManager.default.leftMenuNavigationController = menu
    }
    func loadEmployee() {
        DispatchQueue.main.async {
            let routerGetProduct = Router.getEmployee
            RequestService.shared.AFRequestWithRawData(router: routerGetProduct, parameters: nil, objectType: EmployeeResponse.self) { (bool, data, error) in
                do {
                    
                    
                    let json = try JSONDecoder.init().decode(EmployeeResponse.self, from: data!)
                    self.employees = json.items
                    self.tableView.reloadData()
                } catch {
                    print("error to convert \(error.localizedDescription)")
                }
            }
        }
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
        } else {
            print("Employee is loading...")
        }
        
        
    }
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
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmployeeTableViewCell
        //        let newImageURL = employees[indexPath.row].image.replacingOccurrences(of: "https://localhost:44393", with: "http://192.168.30.101:8081")
        //        DispatchQueue.global().async {
        //            if let data = try? Data(contentsOf: URL(string: newImageURL)!) {
        //                if let image = UIImage(data: data) {
        //                    DispatchQueue.main.async {
        //                        cell.employeeImage.image = image
        //
        //                    }
        //                }
        //            }
        //        }
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
    
    
}

// MARK: - UISearchBarDelegate
extension EmployeeManagementViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            employees = employees.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        }
        tableView.reloadData()
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadEmployee()
            tableView.reloadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

