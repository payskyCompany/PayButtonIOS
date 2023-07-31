//
//  GetCustomerCardsUseCase.swift
//  PayButton
//
//  Created by Hazem-Mohamed on 22/09/2022.
//

import Foundation

typealias GetCustomerCardsUseCaseCompletionHandler = (_ getCustomerCardsResponse: Result<GetCustomerCardsResponse>) -> Void

protocol GetCustomerCardsUseCaseContract {
    func getCustomerCards(completionHandler: @escaping GetCustomerCardsUseCaseCompletionHandler)
}

class GetCustomerCardsUseCase: GetCustomerCardsUseCaseContract {
    
    let getCustomerCardsParamters: GetCustomerTokenParameters
    
    init(getCustomerCardsParamters: GetCustomerTokenParameters) {
        self.getCustomerCardsParamters = getCustomerCardsParamters
    }
    
    func getCustomerCards(completionHandler: @escaping GetCustomerCardsUseCaseCompletionHandler) {
        NetworkManagerImp().sendRequest(apiMethod: .getAllCardsForCustomerToken(getCustomerCardsParamters), completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(GetCustomerCardsResponse.self, from: data)
                        completionHandler(.success(response))
                    } catch {
                        completionHandler(.failure(CoreError(message: "Error decoding GetCustomerSession response")))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        })
    }
}


