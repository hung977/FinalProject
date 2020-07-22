//
//  EmployeeTableViewCell.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    @IBOutlet weak var employeeImage: UIImageView!
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var employeeEmail: UILabel!
    @IBOutlet weak var employeePhone: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}