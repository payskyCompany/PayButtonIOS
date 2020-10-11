//
//  CardTableViewCell.swift
//  PayButton
//
//  Created by AMR on 10/4/18.
//  Copyright © 2018 Paysky. All rights reserved.
//


import UIKit
import MOLH
import PayCardsRecognizer
//CardIOPaymentViewControllerDelegate

import PopupDialog
import AVFoundation
class CardTableViewCell: BaseUITableViewCell , MaskedTextFieldDelegateListener ,
ScanCardtDelegate  {
    
    var PreviousLength = 0
    @IBAction func ExDateChanges(_ sender: UITextField) {
        validDate = false;
        if PreviousLength > DateTF.text!.count {
            PreviousLength = DateTF.text!.count
            return
        }
        if DateTF.text!.count == 1 && Int(DateTF.text!)! > 2 {
            DateTF.text! = "0" + DateTF.text! + "/"
        }
        if DateTF.text!.count == 2 && !DateTF.text!.contains("/") {
            if Int(DateTF.text!)! > 12 {
                DateTF.text! = "12/"
            }
            else {
                DateTF.text! = DateTF.text! + "/"
            }
        }
        let val = DateTF.text!.split(separator: "/")
        if DateTF.text!.count == 5 && val.count > 1 {
            if Int(String(val[1] + ""))! > 19 {
                validDate = true;
                                  
            }else{
                validDate = false;
                
            }
        }
        
        PreviousLength = DateTF.text!.count
       
    }
    
    func cardResult(_ result: PayCardsRecognizerResult) {
        
        CardHolderName.text =   result.recognizedHolderName
        
        
        
        let mask: Mask = try! Mask(format: "[0000] [0000] [0000] [0000]")
        let input: String = result.recognizedNumber!
        let maskResult: Mask.Result = mask.apply(
            toText: CaretString(
                string: input,
                caretPosition: input.endIndex
            ),
            autocomplete: true // you may consider disabling autocompletion for your case
        )
        CardNumbeTV.text = maskResult.formattedText.string
        
        self.textField(
            CardNumbeTV,
            didFillMandatoryCharacters : true,
            didExtractValue: result.recognizedNumber ?? ""
        )
        
        
        let data = (result.recognizedExpireDateMonth ?? "") + "/" + (result.recognizedExpireDateYear ?? "")
        let valuedate = (result.recognizedExpireDateMonth ?? "") + (result.recognizedExpireDateYear ?? "")
        
        DateTF.text = data
        self.textField(
            DateTF,
            didFillMandatoryCharacters : true,
            didExtractValue: valuedate
        )
        
        // CVCTF.text = info.cvv
        
        
        
    }
    
    

    @IBAction func ScanCard(_ sender: Any) {

        
        let st = UIStoryboard(name: "PayButtonBoard", bundle: nil)

        let vc :CardScanViewController = st.instantiateViewController(withIdentifier: "CardScanViewController") as! CardScanViewController
        vc.delegate = self.delegate
        vc.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.present(vc, animated: true,completion: nil)
    }
    
    @IBOutlet weak var CVCTF: UITextField!
    @IBOutlet weak var CardNumbeTV: UITextField!
    


    @IBOutlet weak var DateTF: UITextField!
    @IBOutlet weak var CardHolderName: UITextField!
    

    
    
    @IBOutlet weak var ScanBtn: UIButton!
    @IBOutlet weak var SaveCardBtn: UIButton!
    @IBOutlet weak var EnterCardData: UILabel!

    
    var isChecked = true
    var MaskedCreditCard: MaskedTextFieldDelegate!
//    var MaskedDateExpired: MaskedTextFieldDelegate!
    var MaskedCVC: MaskedTextFieldDelegate!
    var HolderName: MaskedTextFieldDelegate!

    
    
    
    var cardNumber = ""
    let creditCardValidator = CreditCardValidator()
    
    var validCard = false ;
    
    var validDate = false ;
    
    
    var delegate: ScanCardtDelegate?

    @IBOutlet weak var BackgroundImage: UIImageView!

    

 
    
    

 
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        SaveCardBtn.setTitle("proceed".localizedPaySky(), for: .normal)
        EnterCardData.text = "enter_card_data".localizedPaySky()

        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            self.ScanBtn.isHidden = false
            
        } else if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.notDetermined {
//            self.ScanBtn.isHidden = true
        }
        
        
        
        
        
        
        
