//
//  Compose3DSTransactionResponse.swift
//  PayButton
//
//  Created by AMR on 10/9/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import Foundation


public class Compose3DSTransactionResponse: BaseResponse {
    

    
        var AccessCode: String = ""
        var Amount: Int = 0
        var CardExp = ""
    var CardNum = ""
    var CardSecurityCode = ""
    var CardType = ""
        var  Command = ""
    var  Currency = ""
    var Gateway = ""
        var GatewayType: Int = 0
        var MerchTxnRef = ""
    var   MerchantAccount = ""
    var   MerchantName  = ""
    var OrderInfo: String = ""
        var paymentServerURL  = ""
    var ReturnURL = ""

    var SecureHashType = ""
        var Version: String = ""
    
    
   
    

    
    
    
    
    
    
}
