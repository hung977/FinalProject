//
//  BadgeTableViewCell.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class BadgeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var amoutLabel: UILabel!
    @IBOutlet weak var amoutTextField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
    }
    
}
