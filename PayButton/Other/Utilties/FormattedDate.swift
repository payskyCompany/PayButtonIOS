//
//  FormattedDate.swift
//  PayButton
//
//  Created by Nada Kamel on 29/05/2023.
//  Copyright © 2023 Paysky. All rights reserved.
//

import Foundation

public class FormattedDate {
    
    public static func getDate() -> String {
        let date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmmssSSS"
        dateFormatter.locale = Locale(identifier: "en")
        let todaysDate = dateFormatter.string(from: date)
        return  todaysDate
   }
    
    
}
