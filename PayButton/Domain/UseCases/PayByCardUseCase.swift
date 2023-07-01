//
//  PayByCardUseCase.swift
//  PayButton
//
//  Created by Nada Kamel on 09/09/2022.
//

import Foundation

typealias PayByCardUseCaseCompletionHandler = (_ payByCardResponse: Result<PayByCardReponse>) -> Void

protocol PayByCardUseCase {
    func payByCard(completionHandler: @escaping PayByCardUseCaseCompletionHandler)
}

class PayByCardUseCaseImp: PayByCardUseCase {
    
    let payByCardParamters: PayByCardParameters
    
    init(payByCardParamters: PayByCardParameters) {
        self.payByCardParamters = payByCardParamters
    }
    
    func payByCard(completionHandler: @escaping PayByCardUseCaseCompletionHandler) {
        NetworkManagerImp().sendRequest(apiMethod: .payByCard(payByCardParamters), completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(PayByCardReponse.self, from: data)
                        completionHandler(.success(response))
                    } catch {
                        completionHandler(.failure(CoreError(message: "Error decoding PayByCard response")))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        })
    }
}

