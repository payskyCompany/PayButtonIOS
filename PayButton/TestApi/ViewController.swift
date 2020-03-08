//
//  ViewController.swift
//  PayButton
//
//  Created by AMR on 10/3/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PaymentDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
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
        AppDelegate.UrlTypeRow = row
    }
    var DataToShow: [String] = [String]()
   var DataToSend: [UrlTypes] = [UrlTypes]()
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
//
//    @IBOutlet weak var RefLabel: UILabel!
//
//    @IBOutlet weak var RefValue: UITextField!
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
    @IBOutlet weak var picker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
               self.picker.dataSource = self
        DataToShow = ["Production", "Testing", "UPG Stagging", "UPG Production"]
        DataToSend = [.Production,.Testing,.UPG_Staging,.UPG_Production]
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

              //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
              //tap.cancelsTouchesInView = false

              view.addGestureRecognizer(tap)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                   NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        
        
        ChangeLang.setTitle("change_lang".localizedPaySky(), for: .normal)
          PayBtn.setTitle("pay_now".localizedPaySky(), for: .normal)
          PayBtn.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        
        MerchantIdLabel.text = "Merchant ID_paysky".localizedPaySky()
        MerchantIdEd.setTextFieldStyle( "Merchant ID_paysky".localizedPaySky(), title: "10454665972", textColor: UIColor.black, font:Global.setFont(14) ,
                                        borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: PaySkySDKColor.RaduisNumber , placeholderColor: UIColor.gray,maxLength: 20,padding: 20)
        
  
//        RefLabel.text = "ref_number".localizedPaySky()
//        RefValue.setTextFieldStyle("ref_number".localizedPaySky(), title: "3424324234", textColor: UIColor.black, font:Global.setFont(14) ,
//                                       borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: PaySkySDKColor.RaduisNumber , placeholderColor: UIColor.gray,maxLength: 10,padding: 20)
        
        
        TerminalIDLabel.text =  "Terminal ID_paysky".localizedPaySky()
        TerminalIDTF.setTextFieldStyle( "Terminal ID_paysky".localizedPaySky(), title: "78175142", textColor: UIColor.black, font:Global.setFont(14) ,
                                       borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: PaySkySDKColor.RaduisNumber , placeholderColor: UIColor.gray,maxLength: 20,padding: 20)
     
        
        AmountLabel.text = "Amount".localizedPaySky()
        AmountEd.setTextFieldStyle("Amount".localizedPaySky(), title: "20", textColor: UIColor.black, font:Global.setFont(14) ,
                                   borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: PaySkySDKColor.RaduisNumber , placeholderColor: UIColor.gray,maxLength: 10,padding: 20, keyboardType: .decimalPad)
        
        
        CurrencyLabel.text = "Currency_paysky".localizedPaySky()
        AppName.text = "app_name_paysky".localizedPaySky()
        CurrencyEd.setTextFieldStyle("Currency_paysky".localizedPaySky(), title: "818", textColor: UIColor.black, font:Global.setFont(14) ,
                                   borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: PaySkySDKColor.RaduisNumber , placeholderColor: UIColor.gray,maxLength: 10,padding: 20)
        
        
        
        
   
        SecureHash.setTextFieldStyle("Secure Hash", title: "", textColor: UIColor.black, font:Global.setFont(14) ,
                                     borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: PaySkySDKColor.RaduisNumber , placeholderColor: UIColor.gray,maxLength: 100,padding: 20, keyboardType: .alphabet)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func PayAction(_ sender: Any) {
        
     
        if (MerchantIdEd.text?.isEmpty)! {
            UIApplication.topViewController()?.view.makeToast( "please entre merchant".localizedPaySky())
            return
        }
        
        if (TerminalIDTF.text?.isEmpty)! {
            UIApplication.topViewController()?.view.makeToast( "please entre terminal".localizedPaySky())
            return
        }
        
        if (AmountEd.text?.isEmpty)! {
            UIApplication.topViewController()?.view.makeToast( "please entre amount".localizedPaySky())
            return
        }
        
        
        if (CurrencyEd.text?.isEmpty)! {
            UIApplication.topViewController()?.view.makeToast( "please entre currency".localizedPaySky())
            return
        }
        
        

        let paymentViewController = PaymentViewController ()
        paymentViewController.amount =  AmountEd.text!
        paymentViewController.delegate = self
        paymentViewController.refnumber =  ""

        paymentViewController.mId = MerchantIdEd.text!
        paymentViewController.tId = TerminalIDTF.text!
        paymentViewController.Currency = CurrencyEd.text!
        paymentViewController.isProduction = false   // set it true if you want to go live
        paymentViewController.AppStatus = DataToSend[selectedOne]
        
        paymentViewController.Key = SecureHash.text!

        paymentViewController.pushViewController()



        

//        let paymentViewController = PaymentViewController ()
//        paymentViewController.amount =  "20"
//        paymentViewController.delegate = self
//
//        paymentViewController.mId = "42143"
//        paymentViewController.tId = "73299056"
//        paymentViewController.Currency = "826"
//
//
//        paymentViewController.refnumber = "123456789";
//        paymentViewController.Key = "63616133323632652D636439312D346435312D623832312D643665666539653633626638"
//
//        paymentViewController.pushViewController()

        
    }
    
    
    @IBAction func ChangeLangAction(_ sender: Any) {
        var AppLang = UserDefaults.standard.array(forKey: "AppleLanguages")![0] as! String
        
        
        if AppLang == "en" {
            AppLang = "ar"
            _ = UserDefaults.standard.array(forKey: "AppleLanguages")
            UserDefaults.standard.set(["ar"], forKey: "AppleLanguages")
        }else {
            AppLang = "en"
            _ = UserDefaults.standard.array(forKey: "AppleLanguages")
            UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
        }
        
        UserDefaults.standard.synchronize();
        
        
        
        
        
        exit(0)
    }
    
}

