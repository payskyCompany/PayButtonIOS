//
//  CheckTransactionStatusUseCase.swift
//  OoredooPayButton
//
//  Created by Nada Kamel on 19/09/2022.
//

import Foundation

typealias CheckTxnStatusUseCaseCompletionHandler = (_ checkTxnStatusResponse: Result<CheckTransactionStatusResponse>) -> Void

protocol CheckTransactionStatusUseCase {
    func checkTxnStatus(completionHandler: @escaping CheckTxnStatusUseCaseCompletionHandler)
}

class CheckTransactionStatusUseCaseImp: CheckTransactionStatusUseCase {
    
    let checkTxnStatusParameters: CheckTransactionStatusParameters
    
    init(checkTxnStatusParameters: CheckTransactionStatusParameters) {
        self.checkTxnStatusParameters = checkTxnStatusParameters
    }
    
    func checkTxnStatus(completionHandler: @escaping CheckTxnStatusUseCaseCompletionHandler) {
        NetworkManagerImp().sendRequest(apiMethod: .checkTransactionStatus(checkTxnStatusParameters), completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(CheckTransactionStatusResponse.self, from: data)
                        completionHandler(.success(response))
                    } catch {
                        completionHandler(.failure(CoreError(message: "Error decoding CheckTransactionStatus response")))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        })
    }
}
