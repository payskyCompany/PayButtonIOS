//
//  ManageCardsPresenter.swift
//  PayButton
//
//  Created by Nada Kamel on 09/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

protocol ManageCardsPresenterProtocol: AnyObject {
    var view: ManageCardView? { get set }
}

class ManageCardsPresenter: ManageCardsPresenterProtocol {
    weak var view: ManageCardView?

    private var paymentMethodData: PaymentMethodResponse!
    private var customerCards: GetCustomerCardsResponse!
    private var sessionId: String!

    required init(view: ManageCardView,
                  paymentMethodData: PaymentMethodResponse,
                  customerCards: GetCustomerCardsResponse,
                  customerSessionId: String) {
        self.view = view
        self.paymentMethodData = paymentMethodData
        self.customerCards = customerCards
        sessionId = customerSessionId
    }

    func getPaymentMethodData() -> PaymentMethodResponse {
        return paymentMethodData
    }

    func getCustomerCards() -> GetCustomerCardsResponse {
        return customerCards
    }

    func getSessionId() -> String {
        return sessionId
    }

    func callChangeDefaultCardAPI(_ cell: ManageCardsTblCell,
                                  cardToken: String,
                                  cardIndexInList: Int) {
        view?.startLoading()
        let parameters = ChangeDefaultTokenParameters(token: cardToken,
                                                      customerId: MerchantDataManager.shared.merchant.customerId,
                                                      merchantId: MerchantDataManager.shared.merchant.merchantId,
                                                      terminalId: MerchantDataManager.shared.merchant.terminalId)

        let changeDefaultCardUseCase = ChangeDefaultCardUseCase(changeDefaultCardParamters: parameters)
        changeDefaultCardUseCase.changeDefaultCard { [self] result in
            view?.endLoading()
            switch result {
            case let .success(response):
                if response.success == true {
                    for index in 0..<(customerCards.cardsList?.count ?? 0) {
                        if(index == cardIndexInList) {
                            customerCards.cardsList?[index].isDefaultCard = true
                        } else {
                            customerCards.cardsList?[index].isDefaultCard = false
                        }
                    }
                    view?.updateCardsList()
                } else {
                    if response.message == nil {
                        if response.errorDetail == nil {
                            view?.showErrorAlertView(withMessage: "Something went wrong")
                        } else {
                            view?.showErrorAlertView(withMessage: response.errorDetail ?? "")
                        }
                    } else {
                        view?.showErrorAlertView(withMessage: response.message ?? "")
                    }
                }
            case let .failure(error):
                view?.showErrorAlertView(withMessage: error.localizedDescription)
            }
        }
    }
    
    func callRemoveCardAPI(cardToken: String) {
        view?.startLoading()
        let parameters = DeleteTokenParameters(token: cardToken,
                                                      customerId: MerchantDataManager.shared.merchant.customerId,
                                                      merchantId: MerchantDataManager.shared.merchant.merchantId,
                                                      terminalId: MerchantDataManager.shared.merchant.terminalId)
        
        let deleteSavedCardUseCase = DeleteSavedCardUseCase(deleteSavedCardParamters: parameters)
        deleteSavedCardUseCase.deleteSavedCard { [self] result in
            view?.endLoading()
            switch result {
            case let .success(response):
                if response.success == true {
                    view?.didRemoveCard()
                } else {
                    if response.message == nil {
                        if response.errorDetail == nil {
                            view?.showErrorAlertView(withMessage: "Something went wrong")
                        } else {
                            view?.showErrorAlertView(withMessage: response.errorDetail ?? "")
                        }
                    } else {
                        view?.showErrorAlertView(withMessage: response.message ?? "")
                    }
                }
            case let .failure(error):
                view?.showErrorAlertView(withMessage: error.localizedDescription)
            }
        }
    }
    
    func getCustomerSession(completionHandler: @escaping (String) -> Void) {
        view?.startLoading()

        let parameters = GetCustomerSessionParameters(customerId: MerchantDataManager.shared.merchant.customerId,
                                                      amount: String(MerchantDataManager.shared.merchant.amount),
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

        let integerAmount = Int(MerchantDataManager.shared.merchant.amount)
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
                        customerCards = response
                        view?.updateCardsList()
                    } else {
                        view?.dismissView()
//                        view?.navigateToSelectCardListView(withResponse: customerCards,
//                                                           checkPaymentResponse: paymentMethodData,
//                                                           customerSessionId: sessionId)
                    }
                }
            case let .failure(error):
                view?.showErrorAlertView(withMessage: error.localizedDescription)
            }
        }
    }
}
