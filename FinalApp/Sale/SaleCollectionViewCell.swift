//
//  SaleCollectionViewCell.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

protocol MyCellDelegate: AnyObject {
    func addButtonTapped(cell: SaleCollectionViewCell)
}
class SaleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    var myColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.5)
    
    weak var delegate: MyCellDelegate?
    
    override func awakeFromNib() {
        addButton.backgroundColor = .darkGray
        addButton.setTitleColor(.white, for: .normal)
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "image_default")
    }
    @IBAction func addButtonTapped(_ sender: UIButton) {
        delegate?.addButtonTapped(cell: self)
    }
    
}
