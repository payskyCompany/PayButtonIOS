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
    
    print("  URL: \(path)")
    
    if !path.contains(ApiURL.GenerateQR) && !path.contains(ApiURL.CheckTxnStatus) {
        UIApplication.topViewController()?.view.showLoadingIndicator()
    } else {
        print("  URL: \(path)")
        print(" REQUEST: \(String(describing: parameters?.toJsonString()))")
    }
    
    AF.request(ApiURL.MAIN_API_LINK + path, method: method!, parameters: convertToDictionary(text: (parameters?.toJsonString())!), encoding: JSONEncoding.default)
        .responseString { response  in
            switch response.result {
            case .success(let value):
                if path.contains(ApiURL.CheckPaymentMethod) {
                    UIApplication.topViewController()?.view.hideLoadingIndicator()
                }
                else if !path.contains(ApiURL.GenerateQR) && !path.contains(ApiURL.CheckTxnStatus) {
                    UIApplication.topViewController()?.view.hideLoadingIndicator()
                }
                
                if value != nil {
                    let statusCode = response.response?.statusCode
                    if !path.contains(ApiURL.GenerateQR) && !path.contains(ApiURL.CheckTxnStatus) {
                        print("RESPONSE: \(String(describing: value))")
                    }
                    if (statusCode == 400){
                        let res = BaseResponse(json: value)
                        res.Success = false
                        res.Message = res.ModelState
                        UIApplication.topViewController()?.view.hideLoadingIndicator()
                        completion(res.toJsonString())
                        return
                    }
                    completion(value)
                }
            case .failure(let error):
                let res = BaseResponse();
                UIApplication.topViewController()?.view.hideLoadingIndicator()
                res.Success = false
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
