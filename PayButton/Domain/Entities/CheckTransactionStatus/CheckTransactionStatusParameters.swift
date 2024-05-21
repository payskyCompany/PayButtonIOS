//
//  CheckTransactionStatusParameters.swift
//  PayButton
//
//  Created by Nada Kamel on 02/09/2022.
//

import Foundation

struct CheckTransactionStatusParameters {
    
    var merchantId: String
    var terminalId: String
    var secureHash: String
    var dateTimeLocalTrxn: String
    var extraInfo: String
    var isNaps: Bool
    var isMobileSDK: Bool
    var isOoredoo: Bool
    
    init(merchantId: String, terminalId: String, secureHashKey: String, isNaps: Bool = true, isOoredoo: Bool = false, extraInfo: String = "") {
        self.merchantId = merchantId
        self.terminalId = terminalId
        dateTimeLocalTrxn = FormattedDate.getDate()
        var encodedSecureHash  = "DateTimeLocalTrxn=" + dateTimeLocalTrxn + "&MerchantId=" + merchantId + "&TerminalId=" + terminalId
        encodedSecureHash = encodedSecureHash.hmac(algorithm: HMACAlgorithm.SHA256, key: secureHashKey)
        secureHash = encodedSecureHash
        self.extraInfo = extraInfo
        self.isNaps = isNaps
        isMobileSDK = true
        self.isOoredoo = isOoredoo
    }

    func toDict() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["MerchantId"] = merchantId
        dictionary["TerminalId"] = terminalId
        dictionary["SecureHash"] = secureHash
        dictionary["DateTimeLocalTrxn"] = dateTimeLocalTrxn
        dictionary["ExtraInfo"] = extraInfo
        dictionary["IsNaps"] = isNaps
        dictionary["IsMobileSDK"] = isMobileSDK
        dictionary["IsOoredoo"] = isOoredoo
        return dictionary
    }
}
