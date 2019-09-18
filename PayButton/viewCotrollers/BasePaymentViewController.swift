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
    

     var fromNav = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
          
        
        TermsAndCondition?.text = "terms_conditions".localizedPaySky()

        self.navigationController?.isNavigationBarHidden = true
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        view.addGestureRecognizer(tap)
  

        
        
        
       
    }


//Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
}
    
    override func viewDidAppear(_ animated: Bool) {

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func close(_ sender: Any) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.isNavigationBarHidden = false

        }else{
            self.dismiss(animated: true, completion: nil)
            
        }
        

    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
