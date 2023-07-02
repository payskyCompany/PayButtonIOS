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

protocol AddNewCardView: AnyObject {
    func hideSaveThisCardOutlets()
    func openWebView(withUrlPath path: String)
    func navigateToPaymentApprovedView(withTrxnReference reference: String, andMessage message: String)
    func showErrorAlertView(withMessage errorMsg: String)
    func startLoading()
    func endLoading()
}

class AddNewCardVC: UIViewController, MaskedTextFieldDelegateListener, ScanCardDelegate {
        
    let loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .mainBtnColor
        spinner.hidesWhenStopped = true
        spinner.backgroundColor = .lightText
        spinner.layer.cornerRadius = 20
        spinner.layer.masksToBounds = true
        return spinner
    }()
    
    @IBOutlet weak var closeCurrentPageBtn: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var merchantLbl: UILabel!
    @IBOutlet weak var merchantNameLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var amountValueLbl: UILabel!
    
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var changeLangBtn: UIButton!
    @IBOutlet weak var termsAndConditionsBtn: UIButton!
    
    @IBOutlet weak var cardNumberLogo: UIImageView!
    @IBOutlet weak var cardNumberTF: UITextField!
    @IBOutlet weak var cardHolderNameTF: UITextField!
    @IBOutlet weak var cardExpireDateTF: UITextField!
    @IBOutlet weak var cardCVVTF: UITextField!
    
    @IBOutlet weak var enterCardDataLbl: UILabel!
    @IBOutlet weak var scanCardBtn: UIButton!
    @IBOutlet weak var saveForFutureLbl: UILabel!
    @IBOutlet weak var saveForFutureCheckBox: CheckBox!
    @IBOutlet weak var setAsDefaultLbl: UILabel!
    @IBOutlet weak var setAsDefaultCheckBox: CheckBox!
    
    var maskedCreditCard: MaskedTextFieldDelegate!
    var maskedHolderName: MaskedTextFieldDelegate!
    var maskedCVV: MaskedTextFieldDelegate!
    
    var scanCreditCardDelegate: ScanCardDelegate?
    
    var cardNumber = ""
    let creditCardValidator = CreditCardValidator()
    var validCard = false
    
    var validExpiryDate = false
    var previousLength = 0
    var year = ""
    var month = ""
   
//    weak var delegateActions: ActionCellActionDelegate? // navigation after api callout
    
    var presenter: AddNewCardPresenter!
    
    weak var delegate: PayButtonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        presenter.viewDidLoad()
        self.setupUIView()
        addSpinnerView()
    }
    
    private func addSpinnerView() {
        self.view.addSubview(loadingSpinner)
        loadingSpinner.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        loadingSpinner.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        loadingSpinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    @IBAction func scanCardBtnTapped(_ sender: UIButton) {
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

        self.textField(cardNumberTF, didFillMandatoryCharacters : true, didExtractValue: result.recognizedNumber ?? "")
        
        let data = (result.recognizedExpireDateMonth ?? "") + "/" + (result.recognizedExpireDateYear ?? "")
        let valueDate = (result.recognizedExpireDateMonth ?? "") + (result.recognizedExpireDateYear ?? "")

        cardExpireDateTF.text = data
        self.textField(cardExpireDateTF, didFillMandatoryCharacters : true, didExtractValue: valueDate)
    }
    
    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        textField.text = textField.text?.replacedArabicDigitsWithEnglish
        
        if textField.tag == 1 {
            checkCardNumberValid(value)
            debugPrint(cardNumber)
        }
        else if textField.tag == 2 {
            if value.count == 4 {
                self.year  = String(value.replacedArabicDigitsWithEnglish.suffix(2))
                self.month  = String(value.replacedArabicDigitsWithEnglish.prefix(2))
                
                if Int (self.year)! > 18 && Int (self.month)! < 13 {
                    validExpiryDate = true
                } else {
                    validExpiryDate = false
                }
            } else {
                validExpiryDate = false
            }
        }
    }
    
    @IBAction func cardExpireDateChanged(_ sender: UITextField) {
        validExpiryDate = false
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
                validExpiryDate = true
            } else {
                validExpiryDate = false
            }
        }
        
        previousLength = cardExpireDateTF.text!.count
    }
    
    @IBAction func saveForFutureBtnAction(_ sender: CheckBox) {
        if !(sender.isChecked) {
            presenter.updateIsSaveCard(withValue: true)
        } else {
            presenter.updateIsSaveCard(withValue: false)
            
            self.setAsDefaultCheckBox.isChecked = false
            presenter.updateIsDefaultCard(withValue: false)
        }
    }
    
    @IBAction func setAsDefaultBtnAction(_ sender: CheckBox) {
        if !(sender.isChecked) {
            presenter.updateIsDefaultCard(withValue: true)
            
            self.saveForFutureCheckBox.isChecked = true
            presenter.updateIsSaveCard(withValue: true)
        } else {
            presenter.updateIsDefaultCard(withValue: false)
        }
    }
    
    @IBAction func proceedBtnPressed(_ sender: UIButton) {
        UIApplication.topViewController()?.view.endEditing(true)

#if DEBUG
        debugPrint("Not App Store or TestFlight build")
        validCard = true
#else
        debugPrint("App Store or TestFlight build")
#endif

        if(isDataValid()) {
            let expireDate = cardExpireDateTF.text!.split(separator: "/")
            let yearMonthFormat = expireDate[1] + expireDate[0]
            
            presenter.callPayByCardAPI(cardNumber: cardNumber,
                                       cardHolderName: cardHolderNameTF.text ?? "",
                                       expiryDate: String(yearMonthFormat),
                                       cvv: cardCVVTF.text ?? "")
        }
    }
    
    @IBAction func dismissCurrentPageAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func changeLangBtnPressed(_ sender: UIButton) {
        UIView.appearance().semanticContentAttribute = MOLHLanguage.currentAppleLanguage() == "ar" ? .forceRightToLeft : .forceLeftToRight
        
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        if (MOLHLanguage.currentAppleLanguage()=="en") {
            UserDefaults.standard.set("en", forKey: "AppLanguage")
        }else{
            UserDefaults.standard.set("ar", forKey: "AppLanguage")
        }
        MOLH.reset()
        Bundle.swizzleLocalization()
        
        let viewController = AddNewCardVC(nibName: "AddNewCardVC", bundle: nil)
        viewController.delegate = self.delegate
        let newPresenter = AddNewCardPresenter(view: viewController,
                                               paymentMethodData: presenter.getPaymentMethodData())
        viewController.presenter = newPresenter
        if UIApplication.topViewController()?.navigationController != nil {
            UIApplication.topViewController()?.dismiss(animated: true, completion: {
                UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
            })
        } else {
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.dismiss(animated: true, completion: {
                UIApplication.topViewController()?.present(viewController, animated: true)
            })
        }
    }
    
    @IBAction func termsAndConditionsBtnPressed(_ sender: UIButton) {
        
    }
    
    
}

