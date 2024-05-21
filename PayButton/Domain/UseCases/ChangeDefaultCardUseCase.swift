//
//  ChangeDefaultCardUseCase.swift
//  PayButton
//
//  Created by Nada Kamel on 09/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

typealias ChangeDefaultCardUseCaseCompletionHandler = (_ changeDefaultTokenResponse: Result<ChangeDefaultTokenResponse>) -> Void

protocol ChangeDefaultCardUseCaseContract {
    func changeDefaultCard(completionHandler: @escaping ChangeDefaultCardUseCaseCompletionHandler)
}

class ChangeDefaultCardUseCase: ChangeDefaultCardUseCaseContract {
    let changeDefaultTokenParameters: ChangeDefaultTokenParameters

    init(changeDefaultCardParamters: ChangeDefaultTokenParameters) {
        changeDefaultTokenParameters = changeDefaultCardParamters
    }

    func changeDefaultCard(completionHandler: @escaping ChangeDefaultCardUseCaseCompletionHandler) {
        NetworkManagerImp().sendRequest(apiMethod: .changeDefaultToken(changeDefaultTokenParameters), completion: { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    do {
                        let response = try JSONDecoder().decode(ChangeDefaultTokenResponse.self, from: data)
                        completionHandler(.success(response))
                    } catch {
                        completionHandler(.failure(CoreError(message: "Error decoding ChangeDefaultToken response")))
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            }
        })
    }
}
