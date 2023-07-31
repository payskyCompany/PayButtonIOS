//
//  PayByTokenizedCardUseCase.swift
//  PayButton
//
//  Created by Nada Kamel on 06/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

typealias PayByTokenizedCardUseCaseCompletionHandler = (_ payByCardResponse: Result<PayByCardReponse>) -> Void

protocol PayByTokenizedCardUseCase {
    func payByTokenizedCard(completionHandler: @escaping PayByTokenizedCardUseCaseCompletionHandler)
}

class PayByTokenizedCardUseCaseImp: PayByTokenizedCardUseCase {
    let tokenizedCardParamters: TokenizedCardParameters

    init(tokenizedCardParamters: TokenizedCardParameters) {
        self.tokenizedCardParamters = tokenizedCardParamters
    }

    func payByTokenizedCard(completionHandler: @escaping PayByTokenizedCardUseCaseCompletionHandler) {
        NetworkManagerImp().sendRequest(apiMethod: .payByTokenizedCard(tokenizedCardParamters), completion: { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    do {
                        let response = try JSONDecoder().decode(PayByCardReponse.self, from: data)
                        completionHandler(.success(response))
                    } catch {
                        completionHandler(.failure(CoreError(message: "Error decoding Tokenized PayByCardReponse response")))
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            }
        })
    }
}
