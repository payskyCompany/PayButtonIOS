//
//  MainPresenter.swift
//  PayButton
//
//  Created by Nada Kamel on 01/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

// MARK: - Presenter
protocol MainViewPresenter: AnyObject {
    init(view: PaymentView, paymentMethodData: PaymentMethodResponse)
    func getPaymentMethodData() -> PaymentMethodResponse
    func getCustomerSession(completionHandler: @escaping (String) -> Void)
    func getCustomerCards(usingSessionId sessionId: String)
}

class MainPresenter: MainViewPresenter {
    
    weak var view: PaymentView?
    
    private var paymentMethodData: PaymentMethodResponse!

    required init(view: PaymentView, paymentMethodData: PaymentMethodResponse) {
        self.view = view
        self.paymentMethodData = paymentMethodData
    }
    
    func getPaymentMethodData() -> PaymentMethodResponse {
        return paymentMethodData
    }
    
    func getCustomerSession(completionHandler: @escaping (String) -> Void) {
        view?.startLoading()
        
        let integerAmount = Int(MerchantDataManager.shared.merchant.amount * 100.00)
        let parameters = GetCustomerSessionParameters(customerId: MerchantDataManager.shared.merchant.customerId,
                                                      amount: String(integerAmount),
                                                      merchantId: MerchantDataManager.shared.merchant.merchantId,
                                                      terminalId: MerchantDataManager.shared.merchant.terminalId)
        
        let getCustomerSessionUseCase = GetCustomerSessionUseCase(getCustomerSessionParamters: parameters)
        getCustomerSessionUseCase.getCustomerSession { [self] result in
            view?.endLoading()
            switch result {
            case let .success(response):
                if response.success == true {
                    if response.sessionId != nil {
                        completionHandler(response.sessionId ?? "")
                    }
                }
            case let .failure(error):
                view?.showErrorAlertView(withMessage: error.localizedDescription)
            }
        }
    }
    
    func getCustomerCards(usingSessionId sessionId: String) {
        view?.startLoading()
        
        let integerAmount = Int(MerchantDataManager.shared.merchant.amount * 100.00)
        let parameters = GetCustomerTokenParameters(sessionId: sessionId,
                                                    customerId: MerchantDataManager.shared.merchant.customerId,
                                                    amount: String(integerAmount),
                                                    merchantId: MerchantDataManager.shared.merchant.merchantId,
                                                    terminalId: MerchantDataManager.shared.merchant.terminalId,
                                                    secureHashKey: MerchantDataManager.shared.merchant.secureHashKey)
        
        let getCustomerCardsUseCase = GetCustomerCardsUseCase(getCustomerCardsParamters: parameters)
        getCustomerCardsUseCase.getCustomerCards { [self] result in
            view?.endLoading()
            switch result {
            case let .success(response):
                if response.success == true {
                    if !(response.cardsList?.isEmpty ?? true) {
                        view?.navigateToSelectCardListView(withResponse: response, checkPaymentResponse: paymentMethodData)
                    } else {
                        view?.navigateToAddNewCardView(withResponse: paymentMethodData)
                    }
                } else {
                    view?.showErrorAlertView(withMessage: response.message ?? "")
                }
            case let .failure(error):
                view?.showErrorAlertView(withMessage: error.localizedDescription)
            }
        }
    }
    
}
