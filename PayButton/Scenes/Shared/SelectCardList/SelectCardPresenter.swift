//
//  SelectCardPresenter.swift
//  PayButton
//
//  Created by Nada Kamel on 01/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

// MARK: - View Protocol
protocol SavedCardPaymentViewProtocol: AnyObject {
    func setSavedCardAmountTextField(withValue amount: String)
    func didTapToggleButton(forCell selectedCell: CardListTblCell)
    func didTapDeleteIconButton(forCell selectedCell: CardListTblCell)
    func didTapCvvTextField(forCell selectedCell: CardListTblCell)
    func openWebView(withUrlPath path: String)
    func navigateToPaymentApprovedView(withTrxnReference reference: String, andMessage message: String)
    func navigateToPaymentRejectedView(withMessage text: String)
    func onPayBtnTapped()
    func didDeleteCardSuccessfully()
    func updateSavedCardList(withAllCardResponse: GetCustomerCardsResponse)
    func navigateToAddNewCardView()
    func navigateToAddNewCard(withAllCardResponse: GetCustomerCardsResponse)
    func startLoading()
    func endLoading()
}

// MARK: - Presenter
protocol SavedCardPaymentPresenterProtocol: AnyObject {
    var view: SavedCardPaymentViewProtocol? { get set }
    func viewDidLoad()
    func getPaymentMethodData() -> PaymentMethodResponse
    func callPayBySavedCardAPI(customerSession: String, cardID: Int, cvv: String)
    func deleteSavedCardAPI(token: String, customerID: String)
    func getCustomerSession(completionHandler: @escaping (String) -> Void)
    func getCustomerCards(usingSessionId sessionId: String)
}

class SavedCardPaymentPresenter: SavedCardPaymentPresenterProtocol {
    
    weak var view: SavedCardPaymentViewProtocol?
    
    private var paymentMethodData: PaymentMethodResponse!
    
    required init(view: SavedCardPaymentViewProtocol,
                  paymentMethodData: PaymentMethodResponse) {
        self.view = view
        self.paymentMethodData = paymentMethodData
    }
    
    func viewDidLoad() {
        view?.setSavedCardAmountTextField(withValue: String(MerchantDataManager.shared.merchant.amount))
    }
    
    func getPaymentMethodData() -> PaymentMethodResponse {
        return paymentMethodData
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
    
    func deleteSavedCardAPI(token: String, customerID: String) {
        view?.startLoading()
        
        let parameters = DeleteTokenParameters(token: token,
                                               customerId: customerID,
                                               merchantId: MerchantDataManager.shared.merchant.merchantId,
                                               terminalId: MerchantDataManager.shared.merchant.terminalId,
                                               secureHashKey: MerchantDataManager.shared.merchant.secureHashKey)
        
        let deleteSavedCardUseCase = DeleteSavedCardUseCase(deleteSavedCardParamters: parameters)
        deleteSavedCardUseCase.deleteSavedCard { [self] result in
            view?.endLoading()
            switch result {
            case let .success(response):
                if(response.success == true) {
                    view?.didDeleteCardSuccessfully()
                } else {
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
                        view?.navigateToAddNewCard(withAllCardResponse: response)
                    }
                }
            case let .failure(error):
                view?.navigateToPaymentRejectedView(withMessage: error.localizedDescription)
            }
        }
    }
}
