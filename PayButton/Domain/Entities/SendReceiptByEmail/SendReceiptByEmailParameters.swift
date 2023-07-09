//
//  SendReceiptByEmailParameters.swift
//  PayButton
//
//  Created by Nada Kamel on 09/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

struct SendReceiptByEmailParameters {
    var emailTo: String
    var externalReceiptNumber: String
    var externalReceiptNo: String
    var transactionId: String
    var transactionChannel: String

    init(emailTo: String, externalReceiptNumber: String, externalReceiptNo: String, transactionId: String, transactionChannel: String) {
        self.emailTo = emailTo
        self.externalReceiptNumber = externalReceiptNumber
        self.externalReceiptNo = externalReceiptNo
        self.transactionId = transactionId
        self.transactionChannel = transactionChannel
    }

    func toDict() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["EmailTo"] = emailTo
        dictionary["ExternalReceiptNumber"] = externalReceiptNumber
        dictionary["ExternalReceiptNo"] = externalReceiptNo
        dictionary["TransactionId"] = transactionId
        dictionary["TransactionChannel"] = transactionChannel
        return dictionary
    }
}
