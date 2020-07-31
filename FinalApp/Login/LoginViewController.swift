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
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var leadingContraintImg: NSLayoutConstraint!
    @IBOutlet weak var usernameLeading: NSLayoutConstraint!
    @IBOutlet weak var userTFLeading: NSLayoutConstraint!
    @IBOutlet weak var passwdLeading: NSLayoutConstraint!
    @IBOutlet weak var passTFLeading: NSLayoutConstraint!
    @IBOutlet weak var loginLeading: NSLayoutConstraint!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    //MARK: - Life cycel
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.text = "admin"
        passwordTextField.text = "Admin123!"
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        leadingContraintImg.constant -= view.bounds.height
        usernameLeading.constant -= view.bounds.width
        userTFLeading.constant += view.bounds.width
        passwdLeading.constant -= view.bounds.width
        passTFLeading.constant += view.bounds.width
        loginLeading.constant -= view.bounds.width
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: [],
                       animations: { [weak self] in
                        self?.leadingContraintImg.constant = 20
                        self?.usernameLeading.constant = 20
                        self?.userTFLeading.constant = 20
                        self?.passwdLeading.constant = 20
                        self?.passTFLeading.constant = 20
                        self?.loginLeading.constant = 20
                        self?.view.layoutIfNeeded()
          }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 1.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.imageview.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
            self.loginBtn.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
         }) { (finished) in
            UIView.animate(withDuration: 0.5, animations: {
              self.imageview.transform = CGAffineTransform.identity
              self.loginBtn.transform = CGAffineTransform.identity
           })
        }
    }
    //MARK: - IBAction
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        hideKeyboard()
        activityLoad(state: true)
        if let userTF = usernameTextField.text, let passTF = passwordTextField.text {
            let login: [String: String] = ["username":"\(userTF)", "password":"\(passTF)"]
            let routerLogin = Router.login
            RequestService.shared.AFRequestLogin(router: routerLogin, params: login, objectType: LoginResponse.self) { (bool, data, error) in
                self.activityLoad(state: false)
                
                do {
                    if error != nil {
                        self.alertFailtureLogin(str: "Request time out.")
                    } else {
                        let json = try JSONDecoder.init().decode(LoginResponse.self, from: data!)
                        LoginViewController.token = json.accessToken
                        if json.profile.role == "admin" {
                            LoginViewController.isAdmin = true
                        }
                        self.performSegue(withIdentifier: "loginToHome", sender: sender)
                    }
                } catch {
                    self.alertFailtureLogin(str: "username or password incorrect.")
                }
            }
        }
    }
    func setUI() {
        activity.style = .large
        activity.isHidden = true
        loginBtn.layer.cornerRadius = 10
        usernameTextField.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
    }
    func activityLoad(state: Bool) {
        if state {
            activity.isHidden = false
            activity.startAnimating()
            loginBtn.alpha = 0.5
            loginBtn.isEnabled = false
            usernameTextField.isEnabled = false
            passwordTextField.isEnabled = false
        } else {
            activity.isHidden = true
            activity.stopAnimating()
            loginBtn.alpha = 1
            loginBtn.isEnabled = true
            usernameTextField.isEnabled = true
            passwordTextField.isEnabled = true
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
// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
}
