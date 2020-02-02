//
//  CreditCardValidator.swift
//
//  Created by Vitaliy Kuzmenko on 02/06/15.
//  Copyright (c) 2015. All rights reserved.
//

import Foundation

public class CreditCardValidator {
    
    public lazy var types: [CreditCardValidationType] = {
        var types = [CreditCardValidationType]()
        for object in CreditCardValidator.types {
            types.append(CreditCardValidationType(dict: object))
        }
        return types
        }()
    
    public init() { }
    
    /**
    Get card type from string
    
    - parameter string: card number string
    
    - returns: CreditCardValidationType structure
    */
    public func type(from string: String) -> CreditCardValidationType? {
        for type in types {
            let predicate = NSPredicate(format: "SELF MATCHES %@", type.regex)
            let numbersString = self.onlyNumbers(string: string)
            if predicate.evaluate(with: numbersString) {
                return type
            }
        }
        return nil
    }
    
    /**
    Validate card number
    
    - parameter string: card number string
    
    - returns: true or false
    */
    public func validate(number: String) -> Bool {
        var sum = 0
        let digitStrings = number.reversed().map { String($0) }
        
        for tuple in digitStrings.enumerated() {
            if let digit = Int(tuple.element) {
                let odd = tuple.offset % 2 == 1
                
                switch (odd, digit) {
                case (true, 9):
                    sum += 9
                case (true, 0...8):
                    sum += (digit * 2) % 9
                default:
                    sum += digit
                }
            } else {
                return false
            }
        }
        return sum % 10 == 0
    }
    
    /**
    Validate card number string for type
    
    - parameter string: card number string
    - parameter type:   CreditCardValidationType structure
    
    - returns: true or false
    */
    public func validate(string: String, forType type: CreditCardValidationType) -> Bool {
        return self.type(from: string) == type
    }
    
    public func onlyNumbers(string: String) -> String {
        let set = CharacterSet.decimalDigits.inverted
        let numbers = string.components(separatedBy: set)
        return numbers.joined(separator: "")
    }
    
    // MARK: - Loading data
    
    private static let types = [
        [
            "name": "Amex",
            "regex": "^3[47][0-9]{5,}$"
        ], [
            "name": "Visa",
            "regex": "^4\\d{0,}$"
        ], [
            "name": "MasterCard",
            "regex": "^(5[1-5]|2[2-7])\\d{0,14}$"
        ], [
            "name": "Maestro",
            "regex": "^(?:5[0678]\\d\\d|6304|6390|67\\d\\d)\\d{8,15}$"
        ], [
            "name": "Diners Club",
            "regex": "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        ], [
            "name": "JCB",
            "regex": "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        ], [
            "name": "Discover",
            "regex": "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        ], [
            "name": "UnionPay",
            "regex": "^62[0-5]\\d{13,16}$"
        ], [
            "name": "Mir",
            "regex": "^22[0-9]{1,14}$"
        ],[
            "name": "Meza",
            "regex": "^50[0-9]{14,14}$"
        ],[
            "name": "Meza",
            "regex": "^50\\d*"
        ],[
            "name": "Meza",
            "regex": "^9818[0-9]{12,15}$"
        ],[
            "name": "Meza",
            "regex":"^9818\\d*"
        ]
          
          
        
    ]
    
}


/*
 // VISA
 public static final String VISA = "4[0-9]{12}(?:[0-9]{3})?";
 public static final String VISA_SHOET = "^4\\d*";
 public static final String VISA_VALID = "^4[0-9]{12}(?:[0-9]{3})?$";
 // MasterCard
 public static final String MASTERCARD = "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$";
 public static final String MASTERCARD_SHORT = "^(?:222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)";
 public static final String MASTERCARD_SHORTER = "^(?:5[1-5])\\d*";
 public static final String MASTERCARD_VALID = "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$";
 // American Express
 public static final String AMERICAN_EXPRESS = "^3[47][0-9]{0,13}";
 public static final String AMERICAN_EXPRESS_VALID = "^3[47][0-9]{13}$";
 // DISCOVER
 public static final String DISCOVER = "^6(?:011|5[0-9]{1,2})[0-9]{0,12}";
 public static final String DISCOVER_SHORT = "^6(?:011|5)";
 public static final String DISCOVER_VALID = "^6(?:011|5[0-9]{2})[0-9]{12}$";
 // JCB
 public static final String JCB = "^(?:2131|1800|35\\d{0,3})\\d{0,11}$";
 public static final String JCB_SHORT = "^2131|1800";
 public static final String JCB_VALID = "^(?:2131|1800|35\\d{3})\\d{11}$";
 // Discover
 public static final String DINERS_CLUB = "^3(?:0[0-5]|[68][0-9])[0-9]{11}$";
 public static final String DINERS_CLUB_SHORT = "^30[0-5]";
 public static final String DINERS_CLUB_VALID = "^3(?:0[0-5]|[68][0-9])[0-9]{11}$";
 public static final String MEZA_VALID = "^50[0-9]{14,14}$";
 public static final String SHORT_MEZA_VALID = "^50\\d*";
 public static final String MASTER_MEZA_VALID = "^9818[0-9]{12,15}$";
 public static final String SHORT_MASTER_MEZA_VALID = "^9818\\d*";
 */
