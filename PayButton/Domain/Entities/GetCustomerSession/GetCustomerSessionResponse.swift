//
//  GetCustomerSessionResponse.swift
//  OoredooPayButton
//
//  Created by Hazem-Mohamed on 22/09/2022.
//

import Foundation

struct GetCustomerSessionResponse: Decodable {
    
    let sessionId: String?
    let success: Bool?
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "SessionId"
        case success = "Success"
    }
}
