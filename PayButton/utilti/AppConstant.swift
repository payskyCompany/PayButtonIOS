//
//  AppConstant.swift
//  tokenization
//
//  Created by AMR on 7/3/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import Foundation

class AppConstant {
    static var registrationUserActive1 = "userid"
  
}
public class PaymentParams {
    static var MERCHANT_ID = "merchant_id";
    static var TERMINAL_ID = "terminal_id";
    static var ORDER_ID = "order_id";
    static var AMOUNT = "amount";
    static var CURRENCY_CODE = "currency_code";
    static var MERCHANT_TOKEN = "merchant_token";
}


public class ApiURL {
    //    static var MAIN_API_LINK = "https://197.50.37.116/Cube/PayLink.svc/api/";

    static var MAIN_API_LINK = "https://grey.paysky.io/Cube/PayLink.svc/api/";
    static var GenerateQR = MAIN_API_LINK + "GenerateQR";
    static var CheckTxnStatus = MAIN_API_LINK + "CheckTxnStatus";
    static var SendReceiptToEmail = MAIN_API_LINK + "SendReceiptToEmail";
    static var RequestToPay = MAIN_API_LINK + "RequestToPay";
    static var PayByCard = MAIN_API_LINK + "PayByCard";
    static var CheckPaymentMethod = MAIN_API_LINK + "CheckPaymentMethod";
    static var Compose3DSTransaction = MAIN_API_LINK + "Compose3DSTransaction";
    static var Process3DSTransaction = MAIN_API_LINK + "Process3DSTransaction";

    

    

}

