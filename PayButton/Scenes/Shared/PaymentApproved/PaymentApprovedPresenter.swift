//
//  PaymentApprovedPresenter.swift
//  PayButton
//
//  Created by Nada Kamel on 08/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

protocol PaymentApprovedPresenterProtocol: AnyObject {
    var view: PaymentApprovedView? { get set }
    func viewDidLoad()
    func getPayByCardReponse() -> PayByCardReponse
}

class PaymentApprovedPresenter: PaymentApprovedPresenterProtocol {
    weak var view: PaymentApprovedView?

    private var paymentMethodData: PaymentMethodResponse
    private var payByCardResponse: PayByCardReponse
    private var authCode: String
    private var transactionReferenceNo: Int

    required init(view: PaymentApprovedView, paymentMethodData: PaymentMethodResponse, payByCardResponse: PayByCardReponse) {
        self.view = view
        self.paymentMethodData = paymentMethodData
        self.payByCardResponse = payByCardResponse
        authCode = payByCardResponse.authCode ?? ""
        transactionReferenceNo = payByCardResponse.systemReference ?? 0
    }

    func viewDidLoad() {
        view?.setAuthCodeLabel(withText: authCode)
        view?.setTransactionNoLabel(withText: String(transactionReferenceNo))
    }

    func getPaymentMethodData() -> PaymentMethodResponse {
        return paymentMethodData
    }
    
    func getPayByCardReponse() -> PayByCardReponse {
        return payByCardResponse
    }

    func sendEmail(emailTo: String, externalReceiptNo: String, transactionChannel: String, transactionId: String) {
        view?.startLoading()

        let parameters = SendReceiptByEmailParameters(emailTo: emailTo,
                                                      externalReceiptNumber: externalReceiptNo,
                                                      externalReceiptNo: externalReceiptNo,
                                                      transactionId: transactionId,
                                                      transactionChannel: transactionChannel)

        let sendTrxnReceiptByEmailUseCase = SendTrxnReceiptByEmailUseCase(sendReceiptByEmailParameters: parameters)
        sendTrxnReceiptByEmailUseCase.sendReceiptByEmail { [self] result in
            view?.endLoading()
            switch result {
            case let .success(response):
                if response.success == true {
                    view?.didSendTrxnReceiptByEmail()
                } else {
                    view?.showErrorAlertView(withMessage: response.message ?? "")
                }
            case let .failure(error):
                view?.showErrorAlertView(withMessage: error.localizedDescription)
            }
        }
    }
}
