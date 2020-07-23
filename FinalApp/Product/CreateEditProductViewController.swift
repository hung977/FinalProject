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
    
    //var vcCamera: UIImagePickerController?
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameTextfield: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var productAmountTextfield: UITextField!
    @IBOutlet weak var titleItems: UINavigationItem!
    @IBOutlet weak var productPriceTextfield: UITextField!
    var currentImage: UIImage?
    var tit = ""
    var productImageName: String?
    var productName: String?
    var productAmout: Int?
    var productPrice: Int?
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        saveButton.layer.cornerRadius = 10
        saveButton.backgroundColor = .blue
        
        saveButton.setTitleColor(.white, for: .normal)
        super.viewDidLoad()
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
        }
        
        
        titleItems.title = tit
        productNameTextfield.text = productName ?? ""
        productAmountTextfield.text = "\(productAmout ?? 0)"
        productPriceTextfield.text = "\(productPrice ?? 0)"
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
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let routerNewProduct = Router.newProducts
//        let currentName = productNameTextfield.text ?? "Default Name"
//        let currentAmout = Int(productAmountTextfield.text!) ?? 0
//        let currentPrice = Double(productPriceTextfield.text!) ?? 0.0
        let params: [String:String] = ["Name": "DEFAULT NAME", "Price": "12", "Amount": "5"]
        RequestService.shared.uploadProductImage(router: routerNewProduct, currentImage!, params: params)
    }
    @IBAction func selectImageTapped(_ sender: UIButton) {
        var vcCamera =  UIImagePickerController()
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController(title: nil, message: "Device has no camera.", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Alright", style: .default, handler: { (alert: UIAlertAction!) in
            })

            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            vcCamera = UIImagePickerController()
            let options = UIAlertController(title: nil, message: "Select options", preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
                vcCamera.sourceType = .camera
                vcCamera.delegate = self
                self.present(vcCamera, animated: true, completion: nil)
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
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }

        // print out the image size as a test
        productImage.image = image
        currentImage = image
    }
}
extension CreateEditProductViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
}
