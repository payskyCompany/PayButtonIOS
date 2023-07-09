//
//  SendReceiptByEmailRequest.swift
//  PayButton
//
//  Created by Nada Kamel on 09/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

struct SendReceiptByEmailRequest {
    var emailTo: String
    var externalReceiptNumber: String
    var externalReceiptNo: String
    var transactionId: String
    var transactionChannel: String
    
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
