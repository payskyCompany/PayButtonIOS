//
//  BaseResponse.swift
//  tokenization
//
//  Created by AMR on 7/3/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import EVReflection
import Foundation
public class BaseResponse: EVObject {
    
public    var Success = false;
 public   var Message = ""
 public   var TerminalId = MainScanViewController.paymentData.terminalId
    public   var MerchantId = MainScanViewController.paymentData.merchantId
    public   var DateTimeLocalTrxn = BaseResponse.getDate()
    public   var SecureHash = ""
    public   var TxnId = 0
    public   var ModelState = ""


    


  public static  func getDate() -> String  {

        
        let date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        let todaysDate = dateFormatter.string(from: date)
        
        
        
  return  todaysDate
       
        
    }
    

    
}
