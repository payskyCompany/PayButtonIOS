//
//  SelectCardListPresenter.swift
//  PayButton
//
//  Created by Nada Kamel on 01/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

protocol SelectCardListPresenterProtocol: AnyObject {
    var view: SelectCardListViewProtocol? { get set }
    func callPayBySavedCardAPI(customerSession: String, cardID: Int, cvv: String)
    func getCustomerSession(completionHandler: @escaping (String) -> Void)
    func getCustomerCards(usingSessionId sessionId: String)
}

class SelectCardListPresenter: SelectCardListPresenterProtocol {
    
    weak var view: SelectCardListViewProtocol?
    
    private var paymentMethodData: PaymentMethodResponse!
    private var customerCards: GetCustomerCardsResponse!
    
    required init(view: SelectCardListViewProtocol,
                  paymentMethodData: PaymentMethodResponse,
                  customerCards: GetCustomerCardsResponse) {
        self.view = view
        self.paymentMethodData = paymentMethodData
        self.customerCards = customerCards
    }
    
    func getPaymentMethodData() -> PaymentMethodResponse {
        return paymentMethodData
    }
    
    func getCustomerCards() -> GetCustomerCardsResponse {
        return customerCards
    }
    
    func callPayBySavedCardAPI(customerSession: String, cardID: Int, cvv: String) {
        view?.startLoading()
        
        let integerAmount = Int(MerchantDataManager.shared.merchant.amount * 100.00)
        let parameters = PayByCardParameters(amountTrxn: String(integerAmount),
                                             merchantId: MerchantDataManager.shared.merchant.merchantId,
                                             terminalId: MerchantDataManager.shared.merchant.terminalId,
                                             secureHashKey: MerchantDataManager.shared.merchant.secureHashKey,
                                             cvv: cvv,
                                             isSaveCard: false,
                                             tokenCustomerId: MerchantDataManager.shared.merchant.customerId,
                                             tokenCustomerSession: customerSession,
                                             tokenCardId: cardID,
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
                            view?.navigateToPaymentRejectedView(withMessage: String(response.message ?? ""))
                        } else {
                            // transaction approved
                            view?.navigateToPaymentApprovedView(withTrxnReference: String(response.systemReference ?? 0), andMessage: response.message ?? "")
                        }
                    }
                } else {
                    // transaction failed
                    view?.navigateToPaymentRejectedView(withMessage: String(response.message ?? ""))
                }
            case let .failure(error):
                view?.navigateToPaymentRejectedView(withMessage: error.localizedDescription)
            }
        }
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
                view?.navigateToPaymentRejectedView(withMessage: error.localizedDescription)
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
                        view?.updateSavedCardList(withAllCardResponse: response)
                    } else {
                        view?.navigateToAddNewCardView(withCheckPaymentResponse: paymentMethodData)
                    }
                }
            case let .failure(error):
                view?.navigateToPaymentRejectedView(withMessage: error.localizedDescription)
            }
        }
    }
}
