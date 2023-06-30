//
//  PayByCardParameters.swift
//  PayButton
//
//  Created by Nada Kamel on 02/09/2022.
//

import Foundation

struct PayByCardParameters {
    
    var amountTrxn, currencyCodeTrxn: String
    var merchantId, terminalId, secureHash: String
    var dateTimeLocalTrxn: String
    var isSaveCard: Bool
    var cardAcceptorIdCode, cardAcceptorTerminalId: String?
    var cardHolderName, dateExpiration: String?
    var cvv2: String?
    var pan: String?
    var merchantReference, systemTraceNr: String?
    var returnURL: String?
    var isFromPOS, isWebRequest, isMobileSDK: Bool?
    var tokenCardId: Int?
    var tokenCustomerId, tokenCustomerSession: String?
    var customerEmail: String?
    
    init(amountTrxn: String,
         merchantId: String,
         terminalId: String,
         secureHashKey: String,
         cardNumber: String? = "",
         cardHolderName: String? = "",
         expiryDate: String? = "",
         cvv: String? = "",
         isSaveCard: Bool,
         tokenCustomerId: String? = "",
         tokenCustomerSession: String? = "",
         tokenCardId: Int? = 0,
         customerEmail: String) {
        self.amountTrxn = amountTrxn
        currencyCodeTrxn = "\(MerchantDataManager.shared.merchant.currencyCode)"
        self.merchantId = merchantId
        self.terminalId = terminalId
        dateTimeLocalTrxn = FormattedDate.getDate()
        var encodedSecureHash  = "DateTimeLocalTrxn=" + dateTimeLocalTrxn + "&MerchantId=" + merchantId + "&TerminalId=" + terminalId
        encodedSecureHash = encodedSecureHash.hmac(algorithm: HMACAlgorithm.SHA256, key: secureHashKey)
        secureHash = encodedSecureHash
        self.cardHolderName = cardHolderName
        self.isSaveCard = isSaveCard
        self.tokenCustomerId = tokenCustomerId
        self.tokenCustomerSession = tokenCustomerSession
        self.tokenCardId = tokenCardId
        cardAcceptorIdCode = merchantId
        cardAcceptorTerminalId = terminalId
        pan = cardNumber
        dateExpiration = expiryDate
        cvv2 = cvv
        isFromPOS = false
        isWebRequest = true
        isMobileSDK = true
        returnURL = AppConstants.DOMAIN_URL
        let transactionReferenceNumber = AppConstants.generateRandomNumber(digits: 16)
        systemTraceNr = transactionReferenceNumber
        merchantReference = transactionReferenceNumber
        self.customerEmail = customerEmail
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
        dictionary["CardHolderName"] = cardHolderName
        dictionary["cvv2"] = cvv2
        dictionary["CardAcceptorIDcode"] = cardAcceptorIdCode
        dictionary["CardAcceptorTerminalID"] = cardAcceptorTerminalId
        dictionary["ISFromPOS"] = isFromPOS
        dictionary["DateExpiration"] = dateExpiration
        dictionary["SystemTraceNr"] = systemTraceNr
        dictionary["PAN"] = pan
        dictionary["ReturnURL"] = returnURL
        dictionary["IsWebRequest"] = isWebRequest
        dictionary["IsMobileSDK"] = isMobileSDK
        dictionary["IsSaveCard"] = isSaveCard
        dictionary["TokenCustomerId"] = tokenCustomerId
        dictionary["TokenCustomerSession"] = tokenCustomerSession
        dictionary["TokenCardId"] = tokenCardId
        dictionary["CustomerEmail"] = customerEmail
        return dictionary
    }
}
