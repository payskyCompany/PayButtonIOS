//
//  PaymentProcessingPresenter.swift
//  PayButton
//
//  Created by Nada Kamel on 08/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

protocol PaymentProcessingPresenterProtocol: AnyObject {
    var view: PaymentProcessingView? { get set }
    func viewDidLoad()
//    func sendRequest(withURL url: String, parameters: [String: String]?, completion: @escaping ([String: Any]?, Error?) -> Void)
}

class PaymentProcessingPresenter: PaymentProcessingPresenterProtocol {

    weak var view: PaymentProcessingView?

    private var urlPath: String
    
    required init(view: PaymentProcessingView, urlPath: String) {
        self.view = view
        self.urlPath = urlPath
    }
    
    func viewDidLoad() {
        if let url = URL(string: urlPath) {
            view?.loadWebView(withURL: url)
        }
    }
    
    func getUrlPath() -> String {
        return urlPath
    }
    
//    func sendRequest(withURL url: String,ß parameters: [String: String]?, completion: @escaping ([String: Any]?, Error?) -> Void) {
//        var components = URLComponents(string: url)!
//        components.queryItems = parameters?.map { (key, value) in
//            URLQueryItem(name: key, value: value)
//        }
//        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
//        let request = URLRequest(url: components.url!)
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard
//                let data = data,                              // is there data
//                let response = response as? HTTPURLResponse,  // is there HTTP response
//                200 ..< 300 ~= response.statusCode,           // is statusCode 2XX
//                error == nil                                  // was there no error
//            else {
//                completion(nil, error)
//                return
//            }
//
//            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
//            debugPrint(responseObject ?? [""])
//            completion(responseObject, nil)
//        }
//        task.resume()
//    }
    
    
}
