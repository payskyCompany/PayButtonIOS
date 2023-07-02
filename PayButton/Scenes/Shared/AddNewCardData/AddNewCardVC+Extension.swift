//
//  AddNewCardVC+Extension.swift
//  PayButton
//
//  Created by Nada Kamel on 02/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import UIKit

extension AddNewCardVC {
    
    func isDataValid() -> Bool {
        guard !(self.cardNumber.isEmpty) else {
            UIApplication.topViewController()?.view.makeToast("cardNumber_NOTVALID".localizedString())
            return false
        }
        guard self.validCard else {
            UIApplication.topViewController()?.view.makeToast("cardNumber_VALID".localizedString())
            return false
        }
        guard (self.cardHolderNameTF.text != "") else {
            UIApplication.topViewController()?.view.makeToast("CardHolderNameRequird".localizedString())
            return false
        }
        guard (self.cardExpireDateTF.text != "") else {
            UIApplication.topViewController()?.view.makeToast("DateTF_NOTVALID".localizedString())
            return false
        }
        guard (self.cardExpireDateTF.text?.count == 5) else {
            UIApplication.topViewController()?.view.makeToast("DateTF_NOTVALID_AC".localizedString())
            return false
        }
        guard self.validExpiryDate else {
            UIApplication.topViewController()?.view.makeToast("invalid_expire_date_date".localizedString())
            return false
        }
        guard (self.cardCVVTF.text != "") else {
            UIApplication.topViewController()?.view.makeToast("CVCTF_NOTVALID".localizedString())
            return false
        }
        guard (self.cardCVVTF.text?.count == 3) else {
            UIApplication.topViewController()?.view.makeToast("CVCTF_NOTVALID_LENGTH".localizedString())
            return false
        }
        return true
    }
    
    func checkCardNumberValid(_ value: String) {
        self.cardNumber = value.replacedArabicDigitsWithEnglish
        
        if let type = creditCardValidator.type(from: value.replacedArabicDigitsWithEnglish) {
            self.validCard = true
            if type.name == "Visa" {
                self.cardNumberLogo.image = #imageLiteral(resourceName: "vi")
            } else if type.name == "Amex"  {
                self.cardNumberLogo.image = #imageLiteral(resourceName: "am")
            } else if type.name == "MasterCard"  {
                self.cardNumberLogo.image = #imageLiteral(resourceName: "mc")
            } else if type.name == "Maestro"  {
                self.cardNumberLogo.image = #imageLiteral(resourceName: "Maestro")
            } else if type.name == "Diners Club"  {
                self.cardNumberLogo.image = #imageLiteral(resourceName: "dc")
            } else if type.name == "JCB"  {
                self.cardNumberLogo.image = #imageLiteral(resourceName: "jcb")
            } else if type.name == "Discover"  {
                self.cardNumberLogo.image = #imageLiteral(resourceName: "ds")
            } else if type.name == "UnionPay"  {
                self.cardNumberLogo.image = #imageLiteral(resourceName: "UnionPay")
            } else if type.name == "Mir"  {
                self.cardNumberLogo.image = #imageLiteral(resourceName: "Mir")
            } else if type.name == "Meza"{
                self.cardNumberLogo.image =  #imageLiteral(resourceName: "miza_logo")
            } else {
                self.validCard = false
                self.cardNumberLogo.image = #imageLiteral(resourceName: "card_icon")
            }
        } else {
            self.validCard = false
            self.cardNumberLogo.image = #imageLiteral(resourceName: "card_icon")
        }
        
        if value.count == 16 {
            if self.creditCardValidator.validate(number:value.replacedArabicDigitsWithEnglish) {
                // Card number is valid
                self.validCard = true
            } else {
                self.validCard = false
                UIApplication.topViewController()?.view.endEditing(true)
                UIApplication.topViewController()?.view.makeToast("cardNumber_VALID".localizedString())
            }
        }
    }
}
