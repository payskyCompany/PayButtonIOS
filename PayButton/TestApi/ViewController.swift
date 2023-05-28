//
//  ViewController.swift
//  PayButton
//
//  Created by AMR on 10/3/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit
import MOLH

class ViewController: UIViewController, PaymentDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    let PaySkyTitle = "PAYSKY"
    let upgTitle = "UPG"
    let selectedTitle = "PAYSKY"


    
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
        ChangeLang.setTitle("change_lang".localizedPaySky(), for: .normal)
        PayBtn.setTitle("pay_now".localizedPaySky(), for: .normal)
        MerchantIdLabel.text = "Merchant ID_paysky".localizedPaySky()
        TerminalIDLabel.text =  "Terminal ID_paysky".localizedPaySky()
        AmountLabel.text = "Amount".localizedPaySky()
        CurrencyLabel.text = "Currency_paysky".localizedPaySky()
        AppName.text = "app_name_paysky".localizedPaySky()
    }
    
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
    var DataToShow: [String] = [String]()
    var DataToSend: [UrlTypes] = [UrlTypes]()

    var DataToSendUPG: [UPGUrlTypes] = [UPGUrlTypes]()
    
    
    var selectedOne = 0

    @IBAction func CopyResponse(_ sender: Any) {
        UIPasteboard.general.string =  receipt.toJsonString()
        UIApplication.topViewController()?.view.makeToast("Response has been copied")
    }
    var receipt: TransactionStatusResponse = TransactionStatusResponse()
    func finishSdkPayment(_ receipt: TransactionStatusResponse) {
        self.receipt = receipt
        if receipt.Success {

            LabeResoinse.setTitle("Transaction completed successfully, click here to show callback result", for: .normal)
            
        }else {
            LabeResoinse.setTitle("Transaction has been failed click to callback callback ", for: .normal)


            
        }
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
   
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
               self.picker.dataSource = self
        
        if selectedTitle != PaySkyTitle {
            imageLogo.image = UIImage(named: "upg_orange_logo")
            DataToShow = ["UPG Stagging", "UPG Production"]
            DataToSendUPG = [.UPG_Staging,.UPG_Production]
        }
        else {
            DataToShow = ["Production", "Testing"]
            DataToSend = [.Production,.Testing]
        }

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
        
        ChangeLang.setTitle("change_lang".localizedPaySky(), for: .normal)
        PayBtn.setTitle("pay_now".localizedPaySky(), for: .normal)
        PayBtn.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        
        MerchantIdLabel.text = "Merchant ID_paysky".localizedPaySky()
        MerchantIdEd.setTextFieldStyle( "Merchant ID_paysky".localizedPaySky(), title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) ,
                                       borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: PaySkySDKColor.RaduisNumber , placeholderColor: UIColor.gray,maxLength: 20,padding: 20)

       TerminalIDLabel.text =  "Terminal ID_paysky".localizedPaySky()
       TerminalIDTF.setTextFieldStyle( "Terminal ID_paysky".localizedPaySky(), title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) ,
                                      borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: PaySkySDKColor.RaduisNumber , placeholderColor: UIColor.gray,maxLength: 20,padding: 20)
       
       AmountLabel.text = "Amount".localizedPaySky()
       AmountEd.setTextFieldStyle("Amount".localizedPaySky(), title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) ,
                                  borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: PaySkySDKColor.RaduisNumber , placeholderColor: UIColor.gray,maxLength: 10,padding: 20, keyboardType: .decimalPad)
       
       
       CurrencyLabel.text = "Currency_paysky".localizedPaySky()
       AppName.text = "app_name_paysky".localizedPaySky()
       CurrencyEd.setTextFieldStyle("Currency_paysky".localizedPaySky(), title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) ,
                                  borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: PaySkySDKColor.RaduisNumber , placeholderColor: UIColor.gray,maxLength: 10,padding: 20)
       
  
       SecureHash.setTextFieldStyle("Secure Hash", title: "", textColor: UIColor.black, font:GlobalManager.setFont(14) ,
                                    borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: PaySkySDKColor.RaduisNumber , placeholderColor: UIColor.gray,maxLength: 100,padding: 20, keyboardType: .alphabet)
       

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
        
        MerchantIdEd.text = "17685499712"
        TerminalIDTF.text = "92539221"
        AmountEd.text = "50"
        CurrencyEd.text = "784"
        SecureHash.text = "63616133323632652D636439312D346435312D623832312D643665666539653633626638"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func PayAction(_ sender: Any) {
        
     
        if (MerchantIdEd.text?.isEmpty)! {
            UIApplication.topViewController()?.view.makeToast( "please enter merchant".localizedPaySky())
            return
        }
        
        if (TerminalIDTF.text?.isEmpty)! {
            UIApplication.topViewController()?.view.makeToast( "please enter terminal".localizedPaySky())
            return
        }
        
        if (AmountEd.text!.isEmpty ) {
            UIApplication.topViewController()?.view.makeToast( "please enter amount".localizedPaySky())
            return
        }
        if (Float(AmountEd.text!) == 0.0) {
            UIApplication.topViewController()?.view.makeToast( "please enter amount greater".localizedPaySky())
            return
        }
        
        
        if (CurrencyEd.text?.isEmpty)! {
            CurrencyEd.text = "818"
        }
        
        if (SecureHash.text?.isEmpty)! {
            UIApplication.topViewController()?.view.makeToast( "please enter secure hash value".localizedPaySky())
            return
        }
        if SecureHash.text!.count != 72 {
           UIApplication.topViewController()?.view.makeToast( "please enter valid secure hash value".localizedPaySky())
            return
        }

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
            if (MOLHLanguage.currentAppleLanguage()=="en"){
                UserDefaults.standard.set("en", forKey: "AppLanguage")
            }else{
                UserDefaults.standard.set("ar", forKey: "AppLanguage")
            }
            
            MOLH.reset()
            Bundle.swizzleLocalization()
        let st = UIStoryboard(name: "Main", bundle: nil)

               let vc :ViewController = st.instantiateViewController(withIdentifier: "ViewController") as! ViewController
               vc.modalPresentationStyle = .fullScreen
               UIApplication.topViewController()?.present(vc, animated: true,completion: nil)
    }
    
}

