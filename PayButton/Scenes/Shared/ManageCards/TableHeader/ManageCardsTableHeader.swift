//
//  ManageCardsTableHeader.swift
//  PayButton
//
//  Created by PaySky105 on 19/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import UIKit

class ManageCardsTableHeader: UITableViewHeaderFooterView {
    @IBOutlet var setDefaultLbl: UILabel!
    @IBOutlet var cardDetailsLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setDefaultLbl.text = "set_default".localizedString()
        cardDetailsLbl.text = "card_details".localizedString()
    }
}
