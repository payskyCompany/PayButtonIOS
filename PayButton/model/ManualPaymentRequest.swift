//
//  ManualPaymentRequest.swift
//  PayButton
//
//  Created by AMR on 10/8/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import Foundation
import EVReflection

public class ManualPaymentRequest: BaseResponse {

    
    
    var ThreeDSECI = ""
    var ThreeDSXID = ""
    var ThreeDSenrolled = ""
    var ThreeDSstatus = ""
    var VerToken = ""
    var VerType = ""
    
    
    
    var CurrencyCodeTrxn = MainScanViewController.paymentData.currencyCode
    var cvv2 = ""
    var CVV2 = ""
    var DateExpiration = ""
    var PAN = ""
    var  AmountTrxn  = ""
    var IsWebRequest = true
    var ReturnURL = "http://localhost.com/"

    var MerchantReference = getRandom()
    
    public static  func getRandom() -> String  {
        if PaymentViewController.refnumber == "" ||
            PaymentViewController.refnumber.isEmpty {
            let myVar: Int = Int(arc4random())
            return String (myVar)
        }else{
            return PaymentViewController.refnumber
        }
     
    }

    
   
    
    
    
    
}
