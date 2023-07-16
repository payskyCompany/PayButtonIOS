//
//  PaymentProcessingPresenter.swift
//  PayButton
//
//  Created by Nada Kamel on 08/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

protocol PaymentProcessingPresenterProtocol: AnyObject {
    var view: PaymentProcessingView? { get set }
    func viewDidLoad()
}

class PaymentProcessingPresenter: PaymentProcessingPresenterProtocol {
    weak var view: PaymentProcessingView?

    private var paymentMethodData: PaymentMethodResponse!
    private var urlPath: String

    required init(view: PaymentProcessingView, paymentMethodData: PaymentMethodResponse, urlPath: String) {
        self.view = view
        self.paymentMethodData = paymentMethodData
        self.urlPath = urlPath
    }

    func viewDidLoad() {
        if let url = URL(string: urlPath) {
            view?.loadWebView(withURL: url)
        }
    }

    func getPaymentMethodData() -> PaymentMethodResponse {
        return paymentMethodData
    }
    
    func getUrlPath() -> String {
        return urlPath
    }
}
