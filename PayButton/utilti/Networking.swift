//
//  Networking.swift
//  Imobpay
//
//  Created by Arvind Mehta on 30/05/17.
//  Copyright © 2017 Arvind. All rights reserved.
//

import Foundation
import Alamofire
import UIKit




func executePOST(path:String,method:HTTPMethod? = .post,
                 parameters: BaseResponse? = BaseResponse(), completion: @escaping (String) -> () ) {
    

    

    parameters?.SecureHash  = "DateTimeLocalTrxn=" + (parameters?.DateTimeLocalTrxn)! + "&MerchantId=" + (parameters?.MerchantId)!
    parameters?.SecureHash =    (parameters?.SecureHash)! + "&TerminalId=" + (parameters?.TerminalId)!
    
    parameters?.SecureHash = (parameters?.SecureHash.hmac(algorithm: HMACAlgorithm.SHA256, key: MainScanViewController.paymentData.KEY))!

  
    if !path.contains(ApiURL.GenerateQR)
        &&
        !path.contains(ApiURL.CheckTxnStatus)
    
    {
        
        UIApplication.topViewController()?.view.showLoadingIndicator()
        
    }else {
        print("  URL: \(path)")
        print(" REQUEST: \(String(describing: parameters?.toJsonString()))")
    }

    Alamofire.request(path, method: method!, parameters: convertToDictionary(text: (parameters?.toJsonString())!), encoding: JSONEncoding.default)
        .responseString { response  in

            if !path.contains(ApiURL.GenerateQR)
                &&
                !path.contains(ApiURL.CheckTxnStatus)
                
            {
            UIApplication.topViewController()?.view.hideLoadingIndicator()
            }
            
            switch response.result {
            case .success:
                if response.result.value != nil {
                    let statusCode = response.response?.statusCode
                    if !path.contains(ApiURL.GenerateQR)
                        &&
                        !path.contains(ApiURL.CheckTxnStatus)
                    {
                        
                      print("RESPONSE: \(String(describing: response.result.value))")
                    }
                    if (statusCode == 400){
                        let res = BaseResponse(json: response.result.value!)
                        res.Success = false
                        res.Message = res.ModelState
                        UIApplication.topViewController()?.view.hideLoadingIndicator()
                        completion(res.toJsonString())
                        return
                    }
                    completion(response.result.value!)
                }
            case .failure(let error):
                let res = BaseResponse();
                UIApplication.topViewController()?.view.hideLoadingIndicator()
                res.Success = false
                
                UIApplication.topViewController()?.view.hideLoadingIndicator()
                completion(res.toJsonString())

                print(error)
            }
    }
    
    
    
    
    }





 func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}






//Problem solved! First off i wasn't using the string function properly... I ended up with this:
//
//let hmacResult:String = "myStringToHMAC".hmac(HMACAlgorithm.SHA1, key: "myKey")
//Then I had forgotten I needed to base64 encode the hmac result. So i modified the string function linked in my question to...
