//
//  ChangeDefaultTokenParameters.swift
//  PayButton
//
//  Created by Nada Kamel on 09/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

struct ChangeDefaultTokenParameters {
    var token: String
    var customerId: String
    var merchantId: String
    var terminalId: String
    var dateTimeLocalTrxn: String
    
    init(token: String, customerId: String, merchantId: String, terminalId: String) {
        self.token = token
        self.customerId = customerId
        self.merchantId = merchantId
        self.terminalId = terminalId
        dateTimeLocalTrxn = FormattedDate.getDate()
    }

    func toDict() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["Token"] = token
        dictionary["CustomerId"] = customerId
        dictionary["MerchantId"] = merchantId
        dictionary["TerminalId"] = terminalId
        dictionary["DateTimeLocalTrxn"] = dateTimeLocalTrxn
        return dictionary
    }
}
