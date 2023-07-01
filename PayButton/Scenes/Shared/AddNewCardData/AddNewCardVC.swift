//
//  AddNewCardVC.swift
//  PayButton
//
//  Created by PaySky105 on 18/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import UIKit
import MOLH
import PayCardsRecognizer
import PopupDialog
import AVFoundation

protocol AddNewCardViewProtocol: AnyObject {
    func hideSaveThisCardOutlets()
    func onScanCardBtnTapped()
    func onSaveCardSwitchValueChanged(_ isSwitchOn: Bool)
    func onPayBtnTapped()
    func openWebView(withUrlPath path: String)
    func navigateToPaymentApprovedView(withTrxnReference reference: String, andMessage message: String)
    func navigateToPaymentRejectedView(withMessage text: String)
    func startLoading()
    func endLoading()
}

class AddNewCardVC: UIViewController, MaskedTextFieldDelegateListener, ScanCardDelegate {
        
    @IBOutlet weak var merchantLbl: UILabel!
    @IBOutlet weak var merchantNameLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var amountValueLbl: UILabel!
    
    @IBOutlet weak var cardNumberLogo: UIImageView!
    @IBOutlet weak var cardNumberTF: UITextField!
    @IBOutlet weak var cardHolderNameTF: UITextField!
    @IBOutlet weak var cardExpireDateTF: UITextField!
    @IBOutlet weak var cardCVVTF: UITextField!
    
    @IBOutlet weak var closeCurrentPageBtn: UIButton!
    @IBOutlet weak var scanCardNumber: UIButton!
    @IBOutlet weak var saveForFutureBtn: CheckBox!
    @IBOutlet weak var setAsDefaultBtn: CheckBox!
    
    var MaskedCreditCard: MaskedTextFieldDelegate!
    var MaskedHolderName: MaskedTextFieldDelegate!
    var MaskedCVV: MaskedTextFieldDelegate!
    
    var scanCreditCardDelegate: ScanCardDelegate?
    
    var cardNumber = ""
    let creditCardValidator = CreditCardValidator()
    var validCard = false
    
    var validDate = false
    var previousLength = 0
    var year = ""
    var month = ""
    
    var saveForFutureBool: Bool = false
    var setAsDefaultBool: Bool = false
    
    weak var delegateActions: ActionCellActionDelegate? // navigation after api callout
    
    var presenter: AddNewCardPresenter!
    
