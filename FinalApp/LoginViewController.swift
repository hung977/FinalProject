//
//  LoginViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    static var token = ""
    static var isAdmin = false
    
    //MARK: - IBoutlet
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - Life cycel
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.text = "admin"
        passwordTextField.text = "Admin123!"
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        setUI()
    }
    //MARK: - IBAction
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        hideKeyboard()
        if let userTF = usernameTextField.text, let passTF = passwordTextField.text {
            let login: [String: String] = ["username":"\(userTF)", "password":"\(passTF)"]
            let routerLogin = Router.login
            RequestService.shared.AFRequestWithRawData(router: routerLogin, parameters: login, objectType: LoginResponse.self) { (bool, data, error) in
                do {
                    let json = try JSONDecoder.init().decode(LoginResponse.self, from: data!)
                    LoginViewController.token = json.accessToken
                    if json.profile.role == "admin" {
                        LoginViewController.isAdmin = true
                    }
                    self.performSegue(withIdentifier: "loginToHome", sender: sender)
                } catch {
                    self.alertFailtureLogin(str: "username or password incorrect.")
                }
            }
        }
    }
    func setUI() {
        loginBtn.layer.cornerRadius = 10
        usernameTextField.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
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
// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
}