//        IQKeyboardManager.shared.enable = true
//        IQToolbar.appearance().isTranslucent = false
//        IQToolbar.appearance().barTintColor = UIColor.white
//        IQToolbar.appearance().shouldHideToolbarPlaceholder = false
//
//        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localizedPaySky()
//        IQKeyboardManager.shared.toolbarTintColor = UIColor.white
//        IQKeyboardManager.shared.toolbarBarTintColor = PaySkySDKColor.NavColor
//        IQKeyboardManager.shared.placeholderFont = Global.setFont(13)
//
        
        
        SaveCardBtn.backgroundColor = PaySkySDKColor.mainBtnColor
 
        
        
        //4987 6543 2109 8769
        
        SaveCardBtn.layer.cornerRadius = 5
        ScanBtn.imageView?.contentMode = .scaleAspectFit
        CardNumbeTV.setTextFieldStyle( "card_number".localizedPaySky() , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.clear, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 18,padding: 10)
        
        CVCTF.setTextFieldStyle( "cvc".localizedPaySky() , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 4,padding: 4)
        
        

        
        DateTF.setTextFieldStyle("expire_date".localizedPaySky() , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 5,padding: 10)
        
        
        CardHolderName.setTextFieldStyle("name_on_card".localizedPaySky()  , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 10,padding: 10,keyboardType: UIKeyboardType.default)
        
        MaskedCreditCard = MaskedTextFieldDelegate(primaryFormat: "[0000] [0000] [0000] [0000]")
//        MaskedDateExpired = MaskedTextFieldDelegate(primaryFormat: "[0,12]/[00]")
        MaskedCVC = MaskedTextFieldDelegate(primaryFormat: "[000]")
        HolderName  = MaskedTextFieldDelegate(primaryFormat: "[A][--------] [A][---------] [A][---------]")
        
        CardHolderName.delegate =  HolderName
        
        HolderName.listener = self

        MaskedCreditCard.listener = self
//        MaskedDateExpired.listener = self
        MaskedCVC.listener = self

        CardNumbeTV.delegate = MaskedCreditCard
        CardNumbeTV.tag = 1
