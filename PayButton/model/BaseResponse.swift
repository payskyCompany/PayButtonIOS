//
//  BaseResponse.swift
//  PayButton
//
//  Created by AMR on 7/3/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import EVReflection
import Foundation

public class BaseResponse: EVObject {
    
    let IsMobileSDK = true
    public var Success = false
    public var Message = ""
    public var TerminalId = MainScanViewController.paymentData.terminalId
    public var MerchantId = MainScanViewController.paymentData.merchantId
    public var DateTimeLocalTrxn = BaseResponse.getDate()
    public var SecureHash = "32303763346235342D316635392D346232642D396366652D653036623935366630346438"
    public var TxnId = 0
    public var ModelState = ""
    
    public static  func getDate() -> String  {
        let date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        let todaysDate = dateFormatter.string(from: date)
        return  todaysDate
    }
    
}
