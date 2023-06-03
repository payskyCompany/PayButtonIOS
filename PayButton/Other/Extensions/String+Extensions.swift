//
//  String+Extensions.swift
//  PayButton
//
//  Created by Nada Kamel on 28/05/2023.
//  Copyright © 2023 Paysky. All rights reserved.
//

import Foundation

extension String {
    
    var replacedArabicDigitsWithEnglish: String {
        var str = self
        let map = ["٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9"]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
    
    func localizedString(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        var bundle: Bundle!
        let path = Bundle(for: BasePaymentViewController.self).path(forResource:"PayButton", ofType: "bundle")
        if path != nil {
            bundle = Bundle(path: path!) ?? Bundle.main
        } else {
            bundle = Bundle.main
        }
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: "**\(self)**", comment: "")
    }
    
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
