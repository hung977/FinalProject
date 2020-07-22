//
//  SaleCollectionViewCell.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class SaleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    var myColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.5)
    override func awakeFromNib() {
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = .darkGray
        addButton.setTitleColor(.white, for: .normal)
        super.awakeFromNib()
        // Initialization code
    }

}
