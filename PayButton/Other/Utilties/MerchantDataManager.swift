//
//  MerchantDataManager.swift
//  PayButton
//
//  Created by Nada Kamel on 30/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

class MerchantDataManager {

    static let shared = MerchantDataManager()

    var merchant: MerchantDataModel!
    var isProduction: Bool = false
    
    private init() { }

    func saveMerchant(_ merchant: MerchantDataModel) {
        self.merchant = merchant
    }
    
    
}
