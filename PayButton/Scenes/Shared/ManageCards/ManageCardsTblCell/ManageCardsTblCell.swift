//
//  ManageCardsTblCell.swift
//  PayButton
//
//  Created by PaySky105 on 20/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import UIKit
import DLRadioButton

class ManageCardsTblCell: UITableViewCell {

    @IBOutlet weak var selectCardBtn: DLRadioButton!
    @IBOutlet weak var deleteCardBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectCardBtn.setTitle("", for: .normal)
        deleteCardBtn.setTitle("", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
