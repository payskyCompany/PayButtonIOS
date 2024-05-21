//
//  NetworkManager.swift
//  PayButton
//
//  Created by Nada Kamel on 04/08/2022.
//

import Foundation

protocol NetworkManager {
    func sendRequest(apiMethod: ApiClient, completion: @escaping (Result<Data>) -> Void)
}

class NetworkManagerImp: NetworkManager {
    
    private let router = Router<ApiClient>()
    
    func sendRequest(apiMethod: ApiClient, completion: @escaping (Result<Data>) -> Void) {
        router.request(apiMethod) { data, response, error in
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200...299:
                    if let d = data {
                        completion(.success(d))
                    }
                default:
                    if let e = error {
                        completion(.failure(e))
                    }
                }
            }
        }
    }
    
    
}
