//
//  ViewController.swift
//  PayButton
//
//  Created by AMR on 10/3/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit
import MOLH

class ViewController: UIViewController, PaymentDelegate {
    
    let payskyTitle = "PAYSKY"
    let upgTitle = "UPG"
    let selectedTitle = "PAYSKY"

    var selectedOne = 0
    var DataToShow: [String] = [String]()
    var DataToSend: [UrlTypes] = [UrlTypes]()
    var DataToSendUPG: [UPGUrlTypes] = [UPGUrlTypes]()
    
    var receipt: TransactionStatusResponse = TransactionStatusResponse()
    
    override func viewWillAppear(_ animated: Bool) {
        if MOLHLanguage.currentAppleLanguage() != "ar" {
            CurrencyEd.textAlignment = .left
            SecureHash.textAlignment = .left
            AmountEd.textAlignment = .left
            TerminalIDTF.textAlignment = .left
            MerchantIdEd.textAlignment = .left
            urltest.text = "Testing Urls"
        }
        else {
            CurrencyEd.textAlignment = .right
            SecureHash.textAlignment = .right
            AmountEd.textAlignment = .right
            TerminalIDTF.textAlignment = .right
            MerchantIdEd.textAlignment = .right
            urltest.text = "الرابط"
        }
        ChangeLang.setTitle("change_lang".localizedString(), for: .normal)
        PayBtn.setTitle("pay_now".localizedString(), for: .normal)
        MerchantIdLabel.text = "merchantID".localizedString()
        TerminalIDLabel.text = "terminalID".localizedString()
        AmountLabel.text = "amount".localizedString()
        CurrencyLabel.text = "currency_code".localizedString()
        AppName.text = "app_name_paysky".localizedString()
    }
    
    
    func finishSdkPayment(_ receipt: TransactionStatusResponse) {
        self.receipt = receipt
        if receipt.Success {
            LabeResoinse.setTitle("Transaction completed successfully, click here to show callback result", for: .normal)
        } else {
            LabeResoinse.setTitle("Transaction has been failed click to callback callback ", for: .normal)
        }
    }
    
    @IBAction func CopyResponse(_ sender: Any) {
        UIPasteboard.general.string =  receipt.toJsonString()
        UIApplication.topViewController()?.view.makeToast("Response has been copied")
    }
    
    
    @IBOutlet weak var LabeResoinse: UIButton!
    @IBOutlet weak var ChangeLang: UIButton!
    @IBOutlet weak var urltest: UILabel!

    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var PayBtn: UIButton!
    @IBOutlet weak var CurrencyEd: UITextField!
    @IBOutlet weak var CurrencyLabel: UILabel!
    @IBOutlet weak var AmountEd: UITextField!
    @IBOutlet weak var SecureHash: UITextField!
    @IBOutlet weak var AmountLabel: UILabel!
    @IBOutlet weak var TerminalIDTF: UITextField!
    @IBOutlet weak var TerminalIDLabel: UILabel!
    @IBOutlet weak var MerchantIdEd: UITextField!
    @IBOutlet weak var MerchantIdLabel: UILabel!
    @IBOutlet weak var AppName: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//   
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
//    
//    @objc func dismissKeyboard() {
//        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        view.endEditing(true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
               self.picker.dataSource = self
        
        if selectedTitle != payskyTitle {
            imageLogo.image = UIImage(named: "upg_orange_logo")
            DataToShow = ["UPG Stagging", "UPG Production"]
            DataToSendUPG = [.UPG_Staging,.UPG_Production]
        }
        else {
            DataToShow = ["Production", "Testing"]
            DataToSend = [.Production,.Testing]
        }

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(BasePaymentViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        ChangeLang.setTitle("change_lang".localizedString(), for: .normal)
        PayBtn.setTitle("pay_now".localizedString(), for: .normal)
        PayBtn.layer.cornerRadius = AppConstants.radiusNumber
        
        MerchantIdLabel.text = "merchantID".localizedString()
        MerchantIdEd.setTextFieldStyle("merchantID".localizedString(), title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) ,
                                       borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: AppConstants.radiusNumber , placeholderColor: UIColor.gray,maxLength: 20,padding: 20)

