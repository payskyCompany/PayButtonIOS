//
//  BaseUITableViewCell.swift
//  PayButton
//
//  Created by AMR on 10/4/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit

class BaseUITableViewCell: UITableViewCell {
    weak var delegateActions: ActionCellActionDelegate?
    var bandle :Bundle!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let path = Bundle(for: CardTableViewCell.self).path(forResource:"PayButton", ofType: "bundle")
        
        
        if path != nil {
            bandle = Bundle(path: path!) ?? Bundle.main
        }else {
            bandle = Bundle.main
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func setData(transactionStatusResponse: TransactionStatusResponse) {
        
        
    }

    func openWebView(compose3DSTransactionResponse:Compose3DSTransactionResponse ,
                     manualPaymentRequest : ManualPaymentRequest
        ){
        
    }
}
protocol ActionCellActionDelegate: class {
    func SaveCard(transactionStatusResponse:TransactionStatusResponse)
    func completeRequest(transactionStatusResponse:TransactionStatusResponse)
    
    
    func openWebView(compose3DSTransactionResponse:Compose3DSTransactionResponse ,
                         manualPaymentRequest : ManualPaymentRequest
                         )
   
    func closeWebView(encodeData:String ,compose3DSTransactionResponse:Compose3DSTransactionResponse ,
                      manualPaymentRequest : ManualPaymentRequest
    )
     func tryAgin()

}
