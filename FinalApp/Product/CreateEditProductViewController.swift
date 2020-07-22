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
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var productAmountTextfield: UITextField!
    @IBOutlet weak var titleItems: UINavigationItem!
    @IBOutlet weak var productPriceTextfield: UITextField!
    var tit = ""
    var productImageName: String?
    var productName: String?
    var productAmout: Int?
    var productPrice: Double?
    override func viewDidLoad() {
        saveButton.layer.cornerRadius = 10
        saveButton.backgroundColor = .blue
        saveButton.setTitleColor(.white, for: .normal)
        super.viewDidLoad()
        productImage.image = UIImage(named: productImageName ?? "hamburger" )
        titleItems.title = tit
        productNameTextfield.text = productName ?? ""
        productAmountTextfield.text = "\(productAmout ?? 0)"
        productPriceTextfield.text = "\(productPrice ?? 0)"
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
