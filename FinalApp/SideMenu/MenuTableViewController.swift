//
//  MenuTableViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
        
    var items: [Item] = [Item(lable: "Product management", image: "product_management_icon"), Item(lable: "Employee management", image: "employee_management_icon"), Item(lable: "Sale", image: "sale_management_icon"), Item(lable: "Report", image: "report_icon")]
    var isAdmin = true
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .lightGray
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

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
            if cell.labelViewCell.text == "Product management" || cell.labelViewCell.text == "Employee management" {
                cell.labelViewCell.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
                cell.imageViewCell.alpha = 0.3
                return cell
            }
        }
        return cell
        
    }
    func alertNotPermission() {
        let alert = UIAlertController(title: nil, message: "Access denied!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            //do something
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch items[indexPath.row].lable {
        case "Product management":
            if isAdmin {
                let vc = ProductManagerViewController()
                navigationController?.pushViewController(vc, animated: true)
            } else {
                alertNotPermission()
            }
            tableView.deselectRow(at: indexPath, animated: true)
            
        case "Employee management":
            if isAdmin {
                let vc = EmployeeManagementViewController()
                navigationController?.pushViewController(vc, animated: true)
            } else {
                alertNotPermission()
            }
            tableView.deselectRow(at: indexPath, animated: true)
            
        case "Sale":
            let vc = SaleManagerViewController()
            navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        case "Report":
            let vc = ReportViewController()
            navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            print("not match!")
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
