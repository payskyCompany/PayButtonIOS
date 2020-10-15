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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func setData(transactionStatusResponse: TransactionStatusResponse) {
        
        
    }

    func openWebView(compose3DSTransactionResponse:TransactionStatusResponse ,
                     manualPaymentRequest : ManualPaymentRequest
        ){
        
    }
}
protocol ActionCellActionDelegate: class {
    func SaveCard(transactionStatusResponse:TransactionStatusResponse)
    func completeRequest(transactionStatusResponse:TransactionStatusResponse)
    
    
    func openWebView(compose3DSTransactionResponse:TransactionStatusResponse ,
                         manualPaymentRequest : ManualPaymentRequest
                         )
   
    func closeWebView(compose3DSTransactionResponse:TransactionStatusResponse 
    )
     func tryAgin()

}
