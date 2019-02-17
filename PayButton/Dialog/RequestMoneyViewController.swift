//
//  AlertDialogViewController.swift
//  tokenization
//
//  Created by AMR on 7/4/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit

class RequestMoneyViewController: BasePaymentViewController {

    
    var SendHandler: ((BaseResponse)->Void)? = nil

    
    @IBOutlet weak var HeaderLabel: UILabel!
    
    @IBOutlet weak var MessageLabel: UILabel!
    
    @IBOutlet weak var MobileNumber: UITextField!
    
    

    
    
    @IBOutlet weak var HeaderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        HeaderLabel.text = "request_payment".localizedPaySky()
        MessageLabel.text =  "enter_mobile_number".localizedPaySky()
        
        MobileNumber.setTextFieldStyle( "mobile_number".localizedPaySky() , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.clear, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 18,padding: 10)

        self.view.layer.cornerRadius = PaySkySDKColor.RaduisNumber

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func okAction(_ sender: Any) {
        
        if (self.MobileNumber.text?.isEmpty)! {
            UIApplication.topViewController()?.view.makeToast(
                "mobile_number_valid".localizedPaySky() )
            
            return
        }
        
        
        
        ApiManger.requestToPay( MobileNumber: (self.MobileNumber.text?.replacedArabicDigitsWithEnglish)!) { (base) in
            if base.Success {
                
                if self.SendHandler == nil {
                    self.dismiss(animated: true, completion: nil)
                } else {

                    
                    self.SendHandler!(base)
                }
                
            }else{
                UIApplication.topViewController()?.showAlert( "Error".localizedPaySky(), message:  base.Message)
            }
        }
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}



