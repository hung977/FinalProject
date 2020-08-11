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
    
    //MARK: - Contants
    //TextField animation
    private let timeWithDurationForTF = 1.0
    private let timeDelayForTF = 0.0
    private let constantForTF: CGFloat = 20
    //Logo & Button animation
    private let timeWithDurationForLogo = 0.5
    private let timeDelayForLogo = 1.0
    private let logoScaleValue: CGFloat = 1.5
    private let buttonScaleValue: CGFloat = 0.9
    //API
    private let userparam = "username"
    private let passwordparam = "password"
    private let adminRole = "admin"
    //Identifier
    private let loginToHome = "loginToHome"
    private let defaultUsername = "admin"
    private let defaultPassword = "Admin123!"
    //SetupUI
    private let loginBtnRadiusValue: CGFloat = 10
    private let loginBtnAlphaStartActivity: CGFloat = 0.5
    private let loginBtnAlphaStopActivity: CGFloat = 1.0
    private let textFieldRadiusValue: CGFloat = 15
    private enum MessageAlert: String {
        case requestTimeOut = "Request Time Out"
        case usernameOrPasswordIncorrect = "username or password incorrect."
    }
    private enum Title: String {
        case ok = "OK"
    }
    
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
        usernameTextField.text = defaultUsername
        passwordTextField.text = defaultPassword
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
        UIView.animate(withDuration: timeWithDurationForTF,
                       delay: timeDelayForTF,
                       options: [],
                       animations: { [weak self] in
                        guard let self = self else {return}
                        self.leadingContraintImg.constant = self.constantForTF
                        self.usernameLeading.constant = self.constantForTF
                        self.userTFLeading.constant = self.constantForTF
                        self.passwdLeading.constant = self.constantForTF
                        self.passTFLeading.constant = self.constantForTF
                        self.loginLeading.constant = self.constantForTF
                        self.view.layoutIfNeeded()
          }, completion: nil)
        UIView.animate(withDuration: timeWithDurationForLogo, delay: timeDelayForLogo, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.imageview.transform = CGAffineTransform.identity.scaledBy(x: self.logoScaleValue, y: self.logoScaleValue)
         }) { [weak self] (finished) in
            guard let self = self else {return}
            UIView.animate(withDuration: self.timeWithDurationForLogo, animations: {
              self.imageview.transform = CGAffineTransform.identity
           })
        }
    }
    //MARK: - IBAction
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.loginBtn.transform = CGAffineTransform.identity.scaledBy(x: self.buttonScaleValue, y: self.buttonScaleValue)
         }) { [weak self] (finished) in
            guard let self = self else {return}
            UIView.animate(withDuration: 0.2, animations: {
              self.loginBtn.transform = CGAffineTransform.identity
           })
        }
        hideKeyboard()
        activityLoad(state: true)
        if let userTF = usernameTextField.text, let passTF = passwordTextField.text {
            let login: [String: String] = [userparam:userTF, passwordparam:passTF]
            let routerLogin = Router.login
            RequestService.shared.AFRequestLogin(router: routerLogin, params: login, objectType: LoginResponse.self) { [weak self] (bool, data, error) in
                guard let self = self else { return }
                self.activityLoad(state: false)
                
                do {
                    if error != nil {
                        self.alertFailtureLogin(str: MessageAlert.requestTimeOut.rawValue)
                    } else {
                        let json = try JSONDecoder.init().decode(LoginResponse.self, from: data!)
                        LoginViewController.token = json.accessToken
                        if json.profile.role == self.adminRole {
                            LoginViewController.isAdmin = true
                        }
                        self.performSegue(withIdentifier: self.loginToHome, sender: sender)
                    }
                } catch {
                    self.alertFailtureLogin(str: MessageAlert.usernameOrPasswordIncorrect.rawValue)
                }
            }
        }
    }
    
    //MARK: - Supporting function
    func setUI() {
        activity.style = .large
        activity.isHidden = true
        loginBtn.layer.cornerRadius = loginBtnRadiusValue
        usernameTextField.layer.cornerRadius = textFieldRadiusValue
        passwordTextField.layer.cornerRadius = textFieldRadiusValue
    }
    func activityLoad(state: Bool) {
        if state {
            activity.isHidden = false
            activity.startAnimating()
            loginBtn.alpha = loginBtnAlphaStartActivity
            loginBtn.isEnabled = false
            usernameTextField.isEnabled = false
            passwordTextField.isEnabled = false
        } else {
            activity.isHidden = true
            activity.stopAnimating()
            loginBtn.alpha = loginBtnAlphaStopActivity
            loginBtn.isEnabled = true
            usernameTextField.isEnabled = true
            passwordTextField.isEnabled = true
        }
    }
    func alertFailtureLogin(str message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Title.ok.rawValue, style: .default) { [weak self] (_) in
            guard let self = self else {return}
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
        if segue.identifier == loginToHome {
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
