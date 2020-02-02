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
    let IsMobileSDK = true

public    var Success = false;
 public   var Message = ""
 public   var TerminalId = MainScanViewController.paymentData.terminalId
    public   var MerchantId = MainScanViewController.paymentData.merchantId
    public   var DateTimeLocalTrxn = BaseResponse.getDate()
    public   var SecureHash = "35666437383237622D626132312D346366312D613163662D363136343233343563353266"
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
