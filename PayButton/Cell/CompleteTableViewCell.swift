//
//  CompleteTableViewCell.swift
//  PayButton
//
//  Created by AMR on 10/6/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit
import MOLH

class CompleteTableViewCell: BaseUITableViewCell {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.frame.origin.y == 0 {
                self.frame.origin.y -= keyboardSize.height
            }
        }
    }
   
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.frame.origin.y != 0 {
            self.frame.origin.y = 0
        }
    }
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    @IBOutlet weak var StackComplete: UIStackView!
    
    
    @IBOutlet weak var SendReciptLabel: UILabel!
    @IBOutlet weak var TransNumber: UILabel!
    @IBOutlet weak var AuthCode: UILabel!
    @IBOutlet weak var ImageSucces: UIImageView!
    
    @IBOutlet weak var TextStatus: UILabel!
    
    @IBOutlet weak var ErrorMessage: UILabel!

    
    
    @IBOutlet weak var SendMail: UIButton!
    
    
    @IBOutlet weak var EmailED: UITextField!
    
    
    @IBOutlet weak var CloseBtn: UIButton!
    
    @IBOutlet weak var TryBtn: UIButton!
    
    @IBOutlet weak var EmailLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       

        self.backgroundColor = UIColor.clear
        
   
        if MOLHLanguage.currentAppleLanguage() != "ar" {
            EmailED.textAlignment = .left
        }
        else {
            EmailED.textAlignment = .right
        }
        
        TextStatus.text =  "transaction_success".localizedPaySky()
 TransNumber.text =  "trx_id".localizedPaySky()
        AuthCode.text =  "auth_number".localizedPaySky()
        
        SendReciptLabel.text =  "send_notification".localizedPaySky()
        
        CloseBtn.setTitle("close".localizedPaySky(), for: .normal)
        
        SendMail.setTitle("send".localizedPaySky(), for: .normal)
        TryBtn.setTitle("try_again".localizedPaySky(), for: .normal)
        EmailED.setTextFieldStyle( "email_hint".localizedPaySky() , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.clear, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 30,padding: 10,keyboardType: UIKeyboardType.default)
        CloseBtn.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        TryBtn.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        
   
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func SendEmailAction(_ sender: Any) {
        self.endEditing(true)

        
        if (EmailED.text?.isEmpty)! {
            UIApplication.topViewController()?.view.makeToast(  "please entre your mail".localizedPaySky()  )
            return
        } 
        
        if !(EmailED.text?.isValidEmail())! {
            UIApplication.topViewController()?.view.makeToast(  "please entre valid mail".localizedPaySky())
            return
        }
        
        ApiManger.sendEmail(EmailTo: EmailED.text!, externalReceiptNo: self.transactionStatusResponse.ReceiptNumber, transactionChannel:  self.transactionStatusResponse.FROMWHERE) { (baseresponse) in
            if baseresponse.Success {
                  self.EmailLabel.isHidden = false
                self.EmailLabel.text = "email_send_to".localizedPaySky() + self.EmailED.text!
            }else{
                
                       UIApplication.topViewController()?.view.makeToast(baseresponse.Message)
            }
        }
    }
    
    var transactionStatusResponse: TransactionStatusResponse =  TransactionStatusResponse()
  override  func setData(transactionStatusResponse: TransactionStatusResponse) {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    self.addGestureRecognizer(tap)
     NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    self.transactionStatusResponse = transactionStatusResponse
    if transactionStatusResponse.Success {
        self.StackComplete.isHidden = false
        self.TryBtn.isHidden = true
  
        let string = "transaction_success".localizedPaySky()
        var stringArr = string.components(separatedBy: " ")
        let   myMutableString = NSMutableAttributedString(string: string, attributes:nil)
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor , value:  Global.hexStringToUIColor("#00BFA5"),
                                     range: NSRange(location:stringArr[0].count,length: stringArr[1].count+1))
        TextStatus.attributedText = myMutableString
        
        var TranNumber = ""
        var Auth = ""
        if !transactionStatusResponse.TransactionNo.isEmpty {
            TranNumber = transactionStatusResponse.TransactionNo
        }else{
            TranNumber = transactionStatusResponse.SystemReference
        }
        
        if !transactionStatusResponse.TransactionNo.isEmpty {
            Auth = transactionStatusResponse.AuthCode
        }else{
            Auth = transactionStatusResponse.NetworkReference
        }
        
        
        
        if Auth.count > 30 {
       
          Auth =   String ( Auth.suffix(6) )
        }
        
        
        TransNumber.text =  "trx_id".localizedPaySky()  + " #" + TranNumber
        AuthCode.text =  "auth_number".localizedPaySky() + " #"  + Auth
        self.ImageSucces.image = #imageLiteral(resourceName: "TransactionApproved")
        ErrorMessage.isHidden = true

    }else {
        self.StackComplete.isHidden = true
        self.TryBtn.isHidden = false
        self.ImageSucces.image = #imageLiteral(resourceName: "TransactionDeclined")
    
        
        let string = "transaction_declined".localizedPaySky()
        var stringArr = string.components(separatedBy: " ")
        let   myMutableString = NSMutableAttributedString(string: string, attributes:nil)
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor , value:  Global.hexStringToUIColor("#C23A2C"),
                                     range: NSRange(location:stringArr[0].count,length: stringArr[1].count+1))
        TextStatus.attributedText = myMutableString
ErrorMessage.isHidden = false
    ErrorMessage.text =  transactionStatusResponse.Message

        
    }
//    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
//        self.delegateActions?.completeRequest(transactionStatusResponse: self.transactionStatusResponse)
//
//    })
    }
    
    @IBAction func Close(_ sender: Any) {
        self.endEditing(true)
        
        delegateActions?.completeRequest(transactionStatusResponse: self.transactionStatusResponse)
    }
    
    
    @IBAction func TryAction(_ sender: Any) {
    delegateActions?.tryAgin()

    }
    
    
    
}






