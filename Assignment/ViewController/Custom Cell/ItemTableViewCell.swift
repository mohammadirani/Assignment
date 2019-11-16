//
//  ItemTableViewCell.swift
//  assignment
//
//  Created by Sachin on 16/11/19.
//  Copyright © 2019 Sachin. All rights reserved.
//

import UIKit
import SDWebImage

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var personImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
