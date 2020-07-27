//
//  CreateEmployeeViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class CreateEmployeeViewController: UIViewController {

    @IBOutlet weak var titleItems: UINavigationItem!
    @IBOutlet weak var employeeImage: UIImageView!
    @IBOutlet weak var fullNameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        phoneTextfield.keyboardType = UIKeyboardType.decimalPad
        fullNameTextfield.delegate = self
        emailTextfield.delegate  = self
        phoneTextfield.delegate = self
        passwordTextfield.delegate = self
        confirmTextfield.delegate = self
        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    func hideKeyboard() {
        fullNameTextfield.endEditing(true)
        emailTextfield.endEditing(true)
        phoneTextfield.endEditing(true)
        passwordTextfield.endEditing(true)
        confirmTextfield.endEditing(true)
    }
    func checkNil(array: [String]) -> Bool {
        for i in array {
            if i == "" {
                return false
            }
        }
        return true
    }
    func checkPass(pass: String, confirm: String) -> Bool {
        if pass == confirm {
            return true
        } else {
            return false
        }
    }
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let name = fullNameTextfield.text!
        let email = emailTextfield.text!
        let phone = phoneTextfield.text!
        let pass = passwordTextfield.text!
        let confirmPass = confirmTextfield.text!
        
        if checkNil(array: [name, email, phone, pass, confirmPass]) {
            if checkPass(pass: pass, confirm: confirmPass) {
                print("Field Success!!")
            } else {
                print("password and confirm password not match!")
            }
            
        } else {
            print("missing field!")
        }
    }
    @IBAction func addNewImageBtnTapped(_ sender: UIButton) {
    }
    
}

// MARK: - UITextFieldDelegate
extension CreateEmployeeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }

    
}
