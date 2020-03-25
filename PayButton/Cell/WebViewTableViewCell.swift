//
//  AlertDialogViewController.swift
//  tokenization
//
//  Created by AMR on 7/4/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit
import WebKit

class WebViewTableViewCell: BaseUITableViewCell , WKNavigationDelegate ,WKUIDelegate{

    

    
    
    
    @IBOutlet weak var webView: WKWebView!
    
  
    

    var compose3DSTransactionResponse = TransactionStatusResponse()
    var manualPaymentRequest = ManualPaymentRequest()
    override func awakeFromNib() {

        super.awakeFromNib()
        

        


        self.backgroundColor = UIColor.clear
   
        
        webView.uiDelegate = self
          webView.navigationDelegate = self
webView.isHidden = true
        
    }
    

    
   
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.topViewController()?.view.showLoadingIndicator()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UIApplication.topViewController()?.view.hideLoadingIndicator()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if error._code == -1001 { // TIMED OUT:
            
            // CODE to handle TIMEOUT
            
        } else if error._code == -1003 { // SERVER CANNOT BE FOUND
            
            // CODE to handle SERVER not found
            
        } else if error._code == -1100 { // URL NOT FOUND ON SERVER
            
            // CODE to handle URL not found
            
        }
        UIApplication.topViewController()?.view.hideLoadingIndicator()

        UIApplication.topViewController()?.view.makeToast("Error".localizedPaySky())

        self.delegateActions?.tryAgin()

    }
    
 
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
      
        UIApplication.topViewController()?.view.hideLoadingIndicator()


         self.webView.isHidden = false

        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                   completionHandler: { (html: Any?, error: Error?) in

                                    let htmlAsString =   String(describing: html!)
                                  
                        
                                    if htmlAsString.contains("HTTP Status - 400"){
                                       
                                       
                                        var htmlAss = htmlAsString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)

                                      htmlAss =  htmlAss.replacingOccurrences(of: "HTTP Status - 400", with: "")
                                        htmlAss =  htmlAss.replacingOccurrences(of: "\n", with: "")

                                        UIApplication.topViewController()?.view.makeToast( htmlAss)

                                        

                                        
                                        self.delegateActions?.tryAgin()

                                    }
                                    
        })
        
    }

    
 
    
    override  func openWebView(compose3DSTransactionResponse:TransactionStatusResponse ,
                               manualPaymentRequest : ManualPaymentRequest
        ){
         self.webView.isHidden = true

        self.compose3DSTransactionResponse = compose3DSTransactionResponse
        self.manualPaymentRequest = manualPaymentRequest

        self.webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
 
        
        let request = URLRequest(url: URL(string:compose3DSTransactionResponse.ThreeDSUrl)!)
        
        webView.load(request) //if your `webView` is `UIWebView`
        
    }
    

    var  finalResponse : TransactionStatusResponse =  TransactionStatusResponse ()
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url) {
            
            if self.webView.url != nil {
              
           


                if (self.webView.url?.absoluteString.contains(ApiURL.MAIN_API_LINK.replacingOccurrences(of: "/Cube/PayLink.svc/api/", with: "")))! &&
                    ((self.webView.url?.absoluteString.contains("Success"))!)
                {
                    
                //self.webView.value(forKey: "Status")
               
                if self.webView.url?.queryParameters != nil {
                    
          
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject:  self.webView.url?.queryParameters ?? "", options: .prettyPrinted)
                    // here "jsonData" is the dictionary encoded in JSON data
                    
                    _ = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    // here "decoded" is of type `Any`, decoded from JSON data
                    
                    // you can now cast it with the right type
                    do {
                     

                        let convertedString = String(data: jsonData, encoding: String.Encoding.utf8) // the data will be converted to the string
                        finalResponse =  TransactionStatusResponse(json: convertedString)

                        if finalResponse.IsPaid  {
                            return
                        }

                        print(convertedString)
                        
                        
                        finalResponse.IsPaid = true

                        
                        self.delegateActions?.closeWebView(compose3DSTransactionResponse:  finalResponse)


                    }
                    
                    
                  
                    
                } catch {
                    print(error.localizedDescription)
                }
                          }
            }

            
            }

        }
        
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            // When page load finishes. Should work on each page reload.
            if (self.webView.estimatedProgress == 1) {
              //  print("### EP:", self.webView.estimatedProgress)
            }
        }
    }
    
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        
        let url = NSURLComponents(string: url)!
        
        return
            (url.queryItems! as [NSURLQueryItem])
                .filter({ (item) in item.name == param }).first?
                .value
    }
    
    
    
}


