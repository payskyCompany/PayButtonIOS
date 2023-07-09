//
//  ManageCardsTblCell.swift
//  PayButton
//
//  Created by PaySky105 on 20/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import DLRadioButton
import UIKit

class ManageCardsTblCell: UITableViewCell {
    @IBOutlet var cardLogo: UIImageView!
    @IBOutlet var cardHolderNameLbl: UILabel!
    @IBOutlet var cardNumberLbl: UILabel!
    @IBOutlet var selectCardRadioBtn: DLRadioButton!
    @IBOutlet var deleteCardBtn: UIButton!

    weak var delegate: ManageCardView?

    override func awakeFromNib() {
        super.awakeFromNib()

        selectCardRadioBtn.setTitle("", for: .normal)
        deleteCardBtn.setTitle("", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(_ cardDetails: CardDetails?) {
        cardHolderNameLbl.text = cardDetails?.displayName
        cardNumberLbl.text = cardDetails?.maskedCardNumber
        setCardLogo(withType: cardDetails?.brand ?? "")
        if cardDetails?.isDefaultCard == true {
            selectCardRadioBtn.isSelected = true
        } else {
            selectCardRadioBtn.isSelected = false
        }
    }

    func setCardLogo(withType type: String) {
        if type == "Visa".lowercased() {
            cardLogo.image = #imageLiteral(resourceName: "vi")
        } else if type == "Amex".lowercased() {
            cardLogo.image = #imageLiteral(resourceName: "am")
        } else if type == "MasterCard".lowercased() {
            cardLogo.image = #imageLiteral(resourceName: "mc")
        } else if type == "Maestro".lowercased() {
            cardLogo.image = #imageLiteral(resourceName: "Maestro")
        } else if type == "Diners Club".lowercased() {
            cardLogo.image = #imageLiteral(resourceName: "dc")
        } else if type == "JCB".lowercased() {
            cardLogo.image = #imageLiteral(resourceName: "jcb")
        } else if type == "Discover".lowercased() {
            cardLogo.image = #imageLiteral(resourceName: "ds")
        } else if type == "UnionPay".lowercased() {
            cardLogo.image = #imageLiteral(resourceName: "UnionPay")
        } else if type == "Mir".lowercased() {
            cardLogo.image = #imageLiteral(resourceName: "Mir")
        } else if type == "Meza".lowercased() {
            cardLogo.image = #imageLiteral(resourceName: "miza_logo")
        } else {
            cardLogo.image = #imageLiteral(resourceName: "card_list_icon")
        }
    }

    @IBAction func didTapRadioButton(_ sender: UIButton) {
        delegate?.didTapRadioButton(forCell: self)
    }

    @IBAction func didTapDeleteButton(_ sender: UIButton) {
        delegate?.didTapDeleteButton(forCell: self)
    }
}
