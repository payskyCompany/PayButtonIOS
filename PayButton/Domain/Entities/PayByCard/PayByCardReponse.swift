//
//  PayByCardReponse.swift
//  PayButton
//
//  Created by Nada Kamel on 09/09/2022.
//

import Foundation

public struct PayByCardReponse: Codable {
    public let success: Bool?
    public let message: String?
    public let actionCode, authCode, mWMessage: String?
    public let merchantReference, networkReference: String?
    public let receiptNumber, refNumber: String?
    public let systemReference: Int?
    public let tokenCustomerId: String?
    public let transactionNo, threeDSUrl: String?
    public let challengeRequired: Bool?
    public let isPaid: Bool?
    public let fromWhere: String?

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
