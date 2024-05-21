//
//  TokenizedCardParameters.swift
//  PayButton
//
//  Created by Nada Kamel on 06/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

struct TokenizedCardParameters {
    var amountTrxn, currencyCodeTrxn: String
    var merchantId, terminalId, secureHash: String
    var dateTimeLocalTrxn: String
    var cardAcceptorIdCode, cardAcceptorTerminalId: String?
    var cvv2: String?
    var merchantReference, systemTraceNr: String?
    var returnURL: String?
    var isFromPOS, isWebRequest, isMobileSDK: Bool?
    var tokenCardId: String?
    var tokenCustomerId, tokenCustomerSession: String?

    init(amountTrxn: String,
         merchantId: String,
         terminalId: String,
         secureHashKey: String,
         cvv: String,
         tokenCustomerId: String,
         tokenCustomerSession: String,
         tokenCardId: String) {
        self.amountTrxn = amountTrxn
        currencyCodeTrxn = "\(MerchantDataManager.shared.merchant.currencyCode)"
        self.merchantId = merchantId
        self.terminalId = terminalId
        dateTimeLocalTrxn = FormattedDate.getDate()
        var encodedSecureHash = "DateTimeLocalTrxn=" + dateTimeLocalTrxn + "&MerchantId=" + merchantId + "&TerminalId=" + terminalId
        encodedSecureHash = encodedSecureHash.hmac(algorithm: HMACAlgorithm.SHA256, key: secureHashKey)
        secureHash = encodedSecureHash
        cardAcceptorIdCode = merchantId
        cardAcceptorTerminalId = terminalId
        cvv2 = cvv
        isFromPOS = false
        isWebRequest = true
        isMobileSDK = true
        returnURL = AppConstants.DOMAIN_URL
        let transactionReferenceNumber = MerchantDataManager.shared.merchant.trnxRefNumber
        systemTraceNr = transactionReferenceNumber
        merchantReference = transactionReferenceNumber
        self.tokenCustomerId = tokenCustomerId
        self.tokenCustomerSession = tokenCustomerSession
        self.tokenCardId = tokenCardId
    }

    func toDict() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["AmountTrxn"] = amountTrxn
        dictionary["CurrencyCodeTrxn"] = currencyCodeTrxn
        dictionary["MerchantReference"] = merchantReference
        dictionary["MerchantId"] = merchantId
        dictionary["TerminalId"] = terminalId
        dictionary["SecureHash"] = secureHash
        dictionary["DateTimeLocalTrxn"] = dateTimeLocalTrxn
        dictionary["cvv2"] = cvv2
        dictionary["CardAcceptorIDcode"] = cardAcceptorIdCode
        dictionary["CardAcceptorTerminalID"] = cardAcceptorTerminalId
        dictionary["ISFromPOS"] = isFromPOS
        dictionary["SystemTraceNr"] = systemTraceNr
        dictionary["ReturnURL"] = returnURL
        dictionary["IsWebRequest"] = isWebRequest
        dictionary["IsMobileSDK"] = isMobileSDK
        dictionary["TokenCustomerId"] = tokenCustomerId
        dictionary["TokenCustomerSession"] = tokenCustomerSession
        dictionary["TokenCardId"] = tokenCardId
        return dictionary
    }
}
