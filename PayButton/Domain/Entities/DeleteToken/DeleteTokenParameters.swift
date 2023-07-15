//
//  DeleteTokenParameters.swift
//  PayButton
//
//  Created by Nada Kamel on 24/09/2022.
//

import Foundation

struct DeleteTokenParameters {
    
    var token: String
    var customerId: String
    var merchantId: String
    var terminalId: String
    var dateTimeLocalTrxn: String
    var secureHash: String
    
    init(token: String, customerId: String, merchantId: String, terminalId: String, secureHashKey: String) {
        self.token = token
        self.customerId = customerId
        self.merchantId = merchantId
        self.terminalId = terminalId
        dateTimeLocalTrxn = FormattedDate.getDate()
        var encodedSecureHash  = "DateTimeLocalTrxn=" + dateTimeLocalTrxn + "&MerchantId=" + merchantId + "&TerminalId=" + terminalId
        encodedSecureHash = encodedSecureHash.hmac(algorithm: HMACAlgorithm.SHA256, key: secureHashKey)
        secureHash = encodedSecureHash
    }
    
    func toDict() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["Token"] = token
        dictionary["CustomerId"] = customerId
        dictionary["MerchantId"] = merchantId
        dictionary["TerminalId"] = terminalId
        dictionary["DateTimeLocalTrxn"] = dateTimeLocalTrxn
        dictionary["SecureHash"] = secureHash
        return dictionary
    }
}
