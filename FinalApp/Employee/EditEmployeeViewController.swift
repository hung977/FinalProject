//
//  EditEmployeeViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class EditEmployeeViewController: UIViewController {

    
    // MARK: -IBOutlet
    @IBOutlet weak var employeeImage: UIButton!
    @IBOutlet weak var fullNameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var isAdminSwitch: UISwitch!
    @IBOutlet weak var phoneTextfield: UITextField!
    
    var name: String?
    var email: String?
    var phoneNumber: String?
    var isAdmin: Bool?
    var id: String?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        fullNameTextfield.delegate = self
        emailTextfield.delegate = self
        phoneTextfield.delegate = self
        phoneTextfield.keyboardType = UIKeyboardType.decimalPad
    }
    
    //MARK: - Supporting function
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
    func checkNumber(str: String) -> Bool {
        if str == "" {
            return true
        }
        let num = Int(str)
        if num != nil {return true} else {return false}
    }
    func updateUI() {
        saveBtn.layer.cornerRadius = 10
        saveBtn.backgroundColor = .systemBlue
        saveBtn.setTitleColor(.white, for: .normal)
        fullNameTextfield.text = name
        emailTextfield.text = email
        phoneTextfield.text = phoneNumber
        if isAdmin! {
            isAdminSwitch.isOn = true
        } else {
            isAdminSwitch.isOn = false
        }
    }
    func hideKeyboard() {
        fullNameTextfield.endEditing(true)
        emailTextfield.endEditing(true)
        phoneTextfield.endEditing(true)
    }
    func alertResponse(tit: String, mess: String) {
           let alert = UIAlertController(title: tit, message: mess, preferredStyle: .alert)
           let action = UIAlertAction(title: "OK", style: .default, handler: nil)
           alert.addAction(action)
           present(alert, animated: true)
       }
    func alertCompletion(mess: String) {
        let alert = UIAlertController(title: "Success", message: mess, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            let vc = EmployeeManagementViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: - IBAction
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let name = fullNameTextfield.text!
        let email = emailTextfield.text!
        let phone = phoneTextfield.text!
        var isAd = "employee"
        if isAdmin! {isAd = "admin"}
        let param = [
            "name":"\(name)",
            "email":"\(email)",
            "phoneNumber":"\(phone)",
            "Role":"\(isAd)"
        ]
        if isValidEmailAddress(emailAddressString: email) {
            if checkNumber(str: phone) {
                let router = Router.editEmployee
                RequestService.shared.AFRequestEditEmployee(router: router, id: id!, params: param) { (response, error) in
                    if let respon = response {
                        if let statusCode = respon.response?.statusCode {
                            if statusCode == 204 || statusCode == 200 {
                                self.alertCompletion(mess: "Update employee success.")
                            } else if statusCode == 403 {
                                self.alertResponse(tit: "Error", mess: "Forbidden")
                            } else {
                                self.alertResponse(tit: "Error", mess: "ERROR REQUEST TO SERVER")
                            }
                        }
                    } else {
                        if let err = error {
                            print(err)
                        }
                    }
                }
                
                
                
            } else {
                alertResponse(tit: "Error", mess: "invalid Phone Number")
            }
            
        } else {
            alertResponse(tit: "Error", mess: "invalid Email")
        }
    }
    @IBAction func isAdminSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            isAdmin = true
        } else {
            isAdmin = false
        }
    }
    

}

//MARK: Extention UITextFieldDelegate

extension EditEmployeeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
}
