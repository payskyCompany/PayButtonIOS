//
//  QRTableViewCell.swift
//  PayButton
//
//  Created by AMR on 10/6/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit
import QRCode
import PopupDialog
class QRTableViewCell: BaseUITableViewCell {

    @IBOutlet weak var ScanQrLabel: UILabel!
    
    @IBOutlet weak var CantScanLabel: UILabel!
    
    
    @IBOutlet weak var QrImage: UIImageView!
    
    @IBOutlet weak var QrLabelCenter: UILabel!
    
    @IBOutlet weak var requestBtn: UIButton!
    
    var bandle :Bundle!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        self.backgroundColor = UIColor.clear
            
        let path = Bundle(for: CardTableViewCell.self).path(forResource:"PayButton", ofType: "bundle")
        
        
        if path != nil {
            bandle = Bundle(path: path!) ?? Bundle.main
        }else {
            bandle = Bundle.main
            
        }
        requestBtn.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        QrLabelCenter.text =  NSLocalizedString("or",bundle :  self.bandle,comment: "")

        ScanQrLabel.text =  NSLocalizedString("open_wallet_app",bundle :  self.bandle,comment: "")
        CantScanLabel.text =  NSLocalizedString("cant_scan_code",bundle :  self.bandle,comment: "")
        requestBtn.setTitle(NSLocalizedString("request_payment",bundle :  self.bandle,comment: ""), for: .normal)
        
        let qrCode = QRCode( MainScanViewController.paymentData.staticQR )
        self.QrImage.image =  qrCode?.image
        requestBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
        
        
        
        


    }
    
    
    
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func RequestMoneyAction(_ sender: Any) {
        
        let popupVC = RequestMoneyViewController(nibName: "RequestMoneyViewController", bundle: nil)
 
        
        let popup = PopupDialog(viewController: popupVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, preferredWidth: 600, gestureDismissal: true)
        
        self.viewContainingController()?.present(popup, animated: true, completion: nil)
     
        
        

        
    }
    
    
    
    
}
