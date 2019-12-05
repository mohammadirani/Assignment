//
//  ChatsTableViewCell.swift
//  KeywoImage
//
//  Created by IOS Developer6 on 27/03/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit

class ChatsTableViewCell: UITableViewCell {

    @IBOutlet weak var userMessageTimeLabelOutlet: UILabel!
    @IBOutlet weak var userMessageLabelOutlet: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabelOutlet: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
