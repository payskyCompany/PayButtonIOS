//
//  SmsPaymentRequest.swift
//  PayButton
//
//  Created by AMR on 10/8/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import Foundation
import EVReflection

public class SmsPaymentRequest: BaseResponse {
    
    
    var MobileNumber = ""
    var Amount = MainScanViewController.paymentData.amount
    var ISOQR = ""
    var MerchantReference = MainScanViewController.paymentData.refnumber
    
}
