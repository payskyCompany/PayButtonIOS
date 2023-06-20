//
//  Enums.swift
//  PayButton
//
//  Created by Nada Kamel on 18/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

enum Environment: CustomStringConvertible {
    case Grey
    case Production
    
    var description: String {
        switch self {
            case .Grey: return "https://grey.paysky.io"
            case .Production: return "https://cube.paysky.io"
        }
    }
}

enum CountryCodes {
    case egypt
    case uae
    case qatar
    
    func getCode() -> Int {
        switch self {
        case .egypt:
            return 818
        case .uae:
            return 784
        case .qatar:
            return 634
        }
    }
}
