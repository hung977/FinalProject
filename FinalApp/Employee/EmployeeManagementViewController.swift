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
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        menu?.menuWidth = 300
        SideMenuManager.default.leftMenuNavigationController = menu
    }
    @IBAction func didTappedMenu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    


}
