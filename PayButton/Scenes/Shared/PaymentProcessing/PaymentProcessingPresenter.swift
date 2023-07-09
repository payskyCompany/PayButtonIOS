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

    private var urlPath: String

    required init(view: PaymentProcessingView, urlPath: String) {
        self.view = view
        self.urlPath = urlPath
    }

    func viewDidLoad() {
        if let url = URL(string: urlPath) {
            view?.loadWebView(withURL: url)
        }
    }

    func getUrlPath() -> String {
        return urlPath
    }
}
