//
//  DeleteTokenResponse.swift
//  PayButton
//
//  Created by Nada Kamel on 24/09/2022.
//

import Foundation

struct DeleteTokenResponse: Decodable {
    let message, referenceId, secureHash, secureHashData: String?
    let success: Bool?
    let transactionId: String?
    let statusCode: Int?
    let errorDetail, errorDescription: String?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case referenceId = "ReferenceId"
        case secureHash = "SecureHash"
        case secureHashData = "SecureHashData"
        case success = "Success"
        case transactionId = "TransactionId"
        case statusCode = "StatusCode"
        case errorDetail = "ErrorDetail"
        case errorDescription = "ErrorDescription"
    }
}
