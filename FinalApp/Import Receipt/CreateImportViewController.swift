//
//  CreateImportViewController.swift
//  FinalApp
//
//  Created by TPS on 8/13/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class CreateImportViewController: UIViewController {

    @IBOutlet weak var createbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        createbtn.layer.cornerRadius = 10
        createbtn.backgroundColor = .systemBlue
        createbtn.setTitleColor(.white, for: .normalt)
        
    }
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func chooseDistributorTapped(_ sender: UIButton) {
    }
    @IBAction func addProductTapped(_ sender: UIButton) {
    }
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
    }
    @IBAction func createBtnTapped(_ sender: UIButton) {
    }
    
    

}

