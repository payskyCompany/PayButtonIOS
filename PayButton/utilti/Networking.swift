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






//Problem solved! First off i wasn't using the string function properly... I ended up with this:
//
//let hmacResult:String = "myStringToHMAC".hmac(HMACAlgorithm.SHA1, key: "myKey")
//Then I had forgotten I needed to base64 encode the hmac result. So i modified the string function linked in my question to...

enum HMACAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func toCCHmacAlgorithm() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    func hmac(algorithm: HMACAlgorithm, key: String) -> String {
        //let cKey = key.cString(using: String.Encoding.utf8)
        let hexkey = hexStringToBytes(key)
        
        
        let data = Data(bytes: hexkey!)
        let cKey = String(data: data, encoding: .utf8)
        

        
        let cData = self.cString(using: String.Encoding.utf8)
        var result = [CUnsignedChar](repeating: 0, count: Int(algorithm.digestLength()))
        CCHmac(algorithm.toCCHmacAlgorithm(), cKey!, strlen(cKey!), cData!, strlen(cData!), &result)
        var hmacData:NSData = NSData(bytes: result, length: (Int(algorithm.digestLength())))

        let datafroNS = Data(referencing: hmacData)
       //var hmacBase64 =  hmacData.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        //return String(hmacBase64)
        var hexSecureHash = datafroNS.hexEncodedString(options: .upperCase)
        return hexSecureHash
    }
}

func hexStringToBytes(_ string: String) -> [UInt8]? {
    let length = string.characters.count
    if length & 1 != 0 {
        return nil
    }
    var bytes = [UInt8]()
    bytes.reserveCapacity(length/2)
    var index = string.startIndex
    for _ in 0..<length/2 {
        let nextIndex = string.index(index, offsetBy: 2)
        if let b = UInt8(string[index..<nextIndex], radix: 16) {
            bytes.append(b)
        } else {
            return nil
        }
        index = nextIndex
    }
    return bytes
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
