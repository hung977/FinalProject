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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .darkGray
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
        cell.labelViewCell?.textColor = .white
        cell.backgroundColor = .darkGray
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch items[indexPath.row].lable {
        case "Product management":
            let vc = ProductManagerViewController()
            navigationController?.pushViewController(vc, animated: true)
//            self.present(vc, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        case "Employee management":
            let vc = EmployeeManagementViewController()
            navigationController?.pushViewController(vc, animated: true)
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
