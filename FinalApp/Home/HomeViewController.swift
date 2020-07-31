//
//  ViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = ProductManagerViewController()
        navigationController?.pushViewController(vc, animated: true)
        
        
    }

}

