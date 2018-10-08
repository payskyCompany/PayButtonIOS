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
//    public static func registerUser(merchantToken:String, completion: @escaping (RegisterResponse) -> ()){
//
//        
//        executePOST(path: ApiURL.REGISTER,headerToken:merchantToken, completion: { (value) in
//            completion(    RegisterResponse(json: value))
//        } )
//        
//       
//    }
//    
//    
//    
//    public static func loginUser( userId:String,validationCode :String, completion: @escaping (LoginResponse) -> ()){
//
//        let loginUser =  loginUserRequest()
//        loginUser.UserName = userId
//        loginUser.Password = validationCode
//
//        
//        executePOST(path: ApiURL.LOGIN,parameters: loginUser , completion: { (value) in
//            completion(    LoginResponse(json: value))
//        } )
//        
//        
//        
//    }
//    
//    
//    
//    static func getCardList(token:String, completion: @escaping ([CardListResponse]) -> ()){
//
//        executePOST(path: ApiURL.CARD_LIST,method: .get ,  headerToken:"Bearer " + token , headerName : "Authorization", completion: { (value) in
//            completion(    [CardListResponse](json: value))
//        } )
//        
//
//        
//    }
//    
//    
//    
//     static func  addCard( userToken:String,  tokenName:String,  isDefault:Bool,  cardNumber:String,
//     cardHolderName:String,  ccv:String,  expireDate:String , completion: @escaping (BaseResponse) -> ()){
//        UIApplication.topViewController()?.view.showLoadingIndicator()
//
//        let addcardRequest = addCardRequest()
//        addcardRequest.TokenName = tokenName
//        addcardRequest.IsDefault = isDefault
//        addcardRequest.CardNumber = cardNumber
//        addcardRequest.CardHolderName = cardHolderName
//        addcardRequest.CVV = ccv
//        addcardRequest.ExpDate = expireDate
//        
//        
//        executePOST(path: ApiURL.ADD_CARD,parameters: addcardRequest,  headerToken:"Bearer " + userToken , headerName : "Authorization", completion: { (value) in
//            completion(   BaseResponse(json: value))
//        } )
//        
//        
//        
//
//    
//    }
//    
//    
//    
//    
//    
//    
//    
//    static func  deleteCard( userToken:String,  cardtoken:String, completion: @escaping (BaseResponse) -> ()){
//
//        
//
//        
//        executePOST(path: ApiURL.DELETE_CARD + cardtoken,method: .delete, headerToken:"Bearer " + userToken , headerName : "Authorization", completion: { (value) in
//            completion(   BaseResponse(json: value))
//        } )
//        
//        
//        
//  
//        
//    }
//    
//    
//    static func  setCardAsDefault( userToken:String,  cardtoken:String, completion: @escaping (BaseResponse) -> ()){
//        
//        
//        
//        
//        executePOST(path: ApiURL.SET_AS_DEFAULT+cardtoken ,method: .put, headerToken:"Bearer " + userToken , headerName : "Authorization", completion: { (value) in
//            completion(   BaseResponse(json: value))
//        } )
//        
//        
//        
//        
//        
//    }
//    
//    
//    
//    
//    
//    
//    static func  parseQR( userToken:String,  qrString:String, completion: @escaping (QrResponse) -> ()){
//        let addcardRequest = parseQrRequest()
//        addcardRequest.IsoQR = qrString
//
//        
//        executePOST(path: ApiURL.PARSQR,parameters: addcardRequest, headerToken:"Bearer " + userToken , headerName : "Authorization", completion: { (value) in
//            completion(   QrResponse(json: value))
//        } )
//        
//        
//        
//        
//        
//        
//        
//    }
//    
// 
//    static func  payNow( userToken:String,  token:String,    merchentId:String,
//                          TerminalId:String,  amount:Int,  orderId:String , completion: @escaping (PayResponse) -> ()){
//
//        
//        let addcardRequest = PayRequest()
//        addcardRequest.Token = token
//        addcardRequest.MerchantId = merchentId
//        addcardRequest.Amount = amount
//        addcardRequest.OrderId = orderId
//        addcardRequest.TerminalId = TerminalId
//        
//        
//        
//        executePOST(path: ApiURL.PAY,parameters: addcardRequest, headerToken:"Bearer " + userToken , headerName : "Authorization", completion: { (value) in
//            completion(   PayResponse(json: value))
//        } )
//        
//        
//        
//       
//        
//        
//        
//    }
    
    
}
