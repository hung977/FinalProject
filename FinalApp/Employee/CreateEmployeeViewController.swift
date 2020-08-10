//
//  CreateEmployeeViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class CreateEmployeeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var isPasswordHide = true
    var isConfirmPassHide = true
    
    //MARK: - Contants
    private var layercornerRadiusVL: CGFloat = 10
    private var hidePassImage = "hidepass"
    private var showPassImage = "showpass"
    private var employeeRole = "employee"
    private var adminRole = "admin"
    private var nameParam = "name"
    private var emailParam = "email"
    private var phoneParam = "phoneNumber"
    private var usernameParam = "userName"
    private var passwordParam = "password"
    private var roleParam = "Role"
    private var imageKey = "Image"
    private var defaultStr = ""
    private var enterStr = "\n"
    private var emailFormart = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    
    private enum Title: String {
        case missingField = "Missing Field!"
        case ok = "OK"
        case camera = "Camera"
        case alright = "Alright"
        case photoLibrary = "Photos Library"
        case cancel = "Cancel"
        case error = "Error"
        case success = "Success"
    }
    private enum MessageAlert: String {
        case selectOptions = "Select options"
        case deviceNoCamera = "Device has no camera"
        case severFailture = "Server not response"
        case passwordNotMatch = "Password & Confirm_Password not match."
        case invaldPhone = "invalid Phone Number"
        case invaldEmail = "invalid Email Address"
    }
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
    @IBOutlet weak var passwordHideorShowBtn: UIButton!
    @IBOutlet weak var confirmPassHideorShowBtn: UIButton!
    
    
        // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        employeeImage.layer.cornerRadius = employeeImage.frame.size.height / 2
        
        saveBtn.layer.cornerRadius = layercornerRadiusVL
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
    @IBAction func passwordHideorShow(_ sender: UIButton) {
        isPasswordHide = !isPasswordHide
        passwordHideorShowBtn.setImage(isPasswordHide ? UIImage(named: hidePassImage) : UIImage(named: showPassImage), for: .normal)
        passwordTextfield.isSecureTextEntry = isPasswordHide ? true : false
    }
    @IBAction func confirmPassHideorShow(_ sender: UIButton) {
        isConfirmPassHide = !isConfirmPassHide
        confirmPassHideorShowBtn.setImage(isConfirmPassHide ? UIImage(named: hidePassImage) : UIImage(named: showPassImage), for: .normal)
        confirmTextfield.isSecureTextEntry = isConfirmPassHide ? true : false
    }
    @IBAction func selectImage(_ sender: UIButton) {
        var vcCamera =  UIImagePickerController()
        vcCamera = UIImagePickerController()
        let options = UIAlertController(title: nil, message: MessageAlert.selectOptions.rawValue, preferredStyle: .actionSheet)
        if let popoverController = options.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        let camera = UIAlertAction(title: Title.camera.rawValue, style: .default) { [weak self] (_) in
            guard let self = self else {return}
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                let alert = UIAlertController(title: nil, message: MessageAlert.deviceNoCamera.rawValue, preferredStyle: .alert)
                let action = UIAlertAction(title: Title.alright.rawValue, style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true)
            } else {
                vcCamera.sourceType = .camera
                vcCamera.delegate = self
                self.present(vcCamera, animated: true, completion: nil)
            }
        }
        let photoLibrary = UIAlertAction(title: Title.photoLibrary.rawValue, style: .default) { [weak self] (_) in
            guard let self = self else {return}
            vcCamera.sourceType = .photoLibrary
            vcCamera.delegate = self
            self.present(vcCamera, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: Title.cancel.rawValue, style: .cancel, handler: nil)
        options.addAction(camera)
        options.addAction(photoLibrary)
        options.addAction(cancel)
        present(options, animated: true)
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let name = fullNameTextfield.text!
        let email = emailTextfield.text!
        let phone = phoneTextfield.text!
        let username = userNameTextField.text!
        let pass = passwordTextfield.text!
        let confirmPass = confirmTextfield.text!
        var isAdmin = employeeRole
        if isAdminSwitch.isOn {
            isAdmin = adminRole
        }
        let currentImage = employeeImage.image
        
        let param = [
            nameParam : name,
            emailParam : email,
            phoneParam : phone,
            usernameParam : username,
            passwordParam : pass,
            roleParam : isAdmin
        ]
        if isValidEmailAddress(emailAddressString: email) {
            if checkNumber(str: phone) {
                if checkPassMatch(pass, confirmPass) {
                    RequestService.callsendImageAPICreateEmployee(param: param, arrImage: [currentImage!], imageKey: imageKey) { [weak self] (bool, data, error) in
                        guard let self = self else {return}
                        if let safeData = data {
                            do {
                                let json = try JSONDecoder.init().decode(CreateEmployee.self, from: safeData)
                                if json.id == nil {
                                    for (key, value) in self.dirError {
                                        if (json.code == key) {
                                            self.alertResponse(tit: Title.error.rawValue, mess: value)
                                            break
                                        }
                                    }
                                } else {
                                    self.alertCompletion(mess: "employee id: \(json.id!)")
                                }
                                if json.code == nil {
                                    var mess = self.defaultStr
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
                                    self.alertResponse(tit: Title.error.rawValue, mess: mess)
                                }
                            } catch {
                                self.alertResponse(tit: Title.error.rawValue, mess: MessageAlert.severFailture.rawValue)
                            }
                        } else {
                            self.alertResponse(tit: Title.error.rawValue, mess: MessageAlert.severFailture.rawValue)
                        }
                    }
                } else {
                    alertResponse(tit: Title.error.rawValue, mess: MessageAlert.passwordNotMatch.rawValue)
                }
            } else {
                alertResponse(tit: Title.error.rawValue, mess: MessageAlert.invaldPhone.rawValue)
            }
        } else {
            alertResponse(tit: Title.error.rawValue, mess: MessageAlert.invaldEmail.rawValue)
        }
        
    }
    // MARK: - Supporting function
    func alertCompletion(mess: String) {
        let alert = UIAlertController(title: Title.success.rawValue, message: mess, preferredStyle: .alert)
        let action = UIAlertAction(title: Title.ok.rawValue, style: .default) { [weak self] (_) in
            guard let self = self else {return}
            let vc = EmployeeManagementViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    func checkNumber(str: String) -> Bool {
        if str == defaultStr {
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
        var str = defaultStr
        for i in array {
            str += i
        }
        str += enterStr
        return str
    }
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        if emailAddressString == defaultStr { return true }
        
        var returnValue = true
        let emailRegEx = emailFormart
        
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
        let action = UIAlertAction(title: Title.ok.rawValue, style: .default, handler: nil)
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
    // MARK: - UIImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        employeeImage.image = image
        
    }
    
}
// MARK: - UITextFieldDelegate
extension CreateEmployeeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    
}
