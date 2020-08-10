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
    
    //MARK: - Contants
    private let saveButtonRadiusValue: CGFloat = 10
    private let imageNameDefault = "product_example"
    private let titleAdd = "Add new product"
    private let nameParam = "Name"
    private let priceParam = "Price"
    private let amountParam = "Amount"
    private let imageParam = "Image"
    private let missName = "Product_Name "
    private let missAmount = "Product_Amount "
    private let missPrice = "Product_Price "
    private let missImage = "Product_Image "
    private let amountDefault = 0
    private let priceDefault = 0.0
    private let nameDefault = "Default Name"
    private enum Title: String {
        case missingField = "Missing Field!"
        case ok = "OK"
        case camera = "Camera"
        case alright = "Alright"
        case photoLibrary = "Photos Library"
        case cancel = "Cancel"
    }
    private enum MessageAlert: String {
        case selectOptions = "Select options"
        case deviceNoCamera = "Device has no camera"
    }
    
    
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
        saveButton.layer.cornerRadius = saveButtonRadiusValue
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
            productImage.image = UIImage(named: imageNameDefault)
            currentImage = UIImage(named: imageNameDefault)
            isSelectedImage = false
        }
        
        
        titleItems.title = tit
        productNameTextfield.text = productName ?? nameDefault
        productAmountTextfield.text = "\(productAmout ?? amountDefault)"
        productPriceTextfield.text = "\(productPrice ?? priceDefault)"
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
        if tit == titleAdd {
            let currentName = productNameTextfield.text!
            let currentAmout = String(productAmountTextfield.text!)
            let currentPrice = String(productPriceTextfield.text!)
            if (notNil(name: currentName, amount: currentAmout, price: currentPrice, isImage: isSelectedImage)) {
                let params: [String:Any] = [nameParam: currentName, priceParam: currentPrice, amountParam: currentAmout]
                RequestService.callsendImageAPI(param: params, arrImage: [currentImage!], imageKey: imageParam) { (response) in
                }
                NotificationCenter.default.post(name: .didCreateProduct, object: nil)
                let vc = ProductManagerViewController()
                navigationController?.pushViewController(vc, animated: true)
            } else {
                var message = ""
                if currentName == "" {
                    message += missName
                }
                if currentAmout == "" {
                    message += missAmount
                }
                if currentPrice == "" {
                    message += missPrice
                }
                if !isSelectedImage {
                    message += missImage
                }
                let alert = UIAlertController(title: Title.missingField.rawValue, message: "\(message) is required.", preferredStyle: .alert)
                let action = UIAlertAction(title: Title.ok.rawValue, style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated:true)
            }
        } else {
            let currentName = productNameTextfield.text ?? nameDefault
            let currentAmout = String(productAmountTextfield.text!)
            let currentPrice = String(productPriceTextfield.text!)
            if (notNil(name: currentName, amount: currentAmout, price: currentPrice, isImage: isSelectedImage)) {
                let params: [String:Any] = [nameParam: currentName, priceParam: currentPrice, amountParam: currentAmout]
                RequestService.callsendImageAPIEditProduct(for: productId!, param: params, arrImage: [currentImage!], imageKey: imageParam) { (response) in
                }
                NotificationCenter.default.post(name: .didUpdateProduct, object: nil)
                let vc = ProductManagerViewController()
                navigationController?.pushViewController(vc, animated: true)
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

