//
//  BasePaymentViewController.swift
//  tokenization
//
//  Created by AMR on 7/3/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit


class BasePaymentViewController: UIViewController {
    @IBOutlet weak var TermsAndCondition: UILabel!
    

    var bandle : Bundle!
    var fromNav = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
            let path = Bundle(for: BasePaymentViewController.self).path(forResource:"PayButton", ofType: "bundle")
        if path == nil {
            bandle = Bundle.main
        }else {
            bandle = Bundle(path: path!) ?? Bundle.main

        }
        
        
   
        self.navigationController?.isNavigationBarHidden = true
        
        
     TermsAndCondition?.text = NSLocalizedString("terms_conditions",bundle :  self.bandle,comment: "")
        
        
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
