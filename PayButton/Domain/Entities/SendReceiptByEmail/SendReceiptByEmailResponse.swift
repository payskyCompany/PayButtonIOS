//
//  SendReceiptByEmailResponse.swift
//  PayButton
//
//  Created by Nada Kamel on 09/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

struct SendReceiptByEmailResponse: Decodable {
    let message: String?
    let secureHash: String?
    let secureHashData: String?
    let success: Bool?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case secureHash = "SecureHash"
        case secureHashData = "SecureHashData"
        case success = "Success"
    }
}
