//
//  AddNewCardVC.swift
//  PayButton
//
//  Created by PaySky105 on 18/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import UIKit

class AddNewCardVC: UIViewController {

    @IBOutlet weak var scanCardNumber: UIButton!
    @IBOutlet weak var saveForFutureBtn: CheckBox!
    @IBOutlet weak var setAsDefaultBtn: CheckBox!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUIView()
        
    }//--- end of viewDidLoad

    
    
    
}//--- end of class

extension AddNewCardVC {
    private func setupUIView(){
        scanCardNumber.setTitle("", for: .normal)
        saveForFutureBtn.setTitle("", for: .normal)
        setAsDefaultBtn.setTitle("", for: .normal)
    }
}