    weak var delegate: PayButtonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        self.setupUIView()
    }
    
    @IBAction func scanCardData(_ sender: UIButton) {
        let st = UIStoryboard(name: "PayButtonBoard", bundle: nil)

        let vc: CardScanViewController = st.instantiateViewController(withIdentifier: "CardScanViewController") as! CardScanViewController
        vc.delegate = self.scanCreditCardDelegate
        vc.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.present(vc, animated: true,completion: nil)
    }
    
    func cardResult(_ result: PayCardsRecognizerResult) {
        cardHolderNameTF.text =   result.recognizedHolderName

        let mask: Mask = try! Mask(format: "[0000] [0000] [0000] [0000]")
        let input: String = result.recognizedNumber!
        let maskResult: Mask.Result = mask.apply(
            toText: CaretString(
                string: input,
                caretPosition: input.endIndex
            ),
            autocomplete: true
        )
        cardNumberTF.text = maskResult.formattedText.string

        self.textField(
            cardNumberTF,
            didFillMandatoryCharacters : true,
            didExtractValue: result.recognizedNumber ?? ""
        )


        let data = (result.recognizedExpireDateMonth ?? "") + "/" + (result.recognizedExpireDateYear ?? "")
        let valuedate = (result.recognizedExpireDateMonth ?? "") + (result.recognizedExpireDateYear ?? "")

        cardExpireDateTF.text = data
        self.textField(
            cardExpireDateTF,
            didFillMandatoryCharacters : true,
            didExtractValue: valuedate
        )
    }//--- End of Scan Credit Card Result
    
    open func textField(_ textField: UITextField,
                        didFillMandatoryCharacters complete: Bool,
                        didExtractValue value: String) {
        
        textField.text = textField.text?.replacedArabicDigitsWithEnglish
        if  textField.tag  == 1 {
            
            self.cardNumber = value.replacedArabicDigitsWithEnglish
            
            if let type = creditCardValidator.type(from: value.replacedArabicDigitsWithEnglish) {
                
                self.validCard = true
                
                if type.name == "Visa" {
                    self.cardNumberLogo.image = #imageLiteral(resourceName: "vi")
                }else if type.name == "Amex"  {
                    self.cardNumberLogo.image = #imageLiteral(resourceName: "am")
                }else if type.name == "MasterCard"  {
                    self.cardNumberLogo.image = #imageLiteral(resourceName: "mc")
                }else if type.name == "Maestro"  {
                    self.cardNumberLogo.image = #imageLiteral(resourceName: "Maestro")
                }else if type.name == "Diners Club"  {
                    self.cardNumberLogo.image = #imageLiteral(resourceName: "dc")
                }else if type.name == "JCB"  {
                    self.cardNumberLogo.image = #imageLiteral(resourceName: "jcb")
                }else if type.name == "Discover"  {
                    self.cardNumberLogo.image = #imageLiteral(resourceName: "ds")
                }else if type.name == "UnionPay"  {
                    self.cardNumberLogo.image = #imageLiteral(resourceName: "UnionPay")
                }else if type.name == "Mir"  {
                    self.cardNumberLogo.image = #imageLiteral(resourceName: "Mir")
                    
                }else  if type.name == "Meza"{
                    self.cardNumberLogo.image =  #imageLiteral(resourceName: "miza_logo")
                      
                } else {
                    self.validCard = false
                    
                    self.cardNumberLogo.image = #imageLiteral(resourceName: "card_icon")
                }
            } else {
                self.validCard = false
                self.cardNumberLogo.image = #imageLiteral(resourceName: "card_icon")
            }
            
            if value.count == 16 {
                if self.creditCardValidator.validate(number:value.replacedArabicDigitsWithEnglish) {
                    // Card number is valid
                    self.validCard = true
                } else {
                    self.validCard = false
                    UIApplication.topViewController()?.view.endEditing(true)
                    UIApplication.topViewController()?.view.makeToast("cardNumber_VALID".localizedString())
                }
            }
        } else if  textField.tag  == 2 {
            if value.count == 4 {
                self.year  = String(value.replacedArabicDigitsWithEnglish.suffix(2))
                self.month  = String(value.replacedArabicDigitsWithEnglish.prefix(2))
                
                if Int ( self.year)! > 18 && Int ( self.month)! < 13  {
                    validDate = true;
                } else {
                    validDate = false;
                }
            } else {
                validDate = false;
            }
        }
    }
    
    @IBAction func cardExpireDateChanged(_ sender: UITextField) {
        validDate = false;
        if previousLength > cardExpireDateTF.text!.count {
            previousLength = cardExpireDateTF.text!.count
            return
        }
        if cardExpireDateTF.text!.count == 1 && Int(cardExpireDateTF.text!)! > 2 {
            cardExpireDateTF.text! = "0" + cardExpireDateTF.text! + "/"
        }
        if cardExpireDateTF.text!.count == 2 && !cardExpireDateTF.text!.contains("/") {
            if Int(cardExpireDateTF.text!)! > 12 {
                cardExpireDateTF.text! = "12/"
            }
            else {
                cardExpireDateTF.text! = cardExpireDateTF.text! + "/"
            }
        }
        let val = cardExpireDateTF.text!.split(separator: "/")
        if cardExpireDateTF.text!.count == 5 && val.count > 1 {
            if Int(String(val[1] + ""))! > 19 {
                validDate = true;
                
            }else{
                validDate = false;
                
            }
        }
        
        previousLength = cardExpireDateTF.text!.count
        
    }
    
    @IBAction func saveForFutureBtnAction(_ sender: CheckBox) {
        if !(sender.isChecked) {
            self.saveForFutureBool = true
            
        } else {
            self.setAsDefaultBool = false
            self.setAsDefaultBtn.isChecked = false
            self.saveForFutureBool = false
        }
    }
    
    @IBAction func setAsDefaultBtnAction(_ sender: CheckBox) {
        if !(sender.isChecked) {
            self.setAsDefaultBool = true
            self.saveForFutureBtn.isChecked = true
            self.saveForFutureBool = true
        }else {
            self.setAsDefaultBool = false
        }
    }
    
    @IBAction func dismissCurrentPageAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
}

extension AddNewCardVC {
    
