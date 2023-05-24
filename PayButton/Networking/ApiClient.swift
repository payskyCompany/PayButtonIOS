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
    case payByCard(_ params: PayByCardParameters)
    case payByWallet(_ params: PayByWalletParameters)
    case payByNaps(_ params: PayByNapsParameters)
    case checkTransactionStatus(_ params: CheckTransactionStatusParameters)
    case getSessionForCustomerToken(_ params: GetCustomerSessionParameters)
    case getAllCardsForCustomerToken(_ params: GetCustomerTokensParameters)
    case getAllWalletsForCustomerToken(_ params: GetCustomerTokensParameters)
    case deleteToken(_ params: DeleteTokenParameters)
}

extension ApiClient: EndpointType {
    
    private var domain: String {
        return Constants.DOMAIN_URL
    }
    
    var gateway: String {
        switch self {
        case .payByNaps:
            return "/LightboxAPI/api"
        default:
            if(Constants.DOMAIN_URL == Environment.Grey.description) {
                return "/omni/PayLink.svc/api"
            } else {
                return "/cube/PayLink.svc/api"
            }
        }
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
        case .payByCard:
            return "/PayByCard"
        case .payByWallet:
            return "/DebitWallet"
        case .payByNaps:
            return "/PayNAPS"
        case .checkTransactionStatus:
            return "/CheckTxnStatus"
        case .getSessionForCustomerToken:
            return "/GetSessionForCustomerToken"
        case .getAllCardsForCustomerToken:
            return "/GetAllCardsForCustomerToken"
        case .getAllWalletsForCustomerToken:
            return "/GetAllWalletsForCustomerToken"
        case .deleteToken:
            return "/RemoveToken"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .checkPaymentMethod(let params):
            return params.toDict()
        case  .payByCard(let params):
            return params.toDict()
        case .payByWallet(let params):
            return params.toDict()
        case .checkTransactionStatus(let params):
            return params.toDict()
        case .getSessionForCustomerToken(let params):
            return params.toDict()
        case .getAllCardsForCustomerToken(let params):
            return params.toDict()
        case .getAllWalletsForCustomerToken(let params):
            return params.toDict()
        case .deleteToken(let params):
            return params.toDict()
        case .payByNaps:
            return nil
        }
    }
    
    var urlParameters: Parameters? {
        switch self {
        case .payByNaps(let params):
            return params.toDict()
        default:
            return nil
        }
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
