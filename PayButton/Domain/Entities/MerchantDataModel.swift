//
//  MerchantDataModel.swift
//  PayButton
//
//  Created by Nada Kamel on 06/08/2022.
//

import Foundation

struct MerchantDataModel {
    
    var merchantId: String
    var terminalId: String
    var amount: Double
    var currencyCode: Int
    var secureHashKey: String
    var customerId: String
    var customerMobile: String
    var customerEmail: String
    
    init(merchantId: String, terminalId: String, amount: Double, currencyCode: Int,
         secureHashKey: String, customerId: String, customerMobile: String, customerEmail: String) {
        self.merchantId = merchantId
        self.terminalId = terminalId
        self.amount = amount
        self.currencyCode = currencyCode
        self.secureHashKey = secureHashKey
        self.customerId = customerId
        self.customerMobile = customerMobile
        self.customerEmail = customerEmail
    }
}
