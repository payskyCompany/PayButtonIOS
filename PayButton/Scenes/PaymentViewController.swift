//
//  PaymentViewController.swift
//  PayButton
//
//  Created by AMR on 7/8/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit

public protocol PaymentDelegate: AnyObject {
    func finishedSdkPayment(_ transactionStatus: TransactionStatusResponse, withCustomerId customer: String)
}

public class PaymentViewController  {

    let loginSpinner: UIActivityIndicatorView = {
        let loginSpinner = UIActivityIndicatorView(style: .large)
        loginSpinner.translatesAutoresizingMaskIntoConstraints = false
        loginSpinner.color = .mainBtnColor
        loginSpinner.hidesWhenStopped = true
        loginSpinner.backgroundColor = .lightText
        loginSpinner.layer.cornerRadius = 20
        loginSpinner.layer.masksToBounds = true
        return loginSpinner
    }()
    
    let mId: String
    let tId: String
    let amount: Double
    let currencyCode: Int
    let secureHashKey: String
    let trnxRefNumber: String
    let customerId: String
    let customerMobile: String
    let customerEmail: String
    
    public weak var delegate: PaymentDelegate?
    
    init(merchantId: String, terminalId: String, amount: Double, currencyCode: Int,
         secureHashKey: String, trnxRefNumber: String = "", customerId: String = "",
         customerMobile: String = "", customerEmail: String = "", isProduction: Bool = false) {
        mId = merchantId
        tId = terminalId
        self.amount = amount
        self.currencyCode = currencyCode
        self.secureHashKey = secureHashKey
        self.trnxRefNumber = trnxRefNumber
        self.customerId = customerId
        self.customerMobile = customerMobile
        self.customerEmail = customerEmail
        MerchantDataManager.shared.isProduction = isProduction
        AppConstants.selectedCountryCode = currencyCode
        addSpinnerView()
    }
    
    private func addSpinnerView() {
        if let topControllerView = UIApplication.topViewController()?.view {
            topControllerView.addSubview(loginSpinner)
            loginSpinner.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
            loginSpinner.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
            loginSpinner.centerXAnchor.constraint(equalTo: topControllerView.centerXAnchor).isActive = true
            loginSpinner.centerYAnchor.constraint(equalTo: topControllerView.centerYAnchor).isActive = true
        }
    }
    
    private func validateData() {
        if delegate == nil {
            print("Missing SDK Delegate implementation")
            return
        }
        if(mId.isEmpty) {
            print("Missing required data: Merchant ID")
            return
        }
        if(tId.isEmpty) {
            print("Missing required data: Terminal ID")
            return
        }
        if(secureHashKey.isEmpty) {
            print("Missing required data: Secure Hash Key")
            return
        }
        if(amount == 0) {
            print("Missing required data: Amount")
            return
        }
        if(currencyCode == 0) {
            print("Missing required data: Secure Hash Key")
            return
        }
        if(customerId.isEmpty) {
            if(customerMobile.isEmpty && customerEmail.isEmpty) {
                print("Missing required data: Customer Mobile (OR) Cutomer Email")
                return
            }
        }
    }
    
    public func pushViewController()  {
        validateData()
        
        var doubleAmount = Double(self.amount)
        doubleAmount = doubleAmount * 100.00
        
//        let paymentData = PaymentData()
//
//        paymentData.amount = doubleAmount
//        paymentData.refnumber = trnxRefNumber
//
//        paymentData.merchantId = mId
//        paymentData.terminalId = tId
//        paymentData.key = secureHashKey
//        paymentData.currencyCode = currencyCode
//
//        if(paymentData.amount != 0
//           && !paymentData.merchantId.isEmpty
//           && !paymentData.key.isEmpty
//           && paymentData.currencyCode != 0
//           && !paymentData.terminalId.isEmpty) {
//            print(ApiURL.MAIN_API_LINK)
//            RegiserOrGetOldToken(paymentData: paymentData)
//       } else {
//           print("Please enter all  data")
//           return
//       }
        
        let merchantInfo = MerchantDataModel(merchantId: mId,
                                             terminalId: tId,
                                             amount: amount,
                                             currencyCode: currencyCode,
                                             secureHashKey: secureHashKey,
                                             customerId: customerId,
                                             customerMobile: customerMobile,
                                             customerEmail: customerEmail)
        if (amount > 0 &&
            !merchantInfo.merchantId.isEmpty &&
            !merchantInfo.terminalId.isEmpty &&
            !merchantInfo.secureHashKey.isEmpty) {
            loginSpinner.startAnimating()
            UIApplication.topViewController()?.view.isUserInteractionEnabled = false
            callCheckPaymentMethodAPI(merchantData: merchantInfo)
        } else {
            print("Missing required data")
            return
        }
    }
    
