//
//  CardScanViewController.swift
//  tokenization
//
//  Created by AMR on 7/10/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit
import PayCardsRecognizer

class CardScanViewController: BasePaymentViewController ,PayCardsRecognizerPlatformDelegate{
    var recognizer: PayCardsRecognizer!

    var delegate : ScanCardtDelegate!

    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var CloseImage: UIImageView!
    @IBOutlet weak var HeaderLabel: UILabel!
    @IBOutlet weak var CameraView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       recognizer = PayCardsRecognizer(delegate: self, resultMode: .async, container: self.CameraView, frameColor: .green)
        // Do any additional setup after loading the view.
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(close(sender:)))
        
        recognizer.delegate = self
        
        HeaderView.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        HeaderView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.CloseImage.isUserInteractionEnabled = true
        self.CloseImage.addGestureRecognizer(tap3)
        HeaderLabel.text = "scanCard".localizedPaySky()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func close(sender: UITapGestureRecognizer? = nil) {
        
        
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.isNavigationBarHidden = false

        }else{
            self.dismiss(animated: true, completion: nil)
            
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
        self.dismiss(animated: true, completion: nil)


    }
 

}
protocol ScanCardtDelegate: class {
    func cardResult(_ result :PayCardsRecognizerResult )
}

