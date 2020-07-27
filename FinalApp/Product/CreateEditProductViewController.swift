//
//  CreateEditProductViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit
import Alamofire

class CreateEditProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currentImage: UIImage?
    var tit = ""
    var productImageName: String?
    var productName: String?
    var productAmout: Int?
    var productPrice: Double?
    var productId: String?
    var isSelectedImage = true
    
    // MARK: - IBOutlet
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameTextfield: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var productAmountTextfield: UITextField!
    @IBOutlet weak var titleItems: UINavigationItem!
    @IBOutlet weak var productPriceTextfield: UITextField!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        saveButton.layer.cornerRadius = 10
        saveButton.backgroundColor = .blue
        productAmountTextfield.keyboardType = UIKeyboardType.decimalPad
        productPriceTextfield.keyboardType = UIKeyboardType.decimalPad
        saveButton.setTitleColor(.white, for: .normal)
        productNameTextfield.delegate = self
        productAmountTextfield.delegate = self
        productPriceTextfield.delegate = self
        if productImageName != nil {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: URL(string: self.productImageName!)!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.productImage.image = image
                            self.currentImage = image
                            
                        }
                    }
                }
            }
        }
        else {
            productImage.image = UIImage(named: "product_example")
            currentImage = UIImage(named: "product_example")
            isSelectedImage = false
        }
        
        
        titleItems.title = tit
        productNameTextfield.text = productName
        productAmountTextfield.text = "\(productAmout ?? 0)"
        productPriceTextfield.text = "\(productPrice ?? 0.0)"
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
        productNameTextfield.endEditing(true)
        productAmountTextfield.endEditing(true)
        productPriceTextfield.endEditing(true)
    }
    
    // MARK: - IBAction
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if tit == "Add new product" {
            let currentName = productNameTextfield.text!
            let currentAmout = String(productAmountTextfield.text!)
            let currentPrice = String(productPriceTextfield.text!)
            if (notNil(name: currentName, amount: currentAmout, price: currentPrice, isImage: isSelectedImage)) {
                let params: [String:Any] = ["Name": currentName, "Price": currentPrice, "Amount": currentAmout]
                //print(params)
                RequestService.callsendImageAPI(param: params, arrImage: [currentImage!], imageKey: "Image") { (response) in
                }
                let vc = ProductManagerViewController()
                navigationController?.pushViewController(viewController: vc, animated: true, completion: vc.viewDidLoad)
            } else {
                var message = ""
                if currentName == "" {
                    message += "Product_Name "
                }
                if currentAmout == "" {
                    message += "Product_Amount "
                }
                if currentPrice == "" {
                    message += "Product_Price "
                }
                if !isSelectedImage {
                    message += "Product_Image "
                }
                let alert = UIAlertController(title: "Missing field", message: "\(message) is required.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated:true)
            }
        } else {
            let currentName = productNameTextfield.text ?? "Default Name"
            let currentAmout = String(productAmountTextfield.text!)
            let currentPrice = String(productPriceTextfield.text!)
            if (notNil(name: currentName, amount: currentAmout, price: currentPrice, isImage: isSelectedImage)) {
                let params: [String:Any] = ["Name": currentName, "Price": currentPrice, "Amount": currentAmout]
                RequestService.callsendImageAPIEditProduct(for: productId!, param: params, arrImage: [currentImage!], imageKey: "Image") { (response) in
                    //code here
                }
                let vc = ProductManagerViewController()
                navigationController?.pushViewController(viewController: vc, animated: true, completion: vc.viewDidLoad)
            }
        }
    }
    func notNil(name: String, amount: String, price: String, isImage: Bool) -> Bool {
        if (name == "" || amount == "" || price == "" || isImage == false ) {
            return false
        } else {
            return true
        }
    }
    @IBAction func selectImageTapped(_ sender: UIButton) {
        var vcCamera =  UIImagePickerController()
        vcCamera = UIImagePickerController()
        let options = UIAlertController(title: nil, message: "Select options", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                let alert = UIAlertController(title: nil, message: "Device has no camera", preferredStyle: .alert)
                let action = UIAlertAction(title: "Alright", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true)
            } else {
                vcCamera.sourceType = .camera
                vcCamera.delegate = self
                self.present(vcCamera, animated: true, completion: nil)
            }
        }
        let photoLibrary = UIAlertAction(title: "Photos Library", style: .default) { (_) in
            vcCamera.sourceType = .photoLibrary
            vcCamera.delegate = self
            self.present(vcCamera, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        options.addAction(camera)
        options.addAction(photoLibrary)
        options.addAction(cancel)
        present(options, animated: true)
        
    }
    
    // MARK: - UIImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        productImage.image = image
        currentImage = image
        isSelectedImage = true
    }
}

// MARK: - UITextFieldDelegate
extension CreateEditProductViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
}

// MARK: - UINavigationController
extension UINavigationController {
    public func pushViewController(viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}
