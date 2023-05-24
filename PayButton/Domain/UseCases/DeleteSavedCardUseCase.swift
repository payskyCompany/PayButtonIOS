//
//  DeleteSavedCardUseCase.swift
//  OoredooPayButton
//
//  Created by Hazem-Mohamed on 27/09/2022.
//

import Foundation

typealias DeleteSavedCardUseCaseCompletionHandler = (_ deleteSavedCardResponse: Result<DeleteTokenResponse>) -> Void

protocol DeleteSavedCardUseCaseContract {
    func deleteSavedCard(completionHandler: @escaping DeleteSavedCardUseCaseCompletionHandler)
}

class DeleteSavedCardUseCase: DeleteSavedCardUseCaseContract {
    
    let deleteSavedCardParamters: DeleteTokenParameters
    
    init(deleteSavedCardParamters: DeleteTokenParameters) {
        self.deleteSavedCardParamters = deleteSavedCardParamters
    }
    
    func deleteSavedCard(completionHandler: @escaping DeleteSavedCardUseCaseCompletionHandler) {
        NetworkManagerImp().sendRequest(apiMethod: .deleteToken(deleteSavedCardParamters), completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(DeleteTokenResponse.self, from: data)
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