       TerminalIDLabel.text =  "terminalID".localizedString()
       TerminalIDTF.setTextFieldStyle("terminalID".localizedString(), title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) ,
                                      borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: AppConstants.radiusNumber , placeholderColor: UIColor.gray,maxLength: 20,padding: 20)
       
       AmountLabel.text = "amount".localizedString()
       AmountEd.setTextFieldStyle("amount".localizedString(), title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) ,
                                  borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: AppConstants.radiusNumber , placeholderColor: UIColor.gray,maxLength: 10,padding: 20, keyboardType: .decimalPad)
       
       CurrencyLabel.text = "currency_code".localizedString()
       CurrencyEd.setTextFieldStyle("currency_code".localizedString(), title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) ,
                                  borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: AppConstants.radiusNumber , placeholderColor: UIColor.gray,maxLength: 10,padding: 20)
       
  
        SecureHash.setTextFieldStyle("secure_hash_key".localizedString(), title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) ,
                                    borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: AppConstants.radiusNumber , placeholderColor: UIColor.gray,maxLength: 100,padding: 20, keyboardType: .alphabet)
       
        AppName.text = "app_name_paysky".localizedString()

        if MOLHLanguage.currentAppleLanguage() != "ar" {
            CurrencyEd.textAlignment = .left
            SecureHash.textAlignment = .left
            AmountEd.textAlignment = .left
            TerminalIDTF.textAlignment = .left
            MerchantIdEd.textAlignment = .left
        }
        else {
            CurrencyEd.textAlignment = .right
            SecureHash.textAlignment = .right
            AmountEd.textAlignment = .right
            TerminalIDTF.textAlignment = .right
            MerchantIdEd.textAlignment = .right
            urltest.text = "الرابط"
        }
        
        MerchantIdEd.text = "41565"
        TerminalIDTF.text = "1583826"
        AmountEd.text = "20.55"
        CurrencyEd.text = "\(AppConstants.selectedCountryCode)"
        SecureHash.text = "09a90e81140dcb0d686c09f0036ef910"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func PayAction(_ sender: Any) {
        
     
        if (MerchantIdEd.text?.isEmpty)! {
            UIApplication.topViewController()?.view.makeToast( "please enter merchant".localizedString())
            return
        }
        
        if (TerminalIDTF.text?.isEmpty)! {
            UIApplication.topViewController()?.view.makeToast( "please enter terminal".localizedString())
            return
        }
        
        if (AmountEd.text!.isEmpty ) {
            UIApplication.topViewController()?.view.makeToast( "please enter amount".localizedString())
            return
        }
        if (Float(AmountEd.text!) == 0.0) {
            UIApplication.topViewController()?.view.makeToast( "please enter amount greater".localizedString())
            return
        }
        
        if (CurrencyEd.text?.isEmpty)! {
            CurrencyEd.text = "\(AppConstants.selectedCountryCode)"
        }
        
        if (SecureHash.text?.isEmpty)! {
            UIApplication.topViewController()?.view.makeToast( "please enter secure hash value".localizedString())
            return
        }
//        if SecureHash.text!.count != 72 {
//           UIApplication.topViewController()?.view.makeToast( "please enter valid secure hash value".localizedString())
//            return
//        }

        let paymentViewController = PaymentViewController ()
        paymentViewController.amount =  AmountEd.text!
        paymentViewController.delegate = self
        paymentViewController.refnumber =  ""

        paymentViewController.mId = MerchantIdEd.text!
        paymentViewController.tId = TerminalIDTF.text!
        paymentViewController.Currency = CurrencyEd.text!
        paymentViewController.isProduction = false
        paymentViewController.AppStatus = DataToSend[selectedOne]
        
        paymentViewController.Key = SecureHash.text!

        paymentViewController.pushViewController()
    }
    
    @IBAction func ChangeLangAction(_ sender: Any) {
        UIView.appearance().semanticContentAttribute = MOLHLanguage.currentAppleLanguage() == "ar" ? .forceRightToLeft : .forceLeftToRight
        
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        if (MOLHLanguage.currentAppleLanguage() == "en") {
            UserDefaults.standard.set("en", forKey: "AppLanguage")
        } else {
            UserDefaults.standard.set("ar", forKey: "AppLanguage")
        }
        
        MOLH.reset()
        Bundle.swizzleLocalization()
        
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc: ViewController = st.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.present(vc, animated: true,completion: nil)
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource  {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DataToShow.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DataToShow[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOne = row
    }
    
}
