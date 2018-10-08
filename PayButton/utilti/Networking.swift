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



func executePOST(path:String,method:HTTPMethod? = .post, parameters: BaseResponse? = BaseResponse() , headerToken:String? = "" , headerName:String? = "ApiKey"
   , completion: @escaping (String) -> () ) {
    
    
    
    
    if method == .get || method == .delete || method == .put {
        executeGetORdelete(path: path, method: method, headerToken: headerToken, headerName: headerName, completion: { (string) in
            completion(string)
            
        })
        
     return
    }
        
    UIApplication.topViewController()?.view.showLoadingIndicator()


    let UserHeader :HTTPHeaders = [ headerName!: headerToken! ]
    print("executePOST = URL: \(path)")
    print("executePOST =REQUEST: \(String(describing: parameters?.toJsonString()))")
    Alamofire.request(path, method: method!, parameters: convertToDictionary(text: (parameters?.toJsonString())!), encoding: JSONEncoding.default , headers:UserHeader)
        .responseString { response  in
            
            
            
            UIApplication.topViewController()?.view.hideLoadingIndicator()

            switch response.result {
            case .success:
                if response.result.value != nil {
                    let statusCode = response.response?.statusCode
                      print("executePOST = RESPONSE: \(String(describing: response.result.value))")
                    
                    
                    
                    if (statusCode == 400){
                        let res = BaseResponse(json: response.result.value!)
                        res.sucssues = false
                        //res.Message = res.ModelState
                        
                        completion(res.toJsonString())

                        return
                    }
                    completion(response.result.value!)
                    
                }
            case .failure(let error):
                completion("")
                print(error)
            }
    }
    
    
    
    
    }




func executeGetORdelete(path:String, method:HTTPMethod? = .get, headerToken:String? = "" , headerName:String? = "ApiKey"
    , completion: @escaping (String) -> () ) {
    
    UIApplication.topViewController()?.view.showLoadingIndicator()
    
    
    let UserHeader :HTTPHeaders = [ headerName!: headerToken! ]
    print("executePOST = URL: \(path)")

    Alamofire.request(path, method: method!, headers:UserHeader)
        .responseString { response  in
            UIApplication.topViewController()?.view.hideLoadingIndicator()
            
            switch response.result {
            case .success:
                if response.result.value != nil {
                    let statusCode = response.response?.statusCode
                    print("executeGet = RESPONSE: \(String(describing: response.result.value))")
                    
                    
                    
                    if (statusCode == 400){
                        let res = BaseResponse(json: response.result.value!)
                        res.sucssues = false
                        res.Message = res.ModelState
                        
                        completion(res.toJsonString())
                        
                        return
                    }
                    completion(response.result.value!)
                    
                }
            case .failure(let error):
                completion("")
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





