//
//  AddNewCardPresenter.swift
//  PayButton
//
//  Created by Nada Kamel on 01/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

protocol AddNewCardPresenterProtocol: AnyObject {
    var view: AddNewCardView? { get set }
    func viewDidLoad()
    func getPaymentMethodData() -> PaymentMethodResponse
    func updateIsSaveCard(withValue state: Bool)
    func updateIsDefaultCard(withValue state: Bool)
    func callPayByCardAPI(cardNumber: String, cardHolderName: String, expiryDate: String, cvv: String)
}

class AddNewCardPresenter: AddNewCardPresenterProtocol {
    
    weak var view: AddNewCardView?
    
    private var paymentMethodData: PaymentMethodResponse!
    private var customerSessionId: String?
    
    private var isSaveCardSelected: Bool = false
    private var isDefaultCardSelected: Bool = false
    
    required init(view: AddNewCardView,
                  paymentMethodData: PaymentMethodResponse,
                  sessionId: String? = nil) {
        self.view = view
        self.paymentMethodData = paymentMethodData
        customerSessionId = sessionId
    }
    
    func viewDidLoad() {
        if(paymentMethodData.isTokenized == false) {
            view?.hideSaveThisCardOutlets()
        }
    }
    
    func getPaymentMethodData() -> PaymentMethodResponse {
        return paymentMethodData
    }
    
    func updateIsSaveCard(withValue state: Bool) {
        isSaveCardSelected = state
    }
    
    func updateIsDefaultCard(withValue state: Bool) {
        isDefaultCardSelected = state
    }
    
    func callPayByCardAPI(cardNumber: String, cardHolderName: String, expiryDate: String, cvv: String)  {
        view?.startLoading()
        
        let integerAmount = Int(MerchantDataManager.shared.merchant.amount * 100.00)
        let parameters = PayByCardParameters(amountTrxn: String(integerAmount),
                                             merchantId: MerchantDataManager.shared.merchant.merchantId,
                                             terminalId: MerchantDataManager.shared.merchant.terminalId,
                                             secureHashKey: MerchantDataManager.shared.merchant.secureHashKey,
                                             cardNumber: cardNumber,
                                             cardHolderName: cardHolderName,
                                             expiryDate: expiryDate,
                                             cvv: cvv,
                                             isSaveCard: isSaveCardSelected,
                                             isDefaultCard: isDefaultCardSelected,
                                             tokenCustomerId: MerchantDataManager.shared.merchant.customerId,
                                             customerMobileNo: MerchantDataManager.shared.merchant.customerMobile,
                                             customerEmail: MerchantDataManager.shared.merchant.customerEmail)
        
        let payByCardUseCase = PayByCardUseCaseImp(payByCardParamters: parameters)
        payByCardUseCase.payByCard { [self] result in
            view?.endLoading()
            switch result {
            case let .success(response):
                if(response.success == true) {
                    if response.tokenCustomerId != "" && response.tokenCustomerId != nil {
                        MerchantDataManager.shared.merchant.customerId = response.tokenCustomerId ?? ""
                    }
                    // if challenge required, open web view with 3DS URL in response
                    if(response.challengeRequired == true) {
                        if let threeDSURLString = response.threeDSUrl {
                            view?.openWebView(withUrlPath: threeDSURLString)
                        }
                    } else {
                        // if the executed transaction action code is not equal to 00
                        if (response.actionCode == nil || response.actionCode?.isEmpty == true || !(response.actionCode == "00")) {
                            // transaction failed
                            view?.showErrorAlertView(withMessage: String(response.message ?? ""))
                        } else {
                            // transaction approved
                            view?.navigateToPaymentApprovedView(withTrxnReference: String(response.systemReference ?? 0),
                                                                andMessage: response.message ?? "")
                        }
                    }
                } else {
                    // transaction failed
                    view?.showErrorAlertView(withMessage: String(response.message ?? ""))
                }
            case let .failure(error):
                view?.showErrorAlertView(withMessage: error.localizedDescription)
            }
        }
    }
}