    private func callCheckPaymentMethodAPI(merchantData: MerchantDataModel) {
        let paymentMethodParameters = PaymentMethodParameters(merchantId: merchantData.merchantId,
                                                              terminalId: merchantData.terminalId,
                                                              secureHashKey: merchantData.secureHashKey)
        let checkPaymentMethodUseCase = CheckPaymentMethodUseCaseImp(checkPaymentMethodParamters: paymentMethodParameters)
        checkPaymentMethodUseCase.checkPaymentMethod { [self] result in
            self.loginSpinner.stopAnimating()
            UIApplication.topViewController()?.view.isUserInteractionEnabled = true
            switch result {
            case let .success(response):
                if(response.success == true) {
                    MerchantDataManager.shared.saveMerchant(merchantData)
                    navigateToAddNewCardViewController(withPaymentMethodData: response)
                } else {
                    UIApplication.topViewController()?.showAlert("error".localizedString(), message: response.message ?? "")
                }
            case let .failure(error):
                UIApplication.topViewController()?.showAlert("error".localizedString(), message: error.localizedDescription)
            }
        }
    }
    
    private func navigateToAddNewCardViewController(withPaymentMethodData: PaymentMethodResponse) {
        let viewController = AddNewCardVC(nibName: "AddNewCardVC", bundle: nil)
        
        if UIApplication.topViewController()?.navigationController != nil {
            UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
        } else {
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(viewController, animated: true)
        }
    }
    
    
//    private func registerOrGetOldToken(paymentData: PaymentData)  {
//        MainScanViewController.paymentData = paymentData
//        MainScanViewController.paymentData.amount = (MainScanViewController.paymentData.amount)
//        ApiManger.CheckPaymentMethod { (paymentresponse) in
//
//            if paymentresponse?.success {
//                MainScanViewController.paymentData.merchant_name = paymentresponse.MerchantName
//                MainScanViewController.paymentData.currencyCode = self.currencyCode
//                    MainScanViewController.paymentData.PaymentMethod = paymentresponse.PaymentMethod
//                MainScanViewController.paymentData.Is3DS = paymentresponse.Is3DS
//
//                self.getStaticQr()
//            } else {
//                if paymentresponse.Message == "" {
//                     UIApplication.topViewController()?.view.makeToast("Authentication failed")
//                }
//                else {
//                UIApplication.topViewController()?.view.makeToast(  paymentresponse.Message)
//                }
//            }
//
//        }
//    }
//
//    private func getStaticQr() {
//        if  MainScanViewController.paymentData.PaymentMethod == 1 ||
//                MainScanViewController.paymentData.PaymentMethod == 2 {
//
//            ApiManger.generateQrCode { (qrResponse) in
//                MainScanViewController.paymentData.staticQR = qrResponse.ISOQR
//                MainScanViewController.paymentData.orderId = qrResponse.TxnId
//
//                self.gotoNextPage()
//            }
//        } else {
//            self.gotoNextPage()
//        }
//    }
//
//    private func gotoNextPage() {
//        UIApplication.topViewController()?.view.hideLoadingIndicator()
//
//        let psb = UIStoryboard.init(name: "PayButtonBoard", bundle: nil)
//        let vc :MainScanViewController = psb.instantiateViewController(withIdentifier: "MainScanViewController") as! MainScanViewController
//        vc.delegate = self.delegate
//        if UIApplication.topViewController()?.navigationController != nil {
//            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
//            vc.fromNav = true
//        }else{
//            vc.modalPresentationStyle = .fullScreen
//            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
//            vc.fromNav = false
//
//        }
//    }
    
    
}
