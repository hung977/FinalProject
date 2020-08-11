//
//  DistributorTableViewCell.swift
//  FinalApp
//
//  Created by TPS on 8/11/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit
protocol MyDistributorCellDelegate: AnyObject {
    func editButtonTapped(cell: DistributorTableViewCell)
}
class DistributorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    static var name = "DistributorTableViewCell"
    weak var delegate: MyDistributorCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func editBtnTapped(_ sender: UIButton) {
        delegate?.editButtonTapped(cell: self)
    }
    
}
