//
//  SendReceiptByEmailParameters.swift
//  PayButton
//
//  Created by Nada Kamel on 09/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

struct SendReceiptByEmailParameters {
    var merchantId: String
    var terminalId: String
    var dateTimeLocalTrxn: String
    var secureHash: String
    var emailTo: String
    var externalReceiptNumber: String
    var externalReceiptNo: String
    var transactionId: String
    var transactionChannel: String

    init(emailTo: String, externalReceiptNumber: String, externalReceiptNo: String, transactionId: String, transactionChannel: String) {
        self.merchantId = MerchantDataManager.shared.merchant.merchantId
        self.terminalId = MerchantDataManager.shared.merchant.terminalId
        dateTimeLocalTrxn = FormattedDate.getDate()
        var encodedSecureHash  = "DateTimeLocalTrxn=" + dateTimeLocalTrxn + "&MerchantId=" + merchantId + "&TerminalId=" + terminalId
        encodedSecureHash = encodedSecureHash.hmac(algorithm: HMACAlgorithm.SHA256, key: MerchantDataManager.shared.merchant.secureHashKey)
        secureHash = encodedSecureHash
        self.emailTo = emailTo
        self.externalReceiptNumber = externalReceiptNumber
        self.externalReceiptNo = externalReceiptNo
        self.transactionId = transactionId
        self.transactionChannel = transactionChannel
    }

    func toDict() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["MerchantId"] = merchantId
        dictionary["TerminalId"] = terminalId
        dictionary["DateTimeLocalTrxn"] = dateTimeLocalTrxn
        dictionary["SecureHash"] = secureHash
        dictionary["EmailTo"] = emailTo
        dictionary["ExternalReceiptNumber"] = externalReceiptNumber
        dictionary["ExternalReceiptNo"] = externalReceiptNo
        dictionary["TransactionId"] = transactionId
        dictionary["TransactionChannel"] = transactionChannel
        return dictionary
    }
}
