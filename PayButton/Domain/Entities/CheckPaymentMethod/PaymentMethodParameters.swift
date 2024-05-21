//
//  PaymentMethodParameters.swift
//  PayButton
//
//  Created by Nada Kamel on 04/08/2022.
//

import Foundation

struct PaymentMethodParameters {
    var merchantId: String
    var terminalId: String
    var secureHash: String
    var dateTimeLocalTrxn: String
    var isMobileSDK: Bool

    init(merchantId: String, terminalId: String, secureHashKey: String) {
        self.merchantId = merchantId
        self.terminalId = terminalId
        dateTimeLocalTrxn = FormattedDate.getDate()
        var encodedSecureHash  = "DateTimeLocalTrxn=" + dateTimeLocalTrxn + "&MerchantId=" + merchantId + "&TerminalId=" + terminalId
        encodedSecureHash = encodedSecureHash.hmac(algorithm: HMACAlgorithm.SHA256, key: secureHashKey)
        secureHash = encodedSecureHash
        isMobileSDK = true
    }

    func toDict() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["MerchantId"] = merchantId
        dictionary["TerminalId"] = terminalId
        dictionary["SecureHash"] = secureHash
        dictionary["DateTimeLocalTrxn"] = dateTimeLocalTrxn
        dictionary["IsMobileSDK"] = isMobileSDK
        return dictionary
    }
}
