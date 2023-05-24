//
//  Result.swift
//  PayButton
//
//  Created by Nada Kamel on 29/07/2022.
//  Copyright © 2022 PaySky. All rights reserved.
//

import Foundation

typealias Result<T> = Swift.Result<T, Error>

struct CoreError: Error {
    var localizedDescription: String {
        return message
    }
    
    var message = ""
}
