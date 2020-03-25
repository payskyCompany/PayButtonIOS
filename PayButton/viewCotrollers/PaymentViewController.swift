//
//  PaymentViewController.swift
//  tokenization
//
//  Created by AMR on 7/8/18.
//  Copyright © 2018 Paysky. All rights reserved.
//


enum UrlTypes {
    case Production, Testing, UPG_Staging, UPG_Production
}

import Foundation
import UIKit
public class PaymentViewController  {
    public  var amount = ""
    public  var tId = ""
    public   var mId = ""
    public   var Key = ""
    public   var Currency = ""
    public   var refnumber = ""
    public   var isProduction = false
    var AppStatus = UrlTypes.UPG_Staging // production,testing,gray,upg

    

    
    
    public  var delegate: PaymentDelegate?
    
    public init(){
        
    }
    
    
    public func pushViewController()  {
        
        
        if  ( self.amount.isEmpty  || self.Currency.isEmpty){
            print("Please enter all  data ");
            return
        }
//        if  ( self.refnumber.isEmpty){
//            print("Please enter refnumber   ");
//            return
//        }
        
        
        
//        if isProduction {
//            AppConstant.setPayBtnLiveMode()
//        }
        
        switch AppStatus {
        case .Production:                        AppConstant.setPayBtnLiveMode()
        case .Testing:
            AppConstant.setPayBtnTestMode() 
        case .UPG_Staging:
            AppConstant.setPayBtnUPGStaggingMode()
        case .UPG_Production:
            AppConstant.setPayBtnUPGProductionMode()
        }
        
        
        
        var DoubleAmount = Double(""+self.amount) ??  0
        DoubleAmount = DoubleAmount * 100.00
        
        let paymentData = PaymentData()
        
        
       
        paymentData.amount = Int(DoubleAmount)
        paymentData.refnumber = refnumber

        paymentData.merchantId = mId
        paymentData.terminalId = tId
        paymentData.KEY = Key
        paymentData.currencyCode = Int (Currency)!

        if delegate == nil {
            
            print("Please implement Delaget ");
            return
        }
        
        
     
        if  (paymentData.amount != 0
            &&
            !paymentData.merchantId.isEmpty &&
            
               !paymentData.KEY.isEmpty &&
                    paymentData.currencyCode != 0 &&
            !paymentData.terminalId.isEmpty)
        {
            print(ApiURL.MAIN_API_LINK)
            RegiserOrGetOldToken(paymentData: paymentData)
       
            
        }else{
            print("Please enter all  data ");
            return
        }
        
        
        
        
    }
    
    
 
    
    
    private func RegiserOrGetOldToken(paymentData : PaymentData)  {
        MainScanViewController.paymentData = paymentData
        MainScanViewController.paymentData.amount = ( MainScanViewController.paymentData.amount )
        ApiManger.CheckPaymentMethod { (paymentresponse) in
            
            print(paymentresponse)
            if paymentresponse.Success {
                MainScanViewController.paymentData.merchant_name = paymentresponse.MerchantName
                MainScanViewController.paymentData.currencyCode = Int ( self.Currency )!
                    MainScanViewController.paymentData.PaymentMethod = paymentresponse.PaymentMethod
                MainScanViewController.paymentData.Is3DS = paymentresponse.Is3DS
                
            
                self.getSatatiQr()
                
                
            }else {
                UIApplication.topViewController()?.view.makeToast(  paymentresponse.Message)
            }
            
        }
        
        
        
        
        
        
     
        
    }
    

    
    
    func getSatatiQr(){
        
         if  MainScanViewController.paymentData.PaymentMethod == 1 ||
            MainScanViewController.paymentData.PaymentMethod == 2 {
                
                
       
        ApiManger.generateQrCode { (qrResponse) in
            MainScanViewController.paymentData.staticQR = qrResponse.ISOQR
            MainScanViewController.paymentData.orderId = qrResponse.TxnId
            
            self.gotoNextPage()
            
        }
        
         }else{
            
            
            self.gotoNextPage()

        }
    }

    public func gotoNextPage(){
        UIApplication.topViewController()?.view.hideLoadingIndicator()

        let psb = UIStoryboard.init(name: "PayButtonBoard", bundle: nil)
        let vc :MainScanViewController = psb.instantiateViewController(withIdentifier: "MainScanViewController") as! MainScanViewController
        vc.delegate = self.delegate
        if UIApplication.topViewController()?.navigationController != nil {
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            vc.fromNav = true
        }else{
            vc.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            vc.fromNav = false
            
        }
    }
}
public protocol PaymentDelegate: class {
    func finishSdkPayment(_ transactionStatusResponse: TransactionStatusResponse )
}
