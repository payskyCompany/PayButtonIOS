//
//  ApiManger.swift
//  tokenization
//
//  Created by AMR on 7/3/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import Foundation
import Alamofire

public class ApiManger {

    
    
     static func  PayByCard( PAN:String,  cvv2:String,
                             DateExpiration:String,
                             completion: @escaping (TransactionStatusResponse) -> ()){
        let addcardRequest = ManualPaymentRequest()
        addcardRequest.PAN = PAN
        addcardRequest.cvv2 = cvv2
        addcardRequest.DateExpiration = DateExpiration
        addcardRequest.AmountTrxn = String ( MainScanViewController.paymentData.amount )
        executePOST(path: ApiURL.PayByCard,parameters: addcardRequest, completion: { (value) in
            completion(   TransactionStatusResponse(json: value))
        } )
    }
    
    static func  PayByCard( addcardRequest:ManualPaymentRequest,
                            completion: @escaping (TransactionStatusResponse) -> ()){
     
        executePOST(path: ApiURL.PayByCard,parameters: addcardRequest, completion: { (value) in
            completion(   TransactionStatusResponse(json: value))
        } )
    }
    
    static func  Compose3DSTransaction( addcardRequest:ManualPaymentRequest,
                            completion: @escaping (Compose3DSTransactionResponse) -> ()){
        
        
        executePOST(path: ApiURL.Compose3DSTransaction,parameters: addcardRequest, completion: { (value) in
            completion(   Compose3DSTransactionResponse(json: value))
        } )
    }
    
    
    

    

    
    
    static func  Process3DSTransaction( ThreeDSResponseData : String , GatewayType : Int,
                                        completion: @escaping (Process3DSTransactionResonse) -> ()){
        let addcardRequest = Process3DSTransactionRequest()
    addcardRequest.GatewayType = GatewayType
        addcardRequest.ThreeDSResponseData = ThreeDSResponseData
        executePOST(path: ApiURL.Process3DSTransaction,parameters: addcardRequest, completion: { (value) in
            completion(   Process3DSTransactionResonse(json: value))
        } )
    }
    
    
    
    
    
    static func  sendEmail(EmailTo:String,  externalReceiptNo:String,  transactionChannel:String,
                            completion: @escaping (BaseResponse) -> ()){
        
        let addcardRequest = SendReceiptByMailRequest()
        addcardRequest.EmailTo = EmailTo
        addcardRequest.TransactionChannel = transactionChannel
        addcardRequest.ExternalReceiptNo = externalReceiptNo
        addcardRequest.TxnId = Int ( externalReceiptNo )!

        executePOST(path: ApiURL.SendReceiptToEmail,parameters: addcardRequest, completion: { (value) in
            completion(   BaseResponse(json: value))
        } )
    }
    
    
    static func  generateQrCode(
                           completion: @escaping (QrGenratorResponse) -> ()){
        let addcardRequest = QrGenratorRequest()
        addcardRequest.AmountTrxn = MainScanViewController.paymentData.amount
        executePOST(path: ApiURL.GenerateQR,parameters: addcardRequest, completion: { (value) in
            completion(   QrGenratorResponse(json: value))
        } )
    }
    
    
    static func  checkTransactionPaymentStatus(transactionId:Int,
        completion: @escaping (TransactionStatusResponse) -> ()){
        let addcardRequest = BaseResponse()
        addcardRequest.TxnId =   transactionId 
        executePOST(path: ApiURL.CheckTxnStatus,parameters: addcardRequest, completion: { (value) in
            completion(   TransactionStatusResponse(json: value))
        } )
    }
    
    
    
    static func  requestToPay(MobileNumber:String,
                                               completion: @escaping (BaseResponse) -> ()){
        let addcardRequest = SmsPaymentRequest()
        addcardRequest.TxnId = MainScanViewController.paymentData.orderId
        addcardRequest.MobileNumber = MobileNumber
        addcardRequest.ISOQR = MainScanViewController.paymentData.staticQR
        executePOST(path: ApiURL.RequestToPay,parameters: addcardRequest, completion: { (value) in
            completion(   BaseResponse(json: value))
        } )
    }
    
    
    
    
    
    
    
    static func  CheckPaymentMethod(
                              completion: @escaping (PaymentMethodResponse) -> ()){
        let addcardRequest = PaymentMethodRequest()
        executePOST(path: ApiURL.CheckPaymentMethod,parameters: addcardRequest, completion: { (value) in
            completion(   PaymentMethodResponse(json: value))
        } )
    }
    
    
    
    
    
    
    
    
    
}
