//
//  QrGenratorResponse.swift
//  PayButton
//
//  Created by AMR on 10/8/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import Foundation
import Foundation
import EVReflection
public class QrGenratorResponse: BaseResponse {

    var ISOQR: String = ""
    var IsTahweelQR = true, IsmVisaQR: Bool = true
    var MName = "", MerchantReference: String = ""
    var ReceiverCountryId: Int = 0
    var ResCode: String = ""
    var SystemReference: Int = 0
    var TxnDate: String = ""
    var Validity: String = ""


}
