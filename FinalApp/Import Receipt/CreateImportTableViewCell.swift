//
//  CreateImportTableViewCell.swift
//  FinalApp
//
//  Created by TPS on 8/17/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

protocol MyImportCellDelegate: AnyObject {
    func deleteBtntapped(cell: CreateImportTableViewCell)
    func amountTFDidChanged(cell: CreateImportTableViewCell, textfield: UITextField)
    func priceTFDidChanged(cell: CreateImportTableViewCell, textfield: UITextField)
}

class CreateImportTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    weak var delegate: MyImportCellDelegate?
    override func awakeFromNib() {
        
        super.awakeFromNib()
        amountTextField.delegate = self
        priceTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func deleteBtnTapped(_ sender: UIButton) {
        delegate?.deleteBtntapped(cell: self)
    }
    @IBAction func amountDidChanged(_ sender: UITextField) {
        delegate?.amountTFDidChanged(cell: self, textfield: amountTextField)
    }
    @IBAction func priceDidChanged(_ sender: UITextField) {
        delegate?.priceTFDidChanged(cell: self, textfield: priceTextField)
    }
    
}
extension CreateImportTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextField.endEditing(true)
        priceTextField.endEditing(true)
        if amountTextField.text?.count == 0 {
            amountTextField.text = "1"
        }
        if priceTextField.text?.count == 0 {
            priceTextField.text = "1"
        }
        return true
    }
    
}
