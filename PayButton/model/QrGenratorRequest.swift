//
//  QrGenratorRequest.swift
//  PayButton
//
//  Created by AMR on 10/8/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import Foundation
import EVReflection
public class QrGenratorRequest: BaseResponse {

    
    
    var Amount: Double = 0.0
    var AmountTrxn = 0
    var TahweelQR: Bool = true
    var mVisaQR: Bool = true
    var MerchantReference = MainScanViewController.paymentData.refnumber

}
