//
//  TransactionStatusResponse.swift
//  PayButton
//
//  Created by AMR on 10/8/18.
//  Copyright © 2018 Paysky. All rights reserved.
//



import Foundation
import EVReflection
public class TransactionStatusResponse: BaseResponse {

  public  var  IsPaid  = false
    public  var  ChallengeRequired  = false

    public var ThreeDSUrl = ""
    
  public  var TransactionNo = ""
  public  var AuthCode = ""
  public  var ReceiptNumber = ""
    
    
    
 public    var SystemReference = ""
 public var NetworkReference = ""

  public  var FROMWHERE = "Card"



}
