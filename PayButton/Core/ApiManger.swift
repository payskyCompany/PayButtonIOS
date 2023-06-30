//
//  ApiManger.swift
//  PayButton
//
//  Created by AMR on 7/3/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import Foundation
import Alamofire

public class ApiManger {

    static func PayByCard(CardHolderName :String,
                          PAN:String,
                          cvv2:String,
                          DateExpiration:String,
                          completion: @escaping (TransactionStatusResponse) -> ()) {
        let addcardRequest = ManualPaymentRequest()
        addcardRequest.PAN = PAN
        addcardRequest.cvv2 = cvv2
        addcardRequest.CardHolderName = CardHolderName
        addcardRequest.DateExpiration = DateExpiration
        addcardRequest.AmountTrxn = NSDecimalNumber(decimal: Decimal(MainScanViewController.paymentData.amount)).stringValue
        addcardRequest.CardAcceptorIDcode = String(MainScanViewController.paymentData.merchantId)
        addcardRequest.CardAcceptorTerminalID = String(MainScanViewController.paymentData.terminalId)

        debugPrint(addcardRequest)

        executePOST(path: ApiURL.PayByCard, parameters: addcardRequest, completion: { (value) in
            completion(TransactionStatusResponse(json: value))
        })
    }

    static func PayByCard(addcardRequest: ManualPaymentRequest,
                            completion: @escaping (TransactionStatusResponse) -> ()) {
        addcardRequest.CardAcceptorIDcode = String(MainScanViewController.paymentData.merchantId)
        addcardRequest.CardAcceptorTerminalID = String(MainScanViewController.paymentData.terminalId)
        executePOST(path: ApiURL.PayByCard, parameters: addcardRequest, completion: { (value) in
            completion(TransactionStatusResponse(json: value))
        })
    }

    static func sendEmail(emailTo:String,
                          externalReceiptNo:String,
                          transactionChannel:String,
                          transactionId: String,
                          completion: @escaping (BaseResponse) -> ()) {
        let sendEmailRequest = SendReceiptByMailRequest()
        sendEmailRequest.EmailTo = emailTo
        sendEmailRequest.TransactionChannel = transactionChannel
        sendEmailRequest.ExternalReceiptNo = externalReceiptNo
        sendEmailRequest.TransactionId = transactionId
        executePOST(path: ApiURL.SendReceiptToEmail, parameters: sendEmailRequest, completion: { (value) in
            debugPrint(value)
            completion(BaseResponse(json: value))
        })
    }

    static func generateQrCode(completion: @escaping (QrGenratorResponse) -> ()) {
        let qrGenratorRequest = QrGenratorRequest()
        qrGenratorRequest.AmountTrxn = Int(MainScanViewController.paymentData.amount)
        executePOST(path: ApiURL.GenerateQR, parameters: qrGenratorRequest, completion: { (value) in
            completion(QrGenratorResponse(json: value))
        })
    }

    static func checkTransactionPaymentStatus(transactionId:Int,
                                               completion: @escaping (TransactionStatusResponse) -> ()) {
        let checkTrxnStatusRequest = BaseResponse()
        checkTrxnStatusRequest.TxnId = transactionId
        executePOST(path: ApiURL.CheckTxnStatus, parameters: checkTrxnStatusRequest, completion: { (value) in
            completion(TransactionStatusResponse(json: value))
        })
    }

    static func requestToPay(mobileNumber:String, completion: @escaping (BaseResponse) -> ()) {
        let smsPaymentRequest = SmsPaymentRequest()
        smsPaymentRequest.TxnId = MainScanViewController.paymentData.orderId
        smsPaymentRequest.MobileNumber = mobileNumber
        smsPaymentRequest.ISOQR = MainScanViewController.paymentData.staticQR
        executePOST(path: ApiURL.RequestToPay, parameters: smsPaymentRequest, completion: { (value) in
            completion(BaseResponse(json: value))
        })
    }

    static func CheckPaymentMethod(completion: @escaping (PaymentMethodResponse) -> ()) {
//        let checkPaymentMethodRequest =  PaymentMethodRequest()
//        executePOST(path: ApiURL.CheckPaymentMethod,parameters: checkPaymentMethodRequest, completion: { (value) in
//            completion(PaymentMethodResponse(json: value))
//        })
    }

}
