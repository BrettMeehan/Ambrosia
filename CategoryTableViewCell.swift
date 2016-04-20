//
//  CategoryTableViewCell.swift
//  Ambrosia
//
//  Created by Brett Meehan on 4/3/16.
//  Copyright © 2016 Brett Meehan. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
