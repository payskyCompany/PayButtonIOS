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

    private var payByCardResponse: PayByCardReponse
    private var paymentApprovedMessage: String
    private var transactionReferenceNo: Int

    required init(view: PaymentApprovedView, payByCardResponse: PayByCardReponse) {
        self.view = view
        self.payByCardResponse = payByCardResponse
        transactionReferenceNo = payByCardResponse.systemReference ?? 0
        paymentApprovedMessage = payByCardResponse.message ?? ""
    }

    func viewDidLoad() {
        view?.setReferenceNoLabel(withText: String(transactionReferenceNo))
        view?.setSuccessMessageLabel(withText: paymentApprovedMessage)
    }

    func getPayByCardReponse() -> PayByCardReponse {
        return payByCardResponse
    }
}
