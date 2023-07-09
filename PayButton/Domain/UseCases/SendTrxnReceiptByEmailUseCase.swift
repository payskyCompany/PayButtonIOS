//
//  SendTrxnReceiptByEmailUseCase.swift
//  PayButton
//
//  Created by Nada Kamel on 09/07/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

typealias SendTrxnReceiptByEmailUseCaseCompletionHandler = (_ sendReceiptByEmailResponse: Result<SendReceiptByEmailResponse>) -> Void

protocol SendTrxnReceiptByEmailUseCaseContract {
    func sendReceiptByEmail(completionHandler: @escaping SendTrxnReceiptByEmailUseCaseCompletionHandler)
}

class SendTrxnReceiptByEmailUseCase: SendTrxnReceiptByEmailUseCaseContract {
    let sendReceiptByEmailParameters: SendReceiptByEmailParameters

    init(sendReceiptByEmailParameters: SendReceiptByEmailParameters) {
        self.sendReceiptByEmailParameters = sendReceiptByEmailParameters
    }

    func sendReceiptByEmail(completionHandler: @escaping SendTrxnReceiptByEmailUseCaseCompletionHandler) {
        NetworkManagerImp().sendRequest(apiMethod: .sendReceiptByEmail(sendReceiptByEmailParameters), completion: { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    do {
                        let response = try JSONDecoder().decode(SendReceiptByEmailResponse.self, from: data)
                        completionHandler(.success(response))
                    } catch {
                        completionHandler(.failure(CoreError(message: "Error decoding SendReceiptByEmail response")))
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            }
        })
    }
}