    @IBAction func proceedBtnPressed(_ sender: UIButton) {
        print("\n saveForFutureBool:  \(self.saveForFutureBool)")
        print("  setAsDefaultBool:  \(self.setAsDefaultBool) \n")

        UIApplication.topViewController()?.view.endEditing(true)

        guard !(self.cardNumber.isEmpty) else {
            UIApplication.topViewController()?.view.makeToast("cardNumber_NOTVALID".localizedString())
            return
        }

        guard self.validCard else {
            UIApplication.topViewController()?.view.makeToast("cardNumber_VALID".localizedString())
            return
        }

        guard (cardNumber.replacingOccurrences(of: " ", with: "").count == 16
                && cardNumber.replacingOccurrences(of: " ", with: "").count == 19) else {
            UIApplication.topViewController()?.view.makeToast("cardNumber_VALID".localizedString())
            return
        }

        guard (self.cardHolderNameTF.text != "") else {
            UIApplication.topViewController()?.view.makeToast("CardHolderNameRequird".localizedString())
            return
        }

        guard (self.cardExpireDateTF.text != "") else {
            UIApplication.topViewController()?.view.makeToast("DateTF_NOTVALID".localizedString())
            return
        }

        guard (self.cardExpireDateTF.text?.count == 5) else {
            UIApplication.topViewController()?.view.makeToast("DateTF_NOTVALID_AC".localizedString())
            return
        }

        guard self.validDate else {
            UIApplication.topViewController()?.view.makeToast("invalid_expire_date_date".localizedString())
            return
        }

        guard (self.cardCVVTF.text != "") else {
            UIApplication.topViewController()?.view.makeToast("CVCTF_NOTVALID".localizedString())
            return
        }

        guard (self.cardCVVTF.text?.count == 3) else {
            UIApplication.topViewController()?.view.makeToast("CVCTF_NOTVALID_LENGTH".localizedString())
            return
        }

        let val = cardExpireDateTF.text!.split(separator: "/")
        let YearMonth = val[1] + val[0]

        let addcardRequest = ManualPaymentRequest()
        addcardRequest.PAN = self.cardNumber
        addcardRequest.CardHolderName = self.cardHolderNameTF.text ?? ""

        addcardRequest.cvv2 =  self.cardCVVTF.text!
        addcardRequest.DateExpiration = String(YearMonth)
        addcardRequest.AmountTrxn = String ( MainScanViewController.paymentData.amount )

        ApiManger.PayByCard(CardHolderName : self.cardHolderNameTF.text! ,
                            PAN: self.cardNumber,
                            cvv2: self.cardCVVTF.text!,
                            DateExpiration: String(YearMonth)) { (transactionStatusResponse) in
            if transactionStatusResponse.Success {
                if transactionStatusResponse.ChallengeRequired {
                    self.delegateActions?.openWebView(compose3DSTransactionResponse: transactionStatusResponse,
                                                      manualPaymentRequest: addcardRequest)
                } else {
                    transactionStatusResponse.FROMWHERE = "Card"
                    self.delegateActions?.saveCard(transactionStatusResponse: transactionStatusResponse)
                }
            } else {
                if(transactionStatusResponse.Message.isEmpty) {
                    UIApplication.topViewController()?.view.makeToast(transactionStatusResponse.ErrorDetail)
                } else {
                    UIApplication.topViewController()?.view.makeToast(transactionStatusResponse.Message)
                }
            }
        }
    }
    
}
    
extension AddNewCardVC {
    private func setupUIView() {
        merchantLbl.text = "merchant".localizedString().uppercased()
        merchantNameLbl.text = MerchantDataManager.shared.merchant.merchantId
        amountLbl.text = "amount".localizedString().uppercased()
        amountValueLbl.text = "\(MerchantDataManager.shared.merchant.currencyCode)".localizedString()
        + " " + "\(MerchantDataManager.shared.merchant.amount)"
        
        closeCurrentPageBtn.setTitle("", for: .normal)
        scanCardNumber.setTitle("", for: .normal)
        saveForFutureBtn.setTitle("", for: .normal)
        setAsDefaultBtn.setTitle("", for: .normal)
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            self.scanCardNumber.isHidden = false
        } else if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.notDetermined {
            self.scanCardNumber.isHidden = true
        }
        
        cardNumberTF.setTextFieldStyle( "card_number".localizedString() , title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) , borderWidth: 0, borderColor: UIColor.clear, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 18,padding: 10)
        
        cardHolderNameTF.setTextFieldStyle("name_on_card".localizedString()  , title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) , borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 10,padding: 10,keyboardType: UIKeyboardType.default)
        
        cardExpireDateTF.setTextFieldStyle("expire_date".localizedString() , title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) , borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 5,padding: 10)
        
        cardCVVTF.setTextFieldStyle( "cvc".localizedString() , title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) , borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 4,padding: 4)
        
        MaskedCreditCard = MaskedTextFieldDelegate(primaryFormat: "[0000] [0000] [0000] [0000]")
        MaskedCreditCard.listener = self
        cardNumberTF.delegate = MaskedCreditCard
        cardNumberTF.tag = 1
        
        MaskedHolderName  = MaskedTextFieldDelegate(primaryFormat: "[A][--------] [A][---------] [A][---------]")
        cardHolderNameTF.delegate =  MaskedHolderName
        MaskedHolderName.listener = self

        MaskedCVV = MaskedTextFieldDelegate(primaryFormat: "[000]")
        MaskedCVV.listener = self
        cardCVVTF.delegate = MaskedCVV
        
        cardExpireDateTF.tag = 2
        scanCreditCardDelegate = self
    }
}

extension AddNewCardVC: AddNewCardViewProtocol {
    func hideSaveThisCardOutlets() {
        print("hideSaveThisCardOutlets")
    }
    
    func onScanCardBtnTapped() {
        print("onScanCardBtnTapped")
    }
    
    func onSaveCardSwitchValueChanged(_ isSwitchOn: Bool) {
        print("onSaveCardSwitchValueChanged")
    }
   
    func onPayBtnTapped() {
        print("onPayBtnTapped")
    }
    
    func openWebView(withUrlPath path: String) {
        print("openWebView")
    }
    
    func navigateToPaymentApprovedView(withTrxnReference reference: String, andMessage message: String) {
        print("navigateToPaymentApprovedView")
    }
    
    func navigateToPaymentRejectedView(withMessage text: String) {
        print("navigateToPaymentRejectedView")
    }
    
    func startLoading() {
        print("startLoading")
    }
    
    func endLoading() {
        print("endLoading")
    }
}
