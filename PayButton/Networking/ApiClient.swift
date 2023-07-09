//
//  NetworkAPI.swift
//  PayButton
//
//  Created by Nada Kamel on 21/07/2022.
//  Copyright © 2022 PaySky. All rights reserved.
//

import Foundation

enum ApiClient {
    case checkPaymentMethod(_ params: PaymentMethodParameters)
    case payByNewCard(_ params: PayByCardParameters)
    case payByTokenizedCard(_ params: TokenizedCardParameters)
    case checkTransactionStatus(_ params: CheckTransactionStatusParameters)
    case getSessionForCustomerToken(_ params: GetCustomerSessionParameters)
    case getAllCardsForCustomerToken(_ params: GetCustomerTokenParameters)
    case deleteToken(_ params: DeleteTokenParameters)
    case sendReceiptByEmail(_ params: SendReceiptByEmailParameters)
}

extension ApiClient: EndpointType {
    
    private var domain: String {
        return AppConstants.DOMAIN_URL
    }
   
    var gateway: String {
        return "cube/PayLink.svc/api"
    }
    
    var baseURL: URL {
        let urlString: String = domain + gateway
        guard let url = URL(string: urlString) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .checkPaymentMethod:
            return "/CheckPaymentMethod"
        case .payByNewCard:
            return "/PayByCard"
        case .payByTokenizedCard:
            return "/PayByCard"
        case .checkTransactionStatus:
            return "/CheckTxnStatus"
        case .getSessionForCustomerToken:
            return "/GetSessionForCustomerToken"
        case .getAllCardsForCustomerToken:
            return "/GetAllCardsForCustomerToken"
        case .deleteToken:
            return "/RemoveToken"
        case .sendReceiptByEmail:
            return "/SendReceiptToEmail"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .checkPaymentMethod(let params):
            return params.toDict()
        case  .payByNewCard(let params):
            return params.toDict()
        case .payByTokenizedCard(let params):
            return params.toDict()
        case .checkTransactionStatus(let params):
            return params.toDict()
        case .getSessionForCustomerToken(let params):
            return params.toDict()
        case .getAllCardsForCustomerToken(let params):
            return params.toDict()
        case .deleteToken(let params):
            return params.toDict()
        case .sendReceiptByEmail(let params):
            return params.toDict()
        }
    }
    
    var urlParameters: Parameters? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json", "Accept-Language": "en"]
    }
    
    var task: HTTPTask {
        return .requestParametersAndHeaders(bodyParameters: bodyParameters,
                                            bodyEncoding: .jsonEncoding,
                                            urlParameters: urlParameters,
                                            additionHeaders: headers)
    }

}
