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
    
    @IBOutlet weak var SendMail: UIButton!
    
    
    @IBOutlet weak var EmailED: UITextField!
    
    
    @IBOutlet weak var CloseBtn: UIButton!
    
    @IBOutlet weak var TryBtn: UIButton!
    
    var bandle :Bundle!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.clear
        
        let path = Bundle(for: CardTableViewCell.self).path(forResource:"PayButton", ofType: "bundle")
        
        
        if path != nil {
            bandle = Bundle(path: path!) ?? Bundle.main
        }else {
            bandle = Bundle.main
            
        }
        
        TextStatus.text =  NSLocalizedString("transaction_success",bundle :  self.bandle,comment: "")
 TransNumber.text =  NSLocalizedString("trx_id",bundle :  self.bandle,comment: "")
        AuthCode.text =  NSLocalizedString("auth_number",bundle :  self.bandle,comment: "")
        
        SendReciptLabel.text =  NSLocalizedString("send_notification",bundle :  self.bandle,comment: "")
        
        CloseBtn.setTitle(NSLocalizedString("close",bundle :  self.bandle,comment: ""), for: .normal)
        
        SendMail.setTitle(NSLocalizedString("send",bundle :  self.bandle,comment: ""), for: .normal)
        TryBtn.setTitle(NSLocalizedString("try_again",bundle :  self.bandle,comment: ""), for: .normal)
        EmailED.setTextFieldStyle( NSLocalizedString("email_hint",bundle :  self.bandle,comment: "") , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.clear, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 18,padding: 10,keyboardType: UIKeyboardType.default)
        CloseBtn.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        TryBtn.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        
   
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func SendEmailAction(_ sender: Any) {
    }
    
    
  override  func setData(_ selected: Bool) {
    if selected {
        self.StackComplete.isHidden = false
        self.TryBtn.isHidden = true
  
        var string = NSLocalizedString("transaction_success",bundle :  self.bandle,comment: "")
        var stringArr = string.components(separatedBy: " ")
        let   myMutableString = NSMutableAttributedString(string: string, attributes:nil)
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor , value: UIColor.green,
                                     range: NSRange(location:stringArr[0].count,length: stringArr[1].count+1))
        TextStatus.attributedText = myMutableString
        
        TransNumber.text =  NSLocalizedString("trx_id",bundle :  self.bandle,comment: "")  + " #5121321"
        AuthCode.text =  NSLocalizedString("auth_number",bundle :  self.bandle,comment: "") + " #257"
        self.ImageSucces.image = #imageLiteral(resourceName: "TransactionApproved")

    }else {
        self.StackComplete.isHidden = true
        self.TryBtn.isHidden = false
        self.ImageSucces.image = #imageLiteral(resourceName: "TransactionDeclined")
    
        
        var string = NSLocalizedString("transaction_declined",bundle :  self.bandle,comment: "")
        var stringArr = string.components(separatedBy: " ")
        let   myMutableString = NSMutableAttributedString(string: string, attributes:nil)
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor , value: UIColor.red,
                                     range: NSRange(location:stringArr[0].count,length: stringArr[1].count+1))
        TextStatus.attributedText = myMutableString

        TransNumber.text =  NSLocalizedString("trx_id",bundle :  self.bandle,comment: "")  + " #5121321"

        
    }
        
    }
    
    @IBAction func Close(_ sender: Any) {
        delegateActions?.RequestMoney()
    }
    
    
    @IBAction func TryAction(_ sender: Any) {
        delegateActions?.ComfirmBtnClick()

    }
    
    
    
}
