//
//  GetCustomerSessionUseCase.swift
//  PayButton
//
//  Created by Hazem-Mohamed on 22/09/2022.
//

import Foundation

typealias GetCustomerSessionUseCaseCompletionHandler = (_ getCustomerSessionResponse: Result<GetCustomerSessionResponse>) -> Void

protocol GetCustomerSessionUseCaseContract {
    func getCustomerSession(completionHandler: @escaping GetCustomerSessionUseCaseCompletionHandler)
}

class GetCustomerSessionUseCase: GetCustomerSessionUseCaseContract {
    
    let getCustomerSessionParamters: GetCustomerSessionParameters
    
    init(getCustomerSessionParamters: GetCustomerSessionParameters) {
        self.getCustomerSessionParamters = getCustomerSessionParamters
    }
    
    func getCustomerSession(completionHandler: @escaping GetCustomerSessionUseCaseCompletionHandler) {
        NetworkManagerImp().sendRequest(apiMethod: .getSessionForCustomerToken(getCustomerSessionParamters), completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(GetCustomerSessionResponse.self, from: data)
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


