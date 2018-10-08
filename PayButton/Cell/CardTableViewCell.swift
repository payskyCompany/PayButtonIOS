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
        
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var CVCTF: UITextField!
    @IBOutlet weak var CardNumbeTV: UITextField!
    

    @IBOutlet weak var AccountName: UITextField!
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

    

    
    
    

    

    
       var bandle :Bundle!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let path = Bundle(for: CardTableViewCell.self).path(forResource:"PayButton", ofType: "bundle")
     
        
        if path != nil {
            bandle = Bundle(path: path!) ?? Bundle.main
        }else {
            bandle = Bundle.main
            
        }
        
        SaveCardBtn.setTitle(NSLocalizedString("Save",bundle :  self.bandle,comment: ""), for: .normal)
        EnterCardData.text = NSLocalizedString("Please enter card data",bundle :  self.bandle,comment: "")

        
        
        
        
        
        
        IQKeyboardManager.shared.enable = true
        IQToolbar.appearance().isTranslucent = false
        IQToolbar.appearance().barTintColor = UIColor.white
        IQToolbar.appearance().shouldHideToolbarPlaceholder = false
        
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = NSLocalizedString("Done",bundle :  self.bandle,comment: "")
        IQKeyboardManager.shared.toolbarTintColor = UIColor.white
        IQKeyboardManager.shared.toolbarBarTintColor = PaySkySDKColor.NavColor
        IQKeyboardManager.shared.placeholderFont = Global.setFont(13)
        
        
        
        SaveCardBtn.backgroundColor = PaySkySDKColor.mainBtnColor
 
        
        
        
        
        SaveCardBtn.layer.cornerRadius = 5
        ScanBtn.imageView?.contentMode = .scaleAspectFit
        CardNumbeTV.setTextFieldStyle( NSLocalizedString("Card Number",bundle :  self.bandle,comment: "") , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.clear, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 18,padding: 10)
        
        CVCTF.setTextFieldStyle( NSLocalizedString("CVC",bundle :  self.bandle,comment: "") , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 4,padding: 4)
        
        
        AccountName.setTextFieldStyle( NSLocalizedString("Account Name",bundle :  self.bandle,comment: "") , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 20,padding: 10,keyboardType: UIKeyboardType.default)
        
        DateTF.setTextFieldStyle(NSLocalizedString("Expiry date",bundle :  self.bandle,comment: "") , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 5,padding: 10)
        
        
        CardHolderName.setTextFieldStyle(NSLocalizedString("Name on card",bundle :  self.bandle,comment: "")  , title: "", textColor: UIColor.black, font:Global.setFont(14) , borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 10,padding: 10,keyboardType: UIKeyboardType.default)
        
        MaskedCreditCard = MaskedTextFieldDelegate(format: "[0000] [0000] [0000] [0000]")
        MaskedDateExpired = MaskedTextFieldDelegate(format: "[00]/[00]")
        
        
        
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
                    
                    self.BackgroundImage.image = #imageLiteral(resourceName: "card_icon")
                }
                
                
                
                
            }else {
                
                self.BackgroundImage.image = #imageLiteral(resourceName: "card_icon")
            }
            
            if self.creditCardValidator.validate(string:value) {
                // Card number is valid
                
                
                if value.count == 16 {
                    self.validCard = true
                    
                }else{
                    self.validCard = false
                    
                }
                
                
                
            }
            
            
        }else if  textField.tag  == 2 {
            
            if value.count == 4 {
                let last2 = value.suffix(2)
                let frist2 = value.prefix(2)
                
                if Int (last2)! > 18 && Int (frist2)! < 13  {
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
    
    
    @IBAction func SendMoneyByCard(_ sender: Any) {
        
        delegateActions?.ComfirmBtnClick()

        
    }
    
    
 
    
}
