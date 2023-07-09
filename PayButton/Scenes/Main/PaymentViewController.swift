//
//  PaymentViewController.swift
//  PayButton
//
//  Created by AMR on 7/8/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit

public protocol PayButtonDelegate: AnyObject {
    func finishedSdkPayment(_ response: PayByCardReponse)
}

protocol PaymentView: AnyObject {
    func startLoading()
    func endLoading()
    func showErrorAlertView(withMessage errorMsg: String)
    func navigateToAddNewCardView(withResponse checkPaymentResponse: PaymentMethodResponse)
    func navigateToSelectCardListView(withResponse allCardResponse: GetCustomerCardsResponse,
                                      checkPaymentResponse: PaymentMethodResponse,
                                      customerSessionId: String)
}

public class PaymentViewController {

    let loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .mainColor
        spinner.hidesWhenStopped = true
        spinner.backgroundColor = .lightText
        spinner.layer.cornerRadius = 20
        spinner.layer.masksToBounds = true
        return spinner
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
    
    private var view: PaymentView!
    
    public weak var delegate: PayButtonDelegate?
  
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
        view = self
        addSpinnerView()
    }
    
    private func addSpinnerView() {
        if let topControllerView = UIApplication.topViewController()?.view {
            topControllerView.addSubview(loadingSpinner)
            loadingSpinner.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
            loadingSpinner.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
            loadingSpinner.centerXAnchor.constraint(equalTo: topControllerView.centerXAnchor).isActive = true
            loadingSpinner.centerYAnchor.constraint(equalTo: topControllerView.centerYAnchor).isActive = true
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
        
        let merchantInfo = MerchantDataModel(merchantId: mId,
                                             terminalId: tId,
                                             amount: amount,
                                             currencyCode: currencyCode,
                                             secureHashKey: secureHashKey,
                                             trnxRefNumber: trnxRefNumber,
                                             customerId: customerId,
                                             customerMobile: customerMobile,
                                             customerEmail: customerEmail)
        if (amount > 0 &&
            !merchantInfo.merchantId.isEmpty &&
            !merchantInfo.terminalId.isEmpty &&
            !merchantInfo.secureHashKey.isEmpty) {
            loadingSpinner.startAnimating()
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
            self.loadingSpinner.stopAnimating()
            UIApplication.topViewController()?.view.isUserInteractionEnabled = true
            switch result {
            case let .success(response):
                if(response.success == true) {
                    MerchantDataManager.shared.saveMerchant(merchantData)
                    
                    let presenter = MainPresenter(view: self.view, paymentMethodData: response)
                    navigateToNextScreen(presenter, withPaymentMethodResponseData: response)
                } else {
                    UIApplication.topViewController()?.showAlert("error".localizedString(), message: response.message ?? "")
                }
            case let .failure(error):
                UIApplication.topViewController()?.showAlert("error".localizedString(), message: error.localizedDescription)
            }
        }
    }
    
    private func navigateToNextScreen(_ presenter: MainPresenter, withPaymentMethodResponseData response: PaymentMethodResponse) {
        if MerchantDataManager.shared.merchant.customerId.isEmpty == false {
            presenter.getCustomerSession() { sessionId in
                presenter.getCustomerCards(usingSessionId: sessionId)
            }
        } else {
            navigateToAddNewCardView(withResponse: response)
        }
    }

    
}

extension PaymentViewController: PaymentView {
    func startLoading() {
        loadingSpinner.startAnimating()
    }

    func endLoading() {
        loadingSpinner.stopAnimating()
    }

    func showErrorAlertView(withMessage errorMsg: String) {
        UIApplication.topViewController()?.showAlert("error".localizedString(), message: errorMsg)
    }

    func navigateToAddNewCardView(withResponse checkPaymentResponse: PaymentMethodResponse) {
        let viewController = AddNewCardVC(nibName: "AddNewCardVC", bundle: nil)
        viewController.delegate = self.delegate
        
        let presenter = AddNewCardPresenter(view: viewController, paymentMethodData: checkPaymentResponse)
        viewController.presenter = presenter
        
        if UIApplication.topViewController()?.navigationController != nil {
            UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
        } else {
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(viewController, animated: true)
        }
    }

    func navigateToSelectCardListView(withResponse allCardResponse: GetCustomerCardsResponse,
                                      checkPaymentResponse: PaymentMethodResponse,
                                      customerSessionId: String) {
        let viewController = SelectCardListVC(nibName: "SelectCardListVC", bundle: nil)
        viewController.delegate = self.delegate
        
        let presenter = SelectCardListPresenter(view: viewController,
                                                paymentMethodData: checkPaymentResponse,
                                                customerCards: allCardResponse,
                                                customerSessionId: customerSessionId)
        viewController.presenter = presenter
        
        if UIApplication.topViewController()?.navigationController != nil {
            UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
        } else {
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(viewController, animated: true)
        }
    }
}
