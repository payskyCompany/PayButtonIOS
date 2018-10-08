//
//  AlertDialogViewController.swift
//  tokenization
//
//  Created by AMR on 7/4/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit

class RequestMoneyViewController: BasePaymentViewController {

    
    var SendHandler: (()->Void)? = nil

    
    @IBOutlet weak var HeaderLabel: UILabel!
    
    @IBOutlet weak var MessageLabel: UILabel!
    
    @IBOutlet weak var MobileNumber: UITextField!
    
    

    
    
    @IBOutlet weak var HeaderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        HeaderLabel.text = NSLocalizedString("request_payment",bundle :  self.bandle,comment: "")
        MessageLabel.text =  NSLocalizedString("enter_mobile_number",bundle :  self.bandle,comment: "")
        
        MobileNumber.setTextFieldStyle( NSLocalizedString("mobile_number",bundle :  self.bandle,comment: "") , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.clear, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 18,padding: 10)

        
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func okAction(_ sender: Any) {
        if SendHandler == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            SendHandler!()
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}



