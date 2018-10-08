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
    
    func setData(_ selected: Bool) {

        
    }
    
    

}
protocol ActionCellActionDelegate: class {
    func ComfirmBtnClick()
    func RequestMoney()

}
