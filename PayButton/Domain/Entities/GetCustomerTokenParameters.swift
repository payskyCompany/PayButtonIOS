//
//  GetCustomerTokenParameters.swift
//  OoredooPayButton
//
//  Created by Hazem-Mohamed on 22/09/2022.
//

import Foundation

struct GetCustomerTokenParameters {
    
    var sessionId: String
    var customerId: String
    var amount: String
    var merchantId: String
    var terminalId: String
    var dateTimeLocalTrxn: String
    var secureHash: String
    
    init(sessionId: String, customerId: String, amount: String, merchantId: String, terminalId: String, secureHashKey: String) {
        self.sessionId = sessionId
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
        dictionary["SessionId"] = sessionId
        dictionary["CustomerId"] = customerId
        dictionary["Amount"] = amount
        dictionary["MerchantId"] = merchantId
        dictionary["TerminalId"] = terminalId
        dictionary["DateTimeLocalTrxn"] = dateTimeLocalTrxn
        dictionary["SecureHash"] = secureHash
        return dictionary
    }
}
