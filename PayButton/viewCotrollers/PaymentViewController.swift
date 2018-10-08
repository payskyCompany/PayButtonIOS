//
//  PaymentViewController.swift
//  tokenization
//
//  Created by AMR on 7/8/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import Foundation
import UIKit
public class PaymentViewController  {
    public var merchantToken = ""
    public var userToken = ""
    public  var merchantName = ""
    public  var currency = -1
    public  var amount = -1
    public   var ordId = ""
    public  var tId = ""
    public   var mId = ""
    
    
    public  var delegate: PaymentDelegate?
    
    public init(){
        
    }
    
    
    public func pushViewController()  {
        
        
        let paymentData = PaymentData()
        paymentData.amount = amount
        paymentData.currencyCode = currency
        paymentData.orderId = ordId
        paymentData.merchantId = mId
        paymentData.terminalId = tId
        paymentData.merchant_token = merchantToken
        paymentData.merchant_name = merchantName
        
        if delegate == nil {
            
            print("Please implement Delaget ");
            return
        }
        
        
        if merchantToken.isEmpty  || userToken.isEmpty  {
            
            print("Please set merchantToken and userToken");
            
            
            return
        }
        if  (paymentData.amount != -1 && paymentData.currencyCode != -1
            &&  !paymentData.orderId.isEmpty &&
            !paymentData.merchantId.isEmpty &&
            !paymentData.terminalId.isEmpty)
        {
            RegiserOrGetOldToken(paymentData: paymentData)
            
            
        }
        
        
        
        
    }
    
    
 
    
    
    private func RegiserOrGetOldToken(paymentData : PaymentData)  {
        let psb = UIStoryboard.init(name: "PayButtonBoard", bundle: nil)
        
        
            
            let vc :MainScanViewController = psb.instantiateViewController(withIdentifier: "MainScanViewController") as! MainScanViewController
            vc.paymentData = paymentData
            vc.delegate = self.delegate
//
//
        if UIApplication.topViewController()?.navigationController != nil {
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)

            vc.fromNav = true
        }else{
            let nv = UINavigationController(rootViewController: vc)
               UIApplication.topViewController()?.present(nv, animated: true, completion: nil)
            vc.fromNav = false

        }
        
    }
    

    
    
    

    
}
public protocol PaymentDelegate: class {
    func finishSdkPayment(_ receipt :PayResponse )
}
