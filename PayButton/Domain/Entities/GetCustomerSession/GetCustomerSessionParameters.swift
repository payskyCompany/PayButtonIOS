//
//  GetCustomerSessionParameters.swift
//  PayButton
//
//  Created by Hazem-Mohamed on 22/09/2022.
//

import Foundation

struct GetCustomerSessionParameters {
    
    var customerId: String
    var amount: String
    var merchantId: String
    var terminalId: String
    var dateTimeLocalTrxn: String
    var secureHash: String

    init(customerId: String, amount: String, merchantId: String, terminalId: String, secureHashKey: String) {
        self.customerId = customerId
        self.amount = amount
        self.merchantId = merchantId
        self.terminalId = terminalId
        dateTimeLocalTrxn = FormattedDate.getDate()
        var encodedSecureHash  = "DateTimeLocalTrxn=" + dateTimeLocalTrxn + "&MerchantId=" + merchantId + "&TerminalId=" + terminalId
        encodedSecureHash = encodedSecureHash.hmac(algorithm: HMACAlgorithm.SHA256, key: secureHashKey)
        secureHash = encodedSecureHash
    }

    func toDict() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["CustomerId"] = customerId
        dictionary["Amount"] = amount
        dictionary["MerchantId"] = merchantId
        dictionary["TerminalId"] = terminalId
        dictionary["DateTimeLocalTrxn"] = dateTimeLocalTrxn
        dictionary["SecureHash"] = secureHash
        return dictionary
    }
}
