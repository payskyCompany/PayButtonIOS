//
//  CheckTransactionStatusResponse.swift
//  PayButton
//
//  Created by Nada Kamel on 06/08/2022.
//

import Foundation

public struct CheckTransactionStatusResponse: Decodable {
    
    let success: Bool?
    let message: String?
    let isPaid: Bool?
    let referenceId: String?
    let transactionId: String?
    let amountTrxn: Int?
    let systemTxnId: String?
    let txnDate: String?
    let systemReference: Int?
    
    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case message = "Message"
        case isPaid = "IsPaid"
        case referenceId = "ReferenceId"
        case transactionId = "TransactionId"
        case amountTrxn = "AmountTrxn"
        case systemTxnId = "SystemTxnId"
        case txnDate = "TxnDate"
        case systemReference = "SystemReference"
    }
}
