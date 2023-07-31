//
//  Bundle+version.swift
//  PayButton
//
//  Created by Nada Kamel on 09/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation

extension Bundle {
    
    var targetName: String? {
        return infoDictionary?["CFBundleName"] as? String
    }
    
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String {
        return (infoDictionary?["CFBundleVersion"] as? String) ?? "1"
    }
    
    var releaseVersionNumberPretty: String {
        return "Version \(releaseVersionNumber ?? "1.0.0")"
    }
}
