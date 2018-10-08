//
//  MainScanViewController.swift
//  PayButton
//
//  Created by AMR on 10/4/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit

class MainScanViewController: BasePaymentViewController , UITableViewDataSource, UITableViewDelegate ,ActionCellActionDelegate {
    

    var delegate: PaymentDelegate?
     var paymentData = PaymentData()
    func ComfirmBtnClick() {
        selectedCell = 3
        self.TableViews.reloadData()

    }
    
    func RequestMoney() {
        selectedCell = 4
        self.TableViews.reloadData()

    }
    

    
    @IBOutlet weak var CardImage: UIImageView!
    
    @IBOutlet weak var CardBtn: UIButton!
    
    @IBOutlet weak var CardView: UIView!
    
    
    @IBOutlet weak var WalletView: UIView!
    
    @IBOutlet weak var WalletImage: UIImageView!
    
    @IBOutlet weak var WalletBtn: UIButton!
    
    @IBOutlet weak var TableViews: UITableView!
    
    
    
    @IBOutlet weak var HeaderLabel: UILabel!
    
    
    @IBOutlet weak var HeaderView: UIView!
    
    
    @IBOutlet weak var CloseIcon: UIImageView!
    
    
    
    
    
    @IBOutlet weak var MerchantLabel: UILabel!
    
    @IBOutlet weak var AmountLabel: UILabel!
    
    @IBOutlet weak var MerchantId: UILabel!
    
    @IBOutlet weak var AmountValue: UILabel!
    
    
    
    var selectedCell = 1;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.WalletView.layer.cornerRadius =  PaySkySDKColor.RaduisNumber
        self.CardView.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        self.CardView.dropShadow()
        self.WalletView.dropShadow()
        self.HeaderLabel.text =  NSLocalizedString("quick_payment_form",bundle :  self.bandle,comment: "")
        
        
        
        self.MerchantLabel.text =  NSLocalizedString("merchant",bundle :  self.bandle,comment: "")
        self.AmountLabel.text =  NSLocalizedString("amount",bundle :  self.bandle,comment: "")

         self.AmountValue.text = String (paymentData.amount) + " " +  NSLocalizedString("egp",bundle :  self.bandle,comment: "")
          self.MerchantId.text = String (paymentData.merchantId)
        
        
        
        // Do any additional setup after loading the view.
        
        
        HeaderView.layer.cornerRadius = PaySkySDKColor.RaduisNumber 
        HeaderView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        
        
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(close(sender:)))
        
        
        self.CloseIcon.isUserInteractionEnabled = true
         self.CloseIcon.addGestureRecognizer(tap3)
        
      TableViews.register(UINib(nibName: "CardTableViewCell", bundle: nil), forCellReuseIdentifier: "CardTableViewCell")
        TableViews.register(UINib(nibName: "QRTableViewCell", bundle: nil), forCellReuseIdentifier: "QRTableViewCell")
        TableViews.register(UINib(nibName: "CompleteTableViewCell", bundle: nil), forCellReuseIdentifier: "CompleteTableViewCell")

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func close(sender: UITapGestureRecognizer? = nil) {
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func CardAction(_ sender: Any) {
   
        
        self.CardView.backgroundColor = PaySkySDKColor.mainBtnColor
        self.CardImage.image = #imageLiteral(resourceName: "card")
        self.CardBtn.setTitleColor(UIColor.white, for: UIControlState())
        
        
        
        self.WalletView.backgroundColor = UIColor.white
        self.WalletImage.image = #imageLiteral(resourceName: "wallet")
        self.WalletBtn.setTitleColor(UIColor.black, for: UIControlState())
        
        selectedCell = 1;
        self.TableViews.reloadData()
    }
    
    

    
    
    @IBAction func WalletAction(_ sender: Any) {
        
        self.WalletView.backgroundColor = PaySkySDKColor.mainBtnColor
        self.WalletImage.image =  #imageLiteral(resourceName: "selected_wallet")
        self.WalletBtn.setTitleColor(UIColor.white, for: UIControlState())
        
        
        
        self.CardView.backgroundColor = UIColor.white
        self.CardImage.image = #imageLiteral(resourceName: "un_selected_card")
        self.CardBtn.setTitleColor(UIColor.black, for: UIControlState())
     
        
        selectedCell = 2;
        self.TableViews.reloadData()
    }
    
 
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = BaseUITableViewCell();
        
   
        
        if selectedCell == 1 {
             cell = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCell") as! CardTableViewCell

        }else if selectedCell == 2 {
             cell = tableView.dequeueReusableCell(withIdentifier: "QRTableViewCell") as! QRTableViewCell

        }else if selectedCell == 3{
            cell = tableView.dequeueReusableCell(withIdentifier: "CompleteTableViewCell") as! CompleteTableViewCell
            cell.setData(true)

        }else if selectedCell == 4{
            cell = tableView.dequeueReusableCell(withIdentifier: "CompleteTableViewCell") as! CompleteTableViewCell
            cell.setData(false)
            
        }
        cell.delegateActions = self
      
        
        return cell
    }
    
    
}
