//
//  SenderChatTableViewCell.swift
//  BitPlay
//
//  Created by Admin on 31/10/17.
//  Copyright © 2017 Postgram. All rights reserved.
//

import UIKit

class SenderChatTableViewCell: UITableViewCell {

    @IBOutlet weak var dateViewHeightOutlet: NSLayoutConstraint!
    @IBOutlet weak var topDateLabelOutlet: UILabel!
    
    @IBOutlet weak var chatLabelData: UILabel!
    @IBOutlet weak var labelChatDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
