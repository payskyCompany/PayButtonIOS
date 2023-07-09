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
}