//        DateTF.delegate = MaskedDateExpired
        CVCTF.delegate = MaskedCVC
        DateTF.tag = 2
        //        CardIOUtilities.preload()
        
        

        
        
        delegate = self
        
        // Initialization code
        

        if MOLHLanguage.currentAppleLanguage() == "en" {
            CVCTF.textAlignment = .left
            CardHolderName.textAlignment = .left
            DateTF.textAlignment = .left
            CardNumbeTV.textAlignment = .left
        }
        else {
            CVCTF.textAlignment = .right
            CardHolderName.textAlignment = .right
            DateTF.textAlignment = .right
            CardNumbeTV.textAlignment = .right
        }
    }
    
    
 
    
    
    
    open func textField(
        _ textField: UITextField,
        didFillMandatoryCharacters complete: Bool,
        didExtractValue value: String
        ) {
        
         textField.text = textField.text?.replacedArabicDigitsWithEnglish
         if  textField.tag  == 1 {

            self.cardNumber = value.replacedArabicDigitsWithEnglish
            
            if let type = creditCardValidator.type(from: value.replacedArabicDigitsWithEnglish) {

                self.validCard = true

                if type.name == "Visa" {
                    self.BackgroundImage.image = #imageLiteral(resourceName: "vi")
                }else if type.name == "Amex"  {
                    self.BackgroundImage.image = #imageLiteral(resourceName: "am")
                }else if type.name == "MasterCard"  {
                    self.BackgroundImage.image = #imageLiteral(resourceName: "mc")
                }else if type.name == "Maestro"  {
                    self.BackgroundImage.image = #imageLiteral(resourceName: "Maestro")
                }else if type.name == "Diners Club"  {
                    self.BackgroundImage.image = #imageLiteral(resourceName: "dc")
                }else if type.name == "JCB"  {
                    self.BackgroundImage.image = #imageLiteral(resourceName: "jcb")
                }else if type.name == "Discover"  {
                    self.BackgroundImage.image = #imageLiteral(resourceName: "ds")
                }else if type.name == "UnionPay"  {
                    self.BackgroundImage.image = #imageLiteral(resourceName: "UnionPay")
                }else if type.name == "Mir"  {
                    self.BackgroundImage.image = #imageLiteral(resourceName: "Mir")
                    
                }else  if type.name == "Meza"{
                    self.BackgroundImage.image =  #imageLiteral(resourceName: "miza_logo")
                    
                
                
                
                } else {
                    self.validCard = false

                    self.BackgroundImage.image = #imageLiteral(resourceName: "card_icon")
                }
                
                
                
                
            }else {
                self.validCard = false

                self.BackgroundImage.image = #imageLiteral(resourceName: "card_icon")
            }
               if value.count == 16 {
                if self.creditCardValidator.validate(number:value.replacedArabicDigitsWithEnglish) {
                // Card number is valid
                
                self.validCard = true

                
                
            }else {
                self.validCard = false
                UIApplication.topViewController()?.view.endEditing(true)
                UIApplication.topViewController()?.view.makeToast("cardNumber_VALID".localizedPaySky() )


            }
            }
            
            
        }else if  textField.tag  == 2 {
            
            if value.count == 4 {
                self.year  = String(value.replacedArabicDigitsWithEnglish.suffix(2))
                self.month  = String(value.replacedArabicDigitsWithEnglish.prefix(2))
                
                if Int ( self.year)! > 18 && Int ( self.month)! < 13  {
                    validDate = true;
                    
                }else{
                    validDate = false;
                    
                }
                
                
            }else{
                validDate = false;
            }
            
        }
        
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var year = ""
    var month = ""

    
    @IBAction func SendMoneyByCard(_ sender: Any) {
        UIApplication.topViewController()?.view.endEditing(true)

        if self.cardNumber.isEmpty {
            UIApplication.topViewController()?.view.makeToast("cardNumber_NOTVALID".localizedPaySky() )
            
            return;
        }
        
        
        
        if   !self.validCard {
            UIApplication.topViewController()?.view.makeToast("cardNumber_VALID".localizedPaySky() )
            
            return;
        }
        if   cardNumber.replacingOccurrences(of: " ", with: "").count != 16 && cardNumber.replacingOccurrences(of: " ", with: "").count != 19 {
                   UIApplication.topViewController()?.view.makeToast("cardNumber_VALID".localizedPaySky() )
                   
                   return;
               }

        
        if (self.CardHolderName.text?.isEmpty)! {
            
            UIApplication.topViewController()?.view.makeToast("CardHolderNameRequird".localizedPaySky() )
            
            return;
        }
        

        
        if (self.DateTF.text?.isEmpty)! {
            UIApplication.topViewController()?.view.makeToast(
                "DateTF_NOTVALID".localizedPaySky() )
            return;
        }
        
        if  self.DateTF.text?.count != 5 {
            UIApplication.topViewController()?.view.makeToast(
                "DateTF_NOTVALID_AC".localizedPaySky() )
            
            return;
        }
        
        
        
        if  !validDate {
            UIApplication.topViewController()?.view.makeToast(
                "invalid_expire_date_date".localizedPaySky() )
            return;
        }
        
        
        
        if (self.CVCTF.text?.isEmpty)! {
            
            UIApplication.topViewController()?.view.makeToast("CVCTF_NOTVALID".localizedPaySky() )
            
            return;
        }
        if self.CVCTF.text!.count != 3 {
            
            UIApplication.topViewController()?.view.makeToast("CVCTF_NOTVALID_LENGTH".localizedPaySky() )
            
            return;
        }
        
        let val = DateTF.text!.split(separator: "/")
        let YearMonth = val[1] + val[0]

        let addcardRequest = ManualPaymentRequest()
        addcardRequest.PAN = self.cardNumber
        addcardRequest.CardHolderName = self.CardHolderName.text ?? ""

        addcardRequest.CVV2 =  self.CVCTF.text!
        addcardRequest.DateExpiration = String(YearMonth)
        addcardRequest.AmountTrxn = String ( MainScanViewController.paymentData.amount )
 
        ApiManger.PayByCard(CardHolderName : self.CardHolderName.text! , PAN: self.cardNumber, cvv2: self.CVCTF.text!, DateExpiration: String(YearMonth)) { (transactionStatusResponse) in
                
                      if transactionStatusResponse.Success {
                
                if transactionStatusResponse.ChallengeRequired {
                    
                    
                    self.delegateActions?.openWebView(compose3DSTransactionResponse: transactionStatusResponse, manualPaymentRequest: addcardRequest)
                    
                    
                }else {
                    
                    
                    transactionStatusResponse.FROMWHERE = "Card"
                    self.delegateActions?.SaveCard(transactionStatusResponse: transactionStatusResponse)
                }
                      }else {
                                     UIApplication.topViewController()?.view.makeToast(transactionStatusResponse.Message)
                           }
          
                
                
            }
            
            
     //   }
        

        
    }
    
    
 
    
}
