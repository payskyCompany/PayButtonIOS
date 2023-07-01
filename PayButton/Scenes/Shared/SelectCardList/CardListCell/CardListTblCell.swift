//
//  CardListTblCell.swift
//  PayButton
//
//  Created by PaySky105 on 19/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import UIKit
import DLRadioButton

class CardListTblCell: UITableViewCell {

    @IBOutlet weak var cardLogo: UIImageView!
    @IBOutlet weak var cardHolderNameLbl: UILabel!
    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var selectCardBtn: DLRadioButton!
    @IBOutlet weak var cvvAlertLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectCardBtn.setTitle("", for: .normal)
        showHideCvvAlertLbl(hide: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showHideCvvAlertLbl(hide: Bool) {
        cvvAlertLbl.isHidden = hide
    }
    
    func configure(_ cardDetails: CardDetails?) {
        cardHolderNameLbl.text = cardDetails?.displayName
        cardNumberLbl.text = cardDetails?.maskedCardNumber
        setCardLogo(withType: cardDetails?.brand ?? "")
        if cardDetails?.isDefaultCard == true {
            selectCardBtn.isSelected = true
        } else {
            selectCardBtn.isSelected = false
        }
    }
    
    func setCardLogo(withType type: String) {
        if type == "Visa".lowercased() {
            self.cardLogo.image = #imageLiteral(resourceName: "vi")
        } else if type == "Amex".lowercased() {
            self.cardLogo.image = #imageLiteral(resourceName: "am")
        } else if type == "MasterCard".lowercased() {
            self.cardLogo.image = #imageLiteral(resourceName: "mc")
        } else if type == "Maestro".lowercased() {
            self.cardLogo.image = #imageLiteral(resourceName: "Maestro")
        } else if type == "Diners Club".lowercased() {
            self.cardLogo.image = #imageLiteral(resourceName: "dc")
        } else if type == "JCB".lowercased() {
            self.cardLogo.image = #imageLiteral(resourceName: "jcb")
        } else if type == "Discover".lowercased() {
            self.cardLogo.image = #imageLiteral(resourceName: "ds")
        } else if type == "UnionPay".lowercased() {
            self.cardLogo.image = #imageLiteral(resourceName: "UnionPay")
        } else if type == "Mir".lowercased() {
            self.cardLogo.image = #imageLiteral(resourceName: "Mir")
        } else if type == "Meza".lowercased() {
            self.cardLogo.image =  #imageLiteral(resourceName: "miza_logo")
        } else {
            self.cardLogo.image = #imageLiteral(resourceName: "card_list_icon")
        }
    }
    
    
}
