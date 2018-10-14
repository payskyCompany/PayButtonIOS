//
//  PaymentMethodResponse.swift
//  PayButton
//
//  Created by AMR on 10/9/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import Foundation
public class PaymentMethodResponse: BaseResponse {
    
    
    

    var  Is3DS = true
    var IsTahweel = true
     var IsValidPayByCardFromWeb: Bool = true
    var IsmVisa: Bool = true
    var MerchantBankLogo  = ""
    var MerchantCurrency = ""
    var MerchantName: String = ""
    var PaymentMethod: Int = 0
    var TerminalPublicKey: String = ""
    
  
    
}
