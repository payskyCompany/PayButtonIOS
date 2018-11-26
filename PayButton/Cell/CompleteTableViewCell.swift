//
//  CompleteTableViewCell.swift
//  PayButton
//
//  Created by AMR on 10/6/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit

class CompleteTableViewCell: BaseUITableViewCell {
    
    
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
        
   
        
        
        TextStatus.text =  NSLocalizedString("transaction_success",bundle :  self.bandle,comment: "")
 TransNumber.text =  NSLocalizedString("trx_id",bundle :  self.bandle,comment: "")
        AuthCode.text =  NSLocalizedString("auth_number",bundle :  self.bandle,comment: "")
        
        SendReciptLabel.text =  NSLocalizedString("send_notification",bundle :  self.bandle,comment: "")
        
        CloseBtn.setTitle(NSLocalizedString("close",bundle :  self.bandle,comment: ""), for: .normal)
        
        SendMail.setTitle(NSLocalizedString("send",bundle :  self.bandle,comment: ""), for: .normal)
        TryBtn.setTitle(NSLocalizedString("try_again",bundle :  self.bandle,comment: ""), for: .normal)
        EmailED.setTextFieldStyle( NSLocalizedString("email_hint",bundle :  self.bandle,comment: "") , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.clear, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 30,padding: 10,keyboardType: UIKeyboardType.default)
        CloseBtn.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        TryBtn.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        
   
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func SendEmailAction(_ sender: Any) {
        
        
        if (EmailED.text?.isEmpty)! {
            UIApplication.topViewController()?.view.makeToast( NSLocalizedString("please entre your mail",bundle :  self.bandle,comment: ""))
            return
        }
        
        if !(EmailED.text?.isValidEmail())! {
            UIApplication.topViewController()?.view.makeToast( NSLocalizedString("please entre valid mail",bundle :  self.bandle,comment: ""))
            return
        }
        
        ApiManger.sendEmail(EmailTo: EmailED.text!, externalReceiptNo: self.transactionStatusResponse.ReceiptNumber, transactionChannel:  self.transactionStatusResponse.FROMWHERE) { (baseresponse) in
            if baseresponse.Success {
                  self.EmailLabel.isHidden = false
                self.EmailLabel.text = NSLocalizedString("email_send_to",bundle :  self.bandle,comment: "") + self.EmailED.text!
            }else{
                
                       UIApplication.topViewController()?.view.makeToast(baseresponse.Message)
            }
        }
    }
    
    var transactionStatusResponse: TransactionStatusResponse =  TransactionStatusResponse()
  override  func setData(transactionStatusResponse: TransactionStatusResponse) {
    self.transactionStatusResponse = transactionStatusResponse
    if transactionStatusResponse.Success {
        self.StackComplete.isHidden = false
        self.TryBtn.isHidden = true
  
        let string = NSLocalizedString("transaction_success",bundle :  self.bandle,comment: "")
        var stringArr = string.components(separatedBy: " ")
        let   myMutableString = NSMutableAttributedString(string: string, attributes:nil)
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor , value:  Global.hexStringToUIColor("#00BFA5"),
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
        
        
        TransNumber.text =  NSLocalizedString("trx_id",bundle :  self.bandle,comment: "")  + " #" + TranNumber
        AuthCode.text =  NSLocalizedString("auth_number",bundle :  self.bandle,comment: "") + " #"  + Auth
        self.ImageSucces.image = #imageLiteral(resourceName: "TransactionApproved")
        ErrorMessage.isHidden = true

    }else {
        self.StackComplete.isHidden = true
        self.TryBtn.isHidden = false
        self.ImageSucces.image = #imageLiteral(resourceName: "TransactionDeclined")
    
        
        let string = NSLocalizedString("transaction_declined",bundle :  self.bandle,comment: "")
        var stringArr = string.components(separatedBy: " ")
        let   myMutableString = NSMutableAttributedString(string: string, attributes:nil)
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor , value:  Global.hexStringToUIColor("#C23A2C"),
                                     range: NSRange(location:stringArr[0].count,length: stringArr[1].count+1))
        TextStatus.attributedText = myMutableString
ErrorMessage.isHidden = false
    ErrorMessage.text =  transactionStatusResponse.Message

        
    }
        
    }
    
    @IBAction func Close(_ sender: Any) {
        
        
        delegateActions?.completeRequest(transactionStatusResponse: self.transactionStatusResponse)
    }
    
    
    @IBAction func TryAction(_ sender: Any) {
    delegateActions?.tryAgin()

    }
    
    
    
}
