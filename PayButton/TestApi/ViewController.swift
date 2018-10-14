//
//  ViewController.swift
//  PayButton
//
//  Created by AMR on 10/3/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PaymentDelegate  {
    func finishSdkPayment(_ receipt: TransactionStatusResponse) {
        
        if receipt.Success {
            LabeResoinse.text = receipt.toJsonString()

        }
    }
    @IBOutlet weak var LabeResoinse: UILabel!
    @IBOutlet weak var ChangeLang: UIButton!
    
    @IBOutlet weak var PayBtn: UIButton!
    @IBOutlet weak var CurrencyEd: UITextField!
    @IBOutlet weak var CurrencyLabel: UILabel!
    @IBOutlet weak var AmountEd: UITextField!
    @IBOutlet weak var AmountLabel: UILabel!
    @IBOutlet weak var TerminalIDTF: UITextField!
    @IBOutlet weak var TerminalIDLabel: UILabel!
    @IBOutlet weak var MerchantIdEd: UITextField!
    @IBOutlet weak var MerchantIdLabel: UILabel!
    @IBOutlet weak var AppName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        ChangeLang.setTitle(NSLocalizedString("change_lang",comment: ""), for: .normal)
          PayBtn.setTitle(NSLocalizedString("pay_now",comment: ""), for: .normal)
          PayBtn.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        
        MerchantIdLabel.text = NSLocalizedString("Merchant ID",comment: "")
        MerchantIdEd.setTextFieldStyle(NSLocalizedString("Merchant ID",comment: ""), title: "11400000001", textColor: UIColor.black, font:Global.setFont(14) ,
                                        borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: PaySkySDKColor.RaduisNumber , placeholderColor: UIColor.gray,maxLength: 10,padding: 20)
        
        
        
        
  
        
        
        
        
        TerminalIDLabel.text = NSLocalizedString("Terminal ID",comment: "")
        TerminalIDTF.setTextFieldStyle(NSLocalizedString("Terminal ID",comment: ""), title: "10002000", textColor: UIColor.black, font:Global.setFont(14) ,
                                       borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: PaySkySDKColor.RaduisNumber , placeholderColor: UIColor.gray,maxLength: 10,padding: 20)
     
        
        AmountLabel.text = NSLocalizedString("Amount",comment: "")
        AmountEd.setTextFieldStyle(NSLocalizedString("Amount",comment: ""), title: "20", textColor: UIColor.black, font:Global.setFont(14) ,
                                       borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: PaySkySDKColor.RaduisNumber , placeholderColor: UIColor.gray,maxLength: 10,padding: 20)
        
        
        CurrencyLabel.text = NSLocalizedString("Currency",comment: "")
        AppName.text = NSLocalizedString("app_name",comment: "")
        CurrencyEd.setTextFieldStyle(NSLocalizedString("Currency",comment: ""), title: "826", textColor: UIColor.black, font:Global.setFont(14) ,
                                   borderWidth: 1, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: PaySkySDKColor.RaduisNumber , placeholderColor: UIColor.gray,maxLength: 10,padding: 20)
        
        
        
        
   
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func PayAction(_ sender: Any) {
        
        
        let paymentViewController = PaymentViewController ()
        paymentViewController.amount = Int(AmountEd.text!)!
        paymentViewController.delegate = self
        
        paymentViewController.mId = MerchantIdEd.text!
        paymentViewController.tId = TerminalIDTF.text!
        paymentViewController.Currency = CurrencyEd.text!

        
        
        paymentViewController.Key = "35393434313266342D636662392D343334612D613765332D646365626337663334386363"
   
        paymentViewController.pushViewController()
        
  
        
        

        
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

