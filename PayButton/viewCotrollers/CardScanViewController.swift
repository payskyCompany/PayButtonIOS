//
//  CardScanViewController.swift
//  tokenization
//
//  Created by AMR on 7/10/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit
import PayCardsRecognizer

class CardScanViewController: UIViewController ,PayCardsRecognizerPlatformDelegate{
    var recognizer: PayCardsRecognizer!

    var delegate : ScanCardtDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
       recognizer = PayCardsRecognizer(delegate: self, resultMode: .sync, container: self.view, frameColor: .green)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.navigationController?.popViewController(animated: true)


    }
 

}
protocol ScanCardtDelegate: class {
    func cardResult(_ result :PayCardsRecognizerResult )
}

