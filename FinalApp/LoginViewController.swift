//
//  LoginViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var isAdmin = false

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //test
        usernameTextField.text = "hungphan"
        passwordTextField.text = "123123"
        
        
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        loginBtn.layer.cornerRadius = 10
        usernameTextField.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        hideKeyboard()
        if let userTF = usernameTextField.text, let passTF = passwordTextField.text {
            if userTF == "hungphan" && passTF == "123123" {
                performSegue(withIdentifier: "loginToHome", sender: sender)
            } else {
                alertFailtureLogin(str: "username or password incorrect.")
            }
        } else {
            alertFailtureLogin(str: "username and password can't be nil")
        }
    
    }
    func alertFailtureLogin(str message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            self.hideKeyboard()
            //do some thing
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func hideKeyboard() {
        usernameTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginToHome" {
            let vc = segue.destination
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
}
