//
//  BadgeTableViewCell.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

protocol MyBadgeCellDelegate: AnyObject {
    func deleteButtonTapped(cell: BadgeTableViewCell)
    func amountTextFieldDidChanged(cell: BadgeTableViewCell, textField: UITextField)
    
}
class BadgeTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var amoutLabel: UILabel!
    @IBOutlet weak var amoutTextField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    weak var delegate: MyBadgeCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        amoutTextField.delegate = self
        amoutTextField.keyboardType = UIKeyboardType.decimalPad
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewItem.image = UIImage(named: "image_default")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        delegate?.deleteButtonTapped(cell: self)
    }
    @IBAction func amountTextFieldDidChanged(_ sender: UITextField) {
        delegate?.amountTextFieldDidChanged(cell: self, textField: sender)
    }
    
}
extension BadgeTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amoutTextField.endEditing(true)
        if amoutTextField.text?.count == 0 {
            amoutTextField.text = "0"
        }
        return true
    }
    
}
