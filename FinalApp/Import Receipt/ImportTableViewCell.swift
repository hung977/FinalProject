//
//  ImportTableViewCell.swift
//  FinalApp
//
//  Created by TPS on 8/13/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class ImportTableViewCell: UITableViewCell {


    @IBOutlet weak var distributor: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var importReceipts: UILabel!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
