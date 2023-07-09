//
//  BasePaymentViewController.swift
//  PayButton
//
//  Created by AMR on 7/3/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit

class BasePaymentViewController: UIViewController {
    var fromNav = false
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true

        // Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func close(_ sender: Any) {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
            navigationController?.isNavigationBarHidden = false

        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
