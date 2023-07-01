//
//  PayByCardReponse.swift
//  PayButton
//
//  Created by Nada Kamel on 09/09/2022.
//

import Foundation

public struct PayByCardReponse: Decodable {
    
    let success: Bool?
    let message: String?
    let actionCode, authCode, mWMessage: String?
    let merchantReference, networkReference: String?
    let receiptNumber, refNumber: String?
    let systemReference: Int?
    let tokenCustomerId: String?
    let transactionNo, threeDSUrl: String?
    let challengeRequired: Bool?
    let isPaid: Bool?
    let fromWhere: String?
    
    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case message = "Message"
        case actionCode = "ActionCode"
        case authCode = "AuthCode"
        case mWMessage = "MWMessage"
        case merchantReference = "MerchantReference"
        case networkReference = "NetworkReference"
        case receiptNumber = "ReceiptNumber"
        case refNumber = "RefNumber"
        case systemReference = "SystemReference"
        case tokenCustomerId = "TokenCustomerId"
        case transactionNo = "TransactionNo"
        case threeDSUrl = "ThreeDSUrl"
        case challengeRequired = "ChallengeRequired"
        case isPaid = "IsPaid"
        case fromWhere = "FROMWHERE"
    }
}
