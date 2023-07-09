//
//  CardScanViewController.swift
//  PayButton
//
//  Created by AMR on 7/10/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import PayCardsRecognizer
import UIKit

protocol ScanCardDelegate: AnyObject {
    func cardResult(_ result: PayCardsRecognizerResult)
}

class CardScanViewController: UIViewController, PayCardsRecognizerPlatformDelegate {
    @IBOutlet var HeaderView: UIView!
    @IBOutlet var CloseImage: UIImageView!
    @IBOutlet var HeaderLabel: UILabel!
    @IBOutlet var CameraView: UIView!

    var recognizer: PayCardsRecognizer!
    var delegate: ScanCardDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        recognizer = PayCardsRecognizer(delegate: self, resultMode: .async, container: CameraView, frameColor: .green)
        recognizer.delegate = self

        let tap3 = UITapGestureRecognizer(target: self, action: #selector(close(sender:)))

        HeaderView.layer.cornerRadius = AppConstants.radiusNumber
        HeaderView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        CloseImage.isUserInteractionEnabled = true
        CloseImage.addGestureRecognizer(tap3)
        HeaderLabel.text = "scanCard".localizedString()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func close(sender: UITapGestureRecognizer? = nil) {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
            navigationController?.isNavigationBarHidden = false

        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recognizer.startCamera()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        recognizer.stopCamera()
    }

    func payCardsRecognizer(_ payCardsRecognizer: PayCardsRecognizer, didRecognize result: PayCardsRecognizerResult) {
        delegate.cardResult(result)
        recognizer.stopCamera()
        dismiss(animated: true, completion: nil)
    }
}
