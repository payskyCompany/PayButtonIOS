//
//  QRTableViewCell.swift
//  PayButton
//
//  Created by AMR on 10/6/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit
import PopupDialog
class QRTableViewCell: BaseUITableViewCell {

    @IBOutlet weak var ScanQrLabel: UILabel!
    
    @IBOutlet weak var CantScanLabel: UILabel!
    
    
    @IBOutlet weak var QrImage: UIImageView!
    
    @IBOutlet weak var QrLabelCenter: UILabel!
    
    @IBOutlet weak var requestBtn: UIButton!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        self.backgroundColor = UIColor.clear
            
        
        
        requestBtn.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        QrLabelCenter.text =  "or".localizedPaySky()

        ScanQrLabel.text =  "open_wallet_app".localizedPaySky()
        CantScanLabel.text =  "cant_scan_code".localizedPaySky()
        requestBtn.setTitle("request_payment".localizedPaySky(), for: .normal)
        
        let qrCode = QRCode( MainScanViewController.paymentData.staticQR )
        print(MainScanViewController.paymentData.staticQR)
        self.QrImage.image =  qrCode?.image
        requestBtn.titleLabel?.adjustsFontSizeToFitWidth = true

    }
    
    
    
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func RequestMoneyAction(_ sender: Any) {
        
        let popupVC = RequestMoneyViewController(nibName: "RequestMoneyViewController", bundle: nil)
 
        
        popupVC.SendHandler = { (base) in
            
            if base.Success {
                popupVC.dismiss(animated: true, completion: {
                    UIApplication.topViewController()?.view.makeToast(
                        "request_send_to_mobile".localizedPaySky()
                    )
                })
                
  

            }

            
        }
        

        
        let popup = PopupDialog(viewController: popupVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, preferredWidth: 600, tapGestureDismissal: true)
        
   
        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
        
        

        
    }
    
    
    
    
}
