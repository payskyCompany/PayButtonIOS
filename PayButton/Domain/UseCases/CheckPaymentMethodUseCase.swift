//
//  CheckPaymentMethodUseCase.swift
//  PayButton
//
//  Created by Nada Kamel on 05/08/2022.
//

import Foundation

typealias CheckPaymentMethodUseCaseCompletionHandler = (_ paymentMethodResponse: Result<PaymentMethodResponse>) -> Void

protocol CheckPaymentMethodUseCase {
    func checkPaymentMethod(completionHandler: @escaping CheckPaymentMethodUseCaseCompletionHandler)
}

class CheckPaymentMethodUseCaseImp: CheckPaymentMethodUseCase {
    
    let checkPaymentMethodParamters: PaymentMethodParameters
    
    init(checkPaymentMethodParamters: PaymentMethodParameters) {
        self.checkPaymentMethodParamters = checkPaymentMethodParamters
    }
    
    func checkPaymentMethod(completionHandler: @escaping CheckPaymentMethodUseCaseCompletionHandler) {
        NetworkManagerImp().sendRequest(apiMethod: .checkPaymentMethod(checkPaymentMethodParamters), completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(PaymentMethodResponse.self, from: data)
                        completionHandler(.success(response))
                    } catch {
                        completionHandler(.failure(CoreError(message: "Error decoding CheckPaymentMethod response")))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        })
    }
}
