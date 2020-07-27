//
//  EditEmployeeViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class EditEmployeeViewController: UIViewController {

    @IBOutlet weak var employeeImage: UIButton!
    @IBOutlet weak var fullNameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var phoneTextfield: UITextField!
    
    var name: String?
    var email: String?
    var phoneNumber: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        

        // Do any additional setup after loading the view.
    }
    func updateUI() {
        fullNameTextfield.text = name
        emailTextfield.text = email
        phoneTextfield.text = phoneNumber
    }
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
    }
    

}
