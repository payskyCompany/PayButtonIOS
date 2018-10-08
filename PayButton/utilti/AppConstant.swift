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
    static var MAIN_API_LINK = "http://197.50.37.116:5050/api/";
    static var REGISTER = MAIN_API_LINK + "Account/Register";
    static var LOGIN = MAIN_API_LINK + "Account/Login";
    static var CARD_LIST = MAIN_API_LINK + "tokenization/GetPaymentToken";
    static var ADD_CARD = MAIN_API_LINK + "tokenization/CreatePaymentToken";
    static var DELETE_CARD = MAIN_API_LINK + "tokenization/RemovePaymentToken/";
    static var PARSQR = MAIN_API_LINK + "tokenization/ParseISOQR";
    static var PAY = MAIN_API_LINK + "tokenization/PayByToken";
      static var SET_AS_DEFAULT = MAIN_API_LINK + "tokenization/ChangePaymentTokenDefault/";

}

