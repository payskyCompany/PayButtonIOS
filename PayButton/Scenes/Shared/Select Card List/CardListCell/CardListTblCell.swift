//
//  CardListTblCell.swift
//  PayButton
//
//  Created by PaySky105 on 19/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import UIKit

class CardListTblCell: UITableViewCell {

    @IBOutlet weak var cvvAlertLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cvvAlertLbl.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