extension AddNewCardVC {
    private func setupUIView() {
        hideSaveThisCardOutlets()
        
        closeCurrentPageBtn.setTitle("", for: .normal)
        headerLbl.text = "quick_payment_form".localizedString()
        merchantLbl.text = "merchant".localizedString().uppercased()
        merchantNameLbl.text = MerchantDataManager.shared.merchant.merchantId
        amountLbl.text = "amount".localizedString().uppercased()
        amountValueLbl.text = "\(MerchantDataManager.shared.merchant.currencyCode)".localizedString()
        + " " + "\(MerchantDataManager.shared.merchant.amount)"
        
        proceedBtn.setTitle("proceed".localizedString(), for: .normal)
        backBtn.setTitle("back".localizedString(), for: .normal)
        changeLangBtn.setTitle("change_lang".localizedString(), for: .normal)
        termsAndConditionsBtn.setTitle("terms_conditions".localizedString(), for: .normal)
        
        enterCardDataLbl.text = "please_enter_card_data".localizedString()
        saveForFutureLbl.text = "save_for_future_use".localizedString()
        setAsDefaultLbl.text = "set_as_default".localizedString()
        scanCardBtn.setTitle("", for: .normal)
        saveForFutureCheckBox.setTitle("", for: .normal)
        setAsDefaultCheckBox.setTitle("", for: .normal)

        cardNumberTF.setTextFieldStyle("card_number".localizedString() , title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) , borderWidth: 0, borderColor: UIColor.clear, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 18,padding: 10)
        
        cardHolderNameTF.setTextFieldStyle("name_on_card".localizedString()  , title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) , borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 10,padding: 10,keyboardType: UIKeyboardType.default)
        
        cardExpireDateTF.setTextFieldStyle("expire_date".localizedString() , title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) , borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 5,padding: 10)
        
        cardCVVTF.setTextFieldStyle("cvc".localizedString() , title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) , borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray,maxLength: 4,padding: 4)
        
        maskedCreditCard = MaskedTextFieldDelegate(primaryFormat: "[0000] [0000] [0000] [0000]")
        maskedCreditCard.listener = self
        cardNumberTF.delegate = maskedCreditCard
        cardNumberTF.tag = 1
        
        maskedHolderName = MaskedTextFieldDelegate(primaryFormat: "[A][--------] [A][---------] [A][---------]")
        cardHolderNameTF.delegate =  maskedHolderName
        maskedHolderName.listener = self

        maskedCVV = MaskedTextFieldDelegate(primaryFormat: "[000]")
        maskedCVV.listener = self
        cardCVVTF.delegate = maskedCVV
        
        cardExpireDateTF.tag = 2
        scanCreditCardDelegate = self
    }
}

extension AddNewCardVC: AddNewCardView {
    func hideSaveThisCardOutlets() {
        print("hideSaveThisCardOutlets")
        saveForFutureCheckBox.isHidden = !(presenter.getPaymentMethodData().isTokenized ?? false)
        saveForFutureLbl.isHidden = !(presenter.getPaymentMethodData().isTokenized ?? false)
        setAsDefaultCheckBox.isHidden = !(presenter.getPaymentMethodData().isTokenized ?? false)
        setAsDefaultLbl.isHidden = !(presenter.getPaymentMethodData().isTokenized ?? false)
    }
   
    func openWebView(withUrlPath path: String) {
        print("openWebView")
    }
    
    func navigateToPaymentApprovedView(withTrxnReference reference: String, andMessage message: String) {
        print("navigateToPaymentApprovedView")
    }
    
    func showErrorAlertView(withMessage errorMsg: String) {
        proceedBtn.isUserInteractionEnabled = true
        UIApplication.topViewController()?.showAlert("error".localizedString(), message: errorMsg)
    }

    func startLoading() {
        proceedBtn.isUserInteractionEnabled = false
        loadingSpinner.startAnimating()
    }

    func endLoading() {
        proceedBtn.isUserInteractionEnabled = true
        loadingSpinner.stopAnimating()
    }
}
