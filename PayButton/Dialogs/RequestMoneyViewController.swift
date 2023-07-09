////
////  AlertDialogViewController.swift
////  PayButton
////
////  Created by AMR on 7/4/18.
////  Copyright © 2018 Paysky. All rights reserved.
////
//
//import UIKit
//
//class RequestMoneyViewController: BasePaymentViewController {
//
//    @IBOutlet weak var headerView: UIView!
//    @IBOutlet weak var headerLabel: UILabel!
//    @IBOutlet weak var messageLabel: UILabel!
//    @IBOutlet weak var mobileNumber: UITextField!
//    
//    var sendHandler: ((BaseResponse)->Void)? = nil
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.view.layer.cornerRadius = AppConstants.radiusNumber
//        headerLabel.text = "request_payment".localizedString()
//        messageLabel.text = "enter_mobile_number".localizedString()
//        mobileNumber.setTextFieldStyle("mobile_number".localizedString(),
//                                       title: "",
//                                       textColor: UIColor.black,
//                                       font: GlobalManager.setFont(14),
//                                       borderWidth: 0,
//                                       borderColor: UIColor.clear,
//                                       backgroundColor: UIColor.white,
//                                       cornerRadius: 0,
//                                       placeholderColor: UIColor.gray,
//                                       maxLength: 18,
//                                       padding: 10)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    
//    @IBAction func okAction(_ sender: Any) {
//        if (self.mobileNumber.text?.isEmpty)! {
//            UIApplication.topViewController()?.view.makeToast("mobile_number_valid".localizedString())
//            return
//        }
//        
//        ApiManger.requestToPay(mobileNumber: (self.mobileNumber.text?.replacedArabicDigitsWithEnglish)!) { (base) in
//            if base.Success {
//                if self.sendHandler == nil {
//                    self.dismiss(animated: true, completion: nil)
//                } else {
//                    self.sendHandler!(base)
//                }
//            } else {
//                UIApplication.topViewController()?.showAlert( "error".localizedString(), message:  base.Message)
//            }
//        }
//    }
//
//    
//}
