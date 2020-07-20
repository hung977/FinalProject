//
//  CreateEditProductViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class CreateEditProductViewController: UIViewController {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameTextfield: UITextField!
    @IBOutlet weak var productAmountTextfield: UITextField!
    @IBOutlet weak var titleItems: UINavigationItem!
    @IBOutlet weak var productPriceTextfield: UITextField!
    var tit = ""
    var productName = ""
    var productAmout = ""
    var productPrice = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        titleItems.title = tit
        productNameTextfield.text = productName
        productAmountTextfield.text = productAmout
        productPriceTextfield.text = productPrice
    }
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
    }
    @IBAction func selectImageTapped(_ sender: UIButton) {
        print("Select image button tapped!!!")
    }
    

   

}
