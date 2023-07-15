//
//  SelectCardListPresenter.swift
//  PayButton
//
//  Created by Nada Kamel on 01/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

protocol SelectCardListPresenterProtocol: AnyObject {
    var view: SelectCardListView? { get set }
    func viewDidLoad()
    func callPayByCardAPI(cardID: Int, cvv: String)
    func callGetCustomerSessionAPI(completionHandler: @escaping (String) -> Void)
    func callGetCustomerCardsAPI(usingSessionId sessionId: String)
}

class SelectCardListPresenter: SelectCardListPresenterProtocol {
    weak var view: SelectCardListView?

    private var paymentMethodData: PaymentMethodResponse!
    private var customerCards: GetCustomerCardsResponse!
    private var sessionId: String!

    required init(view: SelectCardListView,
                  paymentMethodData: PaymentMethodResponse,
                  customerCards: GetCustomerCardsResponse,
                  customerSessionId: String) {
        self.view = view
        self.paymentMethodData = paymentMethodData
        self.customerCards = customerCards
        sessionId = customerSessionId
    }

    func viewDidLoad() {
        callGetCustomerSessionAPI { _sessionId in
            self.callGetCustomerCardsAPI(usingSessionId: _sessionId)
        }
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

    func callPayByCardAPI(cardID: Int, cvv: String) {
        view?.startLoading()

        let integerAmount = Int(MerchantDataManager.shared.merchant.amount * 100.00)
        let parameters = TokenizedCardParameters(amountTrxn: String(integerAmount),
                                                 merchantId: MerchantDataManager.shared.merchant.merchantId,
                                                 terminalId: MerchantDataManager.shared.merchant.terminalId,
                                                 secureHashKey: MerchantDataManager.shared.merchant.secureHashKey,
                                                 cvv: cvv,
                                                 tokenCustomerId: MerchantDataManager.shared.merchant.customerId,
                                                 tokenCustomerSession: sessionId,
                                                 tokenCardId: String(cardID))

        let payByTokenizedCardUseCase = PayByTokenizedCardUseCaseImp(tokenizedCardParamters: parameters)
        payByTokenizedCardUseCase.payByTokenizedCard { [self] result in
            view?.endLoading()
            switch result {
            case let .success(response):
                if response.success == true {
                    if response.tokenCustomerId != "" && response.tokenCustomerId != nil {
                        MerchantDataManager.shared.merchant.customerId = response.tokenCustomerId ?? ""
                    }
                    // if challenge required, open web view with 3DS URL in response
                    if response.challengeRequired == true {
                        if let threeDSURLString = response.threeDSUrl {
                            view?.navigateToProcessingPaymentView(withUrlPath: threeDSURLString)
                        }
                    } else {
                        // if the executed transaction action code is not equal to 00
                        if response.actionCode == nil || response.actionCode?.isEmpty == true || !(response.actionCode == "00") {
                            // transaction failed
                            view?.showErrorAlertView(withMessage: String(response.message ?? ""))
                        } else {
                            // transaction approved
                            view?.navigateToPaymentApprovedView(withTrxnResponse: response)
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

    func callGetCustomerSessionAPI(completionHandler: @escaping (String) -> Void) {
        view?.startLoading()

        let parameters = GetCustomerSessionParameters(customerId: MerchantDataManager.shared.merchant.customerId,
                                                      amount: String(MerchantDataManager.shared.merchant.amount),
                                                      merchantId: MerchantDataManager.shared.merchant.merchantId,
                                                      terminalId: MerchantDataManager.shared.merchant.terminalId,
                                                      secureHashKey: MerchantDataManager.shared.merchant.secureHashKey)

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

    func callGetCustomerCardsAPI(usingSessionId sessionId: String) {
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
                        view?.updateSavedCardList()
                    } else {
                        view?.navigateToAddNewCardView(withCheckPaymentResponse: paymentMethodData)
                    }
                }
            case let .failure(error):
                view?.showErrorAlertView(withMessage: error.localizedDescription)
            }
        }
    }
}
