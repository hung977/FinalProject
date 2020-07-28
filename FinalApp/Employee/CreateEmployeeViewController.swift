//
//  CreateEmployeeViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class CreateEmployeeViewController: UIViewController {
    
    //MARK: - IbOutlet
    
    @IBOutlet weak var titleItems: UINavigationItem!
    @IBOutlet weak var employeeImage: UIImageView!
    @IBOutlet weak var fullNameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmTextfield: UITextField!
    @IBOutlet weak var isAdminSwitch: UISwitch!
    @IBOutlet weak var saveBtn: UIButton!
    
    // MARK: - Dictinary Response Error API
    var dirError: [Int:String] = [
        1001:"ACCOUNT_IS_LOCKED",
        1002:"CREATE_USER_FAILED",
        1003:"USERNAME_IS_TAKEN",
        1004:"EMAIL_IS_TAKEN",
        1005:"PHONE_NUMBER_IS_TAKEN",
        1006:"USERNAME_CONTAINS_SPACES",
        1007:"USER_IS_NOT_FOUND",
        1008:"DELETE_LAST_ADMIN_ACCOUNT",
        1009:"CHANGE_PASSWORD_FAILED",
        1010:"PASSWORD_TOO_SHORT",
        1011:"PASSWORD_REQUIRES_NON_ALPHANUMERIC",
        1012:"PASSWORD_REQUIRES_DIGIT",
        1013:"PASSWORD_REQUIRES_LOWER",
        1014:"PASSWORD_REQUIRES_UPPER",
        1015:"UPDATE_USER_FAILED",
        1016:"UPDATE_USER_ROLE_TO_EMPLOYEE",
        1017:"DELETE_CURRENT_USER"
        
    ]
    
        // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtn.layer.cornerRadius = 10
        saveBtn.backgroundColor = .systemBlue
        saveBtn.setTitleColor(.white, for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        phoneTextfield.keyboardType = UIKeyboardType.decimalPad
        userNameTextField.delegate = self
        fullNameTextfield.delegate = self
        emailTextfield.delegate  = self
        phoneTextfield.delegate = self
        passwordTextfield.delegate = self
        confirmTextfield.delegate = self
        
    }
    // MARK: - IBAction
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let name = fullNameTextfield.text!
        let email = emailTextfield.text!
        let phone = phoneTextfield.text!
        let username = userNameTextField.text!
        let pass = passwordTextfield.text!
        let confirmPass = confirmTextfield.text!
        var isAdmin = "employee"
        if isAdminSwitch.isOn {
            isAdmin = "admin"
        }
        
        let router = Router.createEmployee
        let param = [
            "name":"\(name)",
            "email":"\(email)",
            "phoneNumber":"\(phone)",
            "userName":"\(username)",
            "password":"\(pass)",
            "Role":"\(String(isAdmin))"
        ]
        if isValidEmailAddress(emailAddressString: email) {
            if checkNumber(str: phone) {
                if checkPassMatch(pass, confirmPass) {
                    RequestService.shared.AFRequestCreateEmployee(router: router, params: param) { (bool, data, error) in
                        if let safeData = data {
                            do {
                                let json = try JSONDecoder.init().decode(CreateEmployee.self, from: safeData)
                                if json.id == nil {
                                    for (key, value) in self.dirError {
                                        if (json.code == key) {
                                            self.alertResponse(tit: "Error", mess: value)
                                            break
                                        }
                                    }
                                } else {
                                    self.alertResponse(tit: "Susscess", mess: "employee id: \(json.id!)")
                                }
                                if json.code == nil {
                                    var mess = ""
                                    if let name = json.Name {
                                        mess += self.appendStr(array: name)
                                    }
                                    if let email = json.Email {
                                        mess += self.appendStr(array: email)
                                    }
                                    if let pass = json.Password {
                                        mess += self.appendStr(array: pass)
                                    }
                                    if let phone = json.PhoneNumber {
                                        mess += self.appendStr(array: phone)
                                    }
                                    if let username = json.UserName {
                                        mess += self.appendStr(array: username)
                                    }
                                    self.alertResponse(tit: "Error", mess: mess)
                                }
                            } catch {
                                self.alertResponse(tit: "Error: 404", mess: "Server not response")
                            }
                        } else {
                            self.alertResponse(tit: "Error: 404", mess: "Server not response")
                        }
                    }
                } else {
                    alertResponse(tit: "Error", mess: "Password & Confirm_Password not match.")
                }
            } else {
                alertResponse(tit: "Error", mess: "invalid Phone Number")
            }
        } else {
            alertResponse(tit: "Error", mess: "invalid Email Address")
        }
        
    }
    @IBAction func addNewImageBtnTapped(_ sender: UIButton) {
    }
    // MARK: - Supporting function
    func checkNumber(str: String) -> Bool {
        if str == "" {
            return true
        }
        let num = Int(str)
        if num != nil {return true} else {return false}
    }
    func checkPassMatch(_ pass: String, _ confirm: String) -> Bool {
        if pass == confirm { return true} else {return false}
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
    func appendStr(array: [String]) -> String {
        var str = ""
        for i in array {
            str += i
        }
        str += "\n"
        return str
    }
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        if emailAddressString == "" { return true }
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    func alertResponse(tit: String, mess: String) {
        let alert = UIAlertController(title: tit, message: mess, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    func hideKeyboard() {
        fullNameTextfield.endEditing(true)
        emailTextfield.endEditing(true)
        phoneTextfield.endEditing(true)
        passwordTextfield.endEditing(true)
        confirmTextfield.endEditing(true)
        userNameTextField.endEditing(true)
    }
    
}
// MARK: - UITextFieldDelegate
extension CreateEmployeeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    
}
