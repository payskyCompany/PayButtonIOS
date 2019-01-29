//
//  CardTableViewCell.swift
//  PayButton
//
//  Created by AMR on 10/4/18.
//  Copyright © 2018 Paysky. All rights reserved.
//


import UIKit
import InputMask
import CreditCardValidator
import PayCardsRecognizer
//CardIOPaymentViewControllerDelegate
import IQKeyboardManagerSwift
import PopupDialog
class CardTableViewCell: BaseUITableViewCell , MaskedTextFieldDelegateListener ,
ScanCardtDelegate {
    
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
    var MaskedDateExpired: MaskedTextFieldDelegate!
    
    
    var cardNumber = ""
    let creditCardValidator = CreditCardValidator()
    
    var validCard = false ;
    
    var validDate = false ;
    
    
    var delegate: ScanCardtDelegate?

    @IBOutlet weak var BackgroundImage: UIImageView!

    

    
    
    

    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        SaveCardBtn.setTitle(NSLocalizedString("proceed",bundle :  self.bandle,comment: ""), for: .normal)
        EnterCardData.text = NSLocalizedString("enter_card_data",bundle :  self.bandle,comment: "")

        
        
        
        
        
        
        IQKeyboardManager.shared.enable = true
        IQToolbar.appearance().isTranslucent = false
        IQToolbar.appearance().barTintColor = UIColor.white
        IQToolbar.appearance().shouldHideToolbarPlaceholder = false
        
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = NSLocalizedString("Done",bundle :  self.bandle,comment: "")
        IQKeyboardManager.shared.toolbarTintColor = UIColor.white
        IQKeyboardManager.shared.toolbarBarTintColor = PaySkySDKColor.NavColor
        IQKeyboardManager.shared.placeholderFont = Global.setFont(13)
        
        
        
        SaveCardBtn.backgroundColor = PaySkySDKColor.mainBtnColor
 
        
        
        //4987654321098769
        
        SaveCardBtn.layer.cornerRadius = 5
        ScanBtn.imageView?.contentMode = .scaleAspectFit
        CardNumbeTV.setTextFieldStyle( NSLocalizedString("card_number",bundle :  self.bandle,comment: "") , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.clear, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 18,padding: 10)
        
        CVCTF.setTextFieldStyle( NSLocalizedString("cvc",bundle :  self.bandle,comment: "") , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 4,padding: 4)
        
        

        
        DateTF.setTextFieldStyle(NSLocalizedString("expire_date",bundle :  self.bandle,comment: "") , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 5,padding: 10)
        
        
        CardHolderName.setTextFieldStyle(NSLocalizedString("name_on_card",bundle :  self.bandle,comment: "")  , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 10,padding: 10,keyboardType: UIKeyboardType.default)
        
        MaskedCreditCard = MaskedTextFieldDelegate(primaryFormat: "[0000] [0000] [0000] [0000]")
        MaskedDateExpired = MaskedTextFieldDelegate(primaryFormat: "[00]/[00]")
        
        
        
        MaskedCreditCard.listener = self
        MaskedDateExpired.listener = self
        
        CardNumbeTV.delegate = MaskedCreditCard
        CardNumbeTV.tag = 1
        DateTF.delegate = MaskedDateExpired
        DateTF.tag = 2
        //        CardIOUtilities.preload()
        
        

        
        
        delegate = self
        
        // Initialization code
    }
    
    
 
    
    
    
    open func textField(
        _ textField: UITextField,
        didFillMandatoryCharacters complete: Bool,
        didExtractValue value: String
        ) {
        if  textField.tag  == 1 {

            self.cardNumber = value
            
            if let type = creditCardValidator.type(from: value) {

                
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
                    
                }else {
                    self.validCard = false

                    self.BackgroundImage.image = #imageLiteral(resourceName: "card_icon")
                }
                
                
                
                
            }else {
                self.validCard = false

                self.BackgroundImage.image = #imageLiteral(resourceName: "card_icon")
            }
            
            if self.creditCardValidator.validate(string:value) {
                // Card number is valid
                
                
                if value.count == 16 {
                    self.validCard = true
                    
                }else{
                    self.validCard = false
                    
                }
                
                
                
            }else {
                self.validCard = false

            }
            
            
        }else if  textField.tag  == 2 {
            
            if value.count == 4 {
                self.year  = String(value.suffix(2))
                self.month  = String(value.prefix(2))
                
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

        
        if self.cardNumber.isEmpty {
            UIApplication.topViewController()?.view.makeToast(NSLocalizedString("cardNumber_NOTVALID",bundle :  self.bandle,comment: "") )
            
            return;
        }
        
        
        
        if   !self.validCard {
            UIApplication.topViewController()?.view.makeToast(NSLocalizedString("cardNumber_VALID",bundle :  self.bandle,comment: "") )
            
            return;
        }

        
        if (self.CardHolderName.text?.isEmpty)! {
            
            UIApplication.topViewController()?.view.makeToast(NSLocalizedString("CardHolderNameRequird",bundle :  self.bandle,comment: "") )
            
            return;
        }
        

        
        if (self.DateTF.text?.isEmpty)! || !validDate {
            UIApplication.topViewController()?.view.makeToast(
                NSLocalizedString("DateTF_NOTVALID",bundle :  self.bandle,comment: "") )
            
            return;
        }
        
        
        
        
        if  !validDate {
            UIApplication.topViewController()?.view.makeToast(
                NSLocalizedString("DateTF_NOTVALID_AC",bundle :  self.bandle,comment: "") )
            
            return;
        }
        
        
        
        if (self.CVCTF.text?.isEmpty)! {
            
            UIApplication.topViewController()?.view.makeToast(NSLocalizedString("CVCTF_NOTVALID",bundle :  self.bandle,comment: "") )
            
            return;
        }
        
        
        let YearMonth = self.year + self.month

        let addcardRequest = ManualPaymentRequest()
        addcardRequest.PAN = self.cardNumber
        addcardRequest.CVV2 =  self.CVCTF.text!
        addcardRequest.DateExpiration = YearMonth
        addcardRequest.AmountTrxn = String ( MainScanViewController.paymentData.amount )
        
        
        if MainScanViewController.paymentData.Is3DS {
            ApiManger.Compose3DSTransaction(addcardRequest: addcardRequest) { (transactionStatusResponse) in
                
    
                
                
                if transactionStatusResponse.Success {
                    
                    
                    self.delegateActions?.openWebView(compose3DSTransactionResponse: transactionStatusResponse, manualPaymentRequest: addcardRequest)
               
//                let popupVC = DsWebViewViewController(nibName: "DsWebViewViewController", bundle: nil)
                
//                    popupVC.manualPaymentRequest = addcardRequest
//                    popupVC.compose3DSTransactionResponse = transactionStatusResponse
//                    popupVC.SendHandler = {(value) in
//

//
        
                    
                
                }else {
                    UIApplication.topViewController()?.view.makeToast(transactionStatusResponse.Message)
                }
                
                
                
            }
            
        }else {
            ApiManger.PayByCard(PAN: self.cardNumber, cvv2: self.CVCTF.text!, DateExpiration: YearMonth) { (transactionStatusResponse) in
                
                
                transactionStatusResponse.FROMWHERE = "Card"
                self.delegateActions?.SaveCard(transactionStatusResponse: transactionStatusResponse)
                
                
            }
            
            
        }
        

        
    }
    
    
 
    
}
