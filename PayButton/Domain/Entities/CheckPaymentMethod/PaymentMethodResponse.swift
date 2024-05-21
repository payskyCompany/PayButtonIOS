//
//  PaymentMethodResponse.swift
//  PayButton
//
//  Created by Nada Kamel on 06/08/2022.
//

import Foundation

struct PaymentMethodResponse: Decodable {
    
    let message, referenceID, secureHash, secureHashData: String?
    let success: Bool?
    let transactionID, domain: String?
    let is3DS, isAnonymousSecureHash, isAnonymousSecureHashVersionTwo, isBenefit: Bool?
    let isMerchantOrTerminalInactive, isCard, isMoMoPay, isMomoPaySubMerchantsActive: Bool?
    let isNAPS,isOoredooMoney, isPayOnDelivery, isTokenized, isTahweel: Bool?
    let isValidPayByCardFromWeb, ismVisa: Bool?
    let merchantCurrency: String?
    let merchantName, merchantSecureKey: String?
    let paymentMethod: Int?
    let terminalPublicKey: String?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case referenceID = "ReferenceId"
        case secureHash = "SecureHash"
        case secureHashData = "SecureHashData"
        case success = "Success"
        case transactionID = "TransactionId"
        case domain = "Domain"
        case is3DS = "Is3DS"
        case isAnonymousSecureHash = "IsAnonymousSecureHash"
        case isAnonymousSecureHashVersionTwo = "IsAnonymousSecureHashVersionTwo"
        case isBenefit = "IsBenefit"
        case isMerchantOrTerminalInactive = "IsMerchantOrTerminalInactive"
        case isCard = "IsCard"
        case isMoMoPay = "IsMoMoPay"
        case isMomoPaySubMerchantsActive = "IsMomoPaySubMerchantsActive"
        case isNAPS = "IsNAPS"
        case isOoredooMoney = "IsOoredooMoney"
        case isPayOnDelivery = "IsPayOnDelivery"
        case isTokenized = "IsTokenized"
        case isTahweel = "IsTahweel"
        case isValidPayByCardFromWeb = "IsValidPayByCardFromWeb"
        case ismVisa = "IsmVisa"
        case merchantCurrency = "MerchantCurrency"
        case merchantName = "MerchantName"
        case merchantSecureKey = "MerchantSecureKey"
        case paymentMethod = "PaymentMethod"
        case terminalPublicKey = "TerminalPublicKey"
    }
}
