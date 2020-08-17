//
//  MenuTableViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var items: [ItemMenu] = [
        ItemMenu(lable: MenuName.product.rawValue, image: MenuImage.product.rawValue),
        ItemMenu(lable: MenuName.employee.rawValue, image: MenuImage.employee.rawValue),
        ItemMenu(lable: MenuName.distributor.rawValue, image: MenuImage.distributor.rawValue),
        ItemMenu(lable: MenuName.importReceipt.rawValue, image: MenuImage.importReceipt.rawValue),
        ItemMenu(lable: MenuName.createReceipt.rawValue, image: MenuImage.createReceipt.rawValue),
        ItemMenu(lable: MenuName.sale.rawValue, image: MenuImage.sale.rawValue),
        ItemMenu(lable: MenuName.report.rawValue, image: MenuImage.report.rawValue),
        ItemMenu(lable: MenuName.logout.rawValue, image: MenuImage.logout.rawValue)
    ]
    var isAdmin = LoginViewController.isAdmin
    
    //MARK: - Contants
    private enum MenuName: String {
        case product = "Product management"
        case employee = "Employee management"
        case sale = "Sale"
        case distributor = "Distributor"
        case importReceipt = "Import Receipt"
        case createReceipt = "Create Import Receipt"
        case report = "Report"
        case logout = "Log out"
    }
    private enum MenuImage: String {
        case product = "product_management_icon"
        case employee = "employee_management_icon"
        case sale = "sale_management_icon"
        case distributor = "distributor_icon"
        case importReceipt = "importReceipt_icon"
        case createReceipt = "importReceipt_icon-1"
        case report = "report_icon"
        case logout = "logout_icon"
    }
    private enum TitleAlert: String {
        case ok = "OK"
        
    }
    private enum MessageAlert: String {
        case accessDenied = "ACCESS DENIED"
    }
    private let myColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
    private let alphaForCell: CGFloat = 0.3
    private let heightForCell: CGFloat = 70.0
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(isAdmin)
        tableView.backgroundColor = .lightGray
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: MenuTableViewCell.name, bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        cell.labelViewCell?.text = items[indexPath.row].lable
        cell.imageViewCell?.image = UIImage(named: items[indexPath.row].image)
        cell.labelViewCell?.textColor = .black
        cell.backgroundColor = .lightGray
        cell.selectionStyle = .none
        if !isAdmin {
            if cell.labelViewCell.text == MenuName.product.rawValue || cell.labelViewCell.text == MenuName.employee.rawValue || cell.labelViewCell.text == MenuName.distributor.rawValue || cell.labelViewCell.text == MenuName.report.rawValue || cell.labelViewCell.text == MenuName.importReceipt.rawValue || cell.labelViewCell.text == MenuName.createReceipt.rawValue {
                cell.labelViewCell.textColor = myColor
                cell.imageViewCell.alpha = alphaForCell
                return cell
            }
        }
        return cell
    }
    func alertNotPermission() {
        let alert = UIAlertController(title: nil, message: MessageAlert.accessDenied.rawValue, preferredStyle: .alert)
        let action = UIAlertAction(title: TitleAlert.ok.rawValue, style: .destructive) { (_) in
            //do something
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch items[indexPath.row].lable {
        case MenuName.product.rawValue:
            if isAdmin {
                let vc = ProductManagerViewController()
                navigationController?.pushViewController(vc, animated: true)
            } else {
                alertNotPermission()
            }
            tableView.deselectRow(at: indexPath, animated: true)
            
        case MenuName.employee.rawValue:
            if isAdmin {
                let vc = EmployeeManagementViewController()
                navigationController?.pushViewController(vc, animated: true)
            } else {
                alertNotPermission()
            }
            tableView.deselectRow(at: indexPath, animated: true)
            
        case MenuName.sale.rawValue:
            let vc = SaleManagerViewController()
            navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        case MenuName.report.rawValue:
            if isAdmin {
                let vc = ReportViewController()
                navigationController?.pushViewController(vc, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                alertNotPermission()
            }
            
        case MenuName.distributor.rawValue:
            if isAdmin {
                let vc = DistributorViewController()
                navigationController?.pushViewController(vc, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                alertNotPermission()
            }
            
        case MenuName.importReceipt.rawValue:
            if isAdmin {
                let vc = ImportReceiptViewController()
                navigationController?.pushViewController(vc, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                alertNotPermission()
            }
        case MenuName.createReceipt.rawValue:
            if isAdmin {
                let vc = CreateImportViewController()
                navigationController?.pushViewController(vc, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                alertNotPermission()
            }
        case MenuName.logout.rawValue:
            let alert = UIAlertController(title: "Log out", message: "Are you sure?", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (_) in
                LoginViewController.token = ""
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                //self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            present(alert, animated: true)
            
        default:
            print("not match!")
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForCell
    }
}
