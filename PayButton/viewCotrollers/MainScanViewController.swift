//
//  MainScanViewController.swift
//  PayButton
//
//  Created by AMR on 10/4/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit

class MainScanViewController: BasePaymentViewController , UITableViewDataSource, UITableViewDelegate ,ActionCellActionDelegate {

    
    
    
    
    
    func closeWebView(encodeData: String, compose3DSTransactionResponse: Compose3DSTransactionResponse, manualPaymentRequest: ManualPaymentRequest) {
        
        
        
                                ApiManger.Process3DSTransaction(ThreeDSResponseData: encodeData,
                                                                GatewayType: compose3DSTransactionResponse.GatewayType
                                                                ,completion: { (process3d) in
        
                                    if process3d.Success {
                                        manualPaymentRequest.ThreeDSECI = process3d.ThreeDSECI
                                        manualPaymentRequest.ThreeDSXID = process3d.ThreeDSXID
                                        manualPaymentRequest.ThreeDSenrolled = process3d.ThreeDSenrolled
                                        manualPaymentRequest.ThreeDSstatus = process3d.ThreeDSstatus
                                        manualPaymentRequest.VerToken = process3d.VerToken
                                        manualPaymentRequest.VerType = process3d.VerType
                                         manualPaymentRequest.DateTimeLocalTrxn = BaseResponse.getDate()
        
                                        ApiManger.PayByCard(addcardRequest: manualPaymentRequest, completion: { (transStatus) in
                                            transStatus.FROMWHERE = "Card"
                                            self.SaveCard(transactionStatusResponse: transStatus)
        
        
                                        })
        
        
                                    }else {
                                        
                                        self.selectedCell = 1
                                        
                                        self.TableViews.reloadData()
                                        UIApplication.topViewController()?.view.makeToast(process3d.Message)
        
                                    }
                                })
        
                            }
    
    
    
    var compose3DSTransactionResponse: Compose3DSTransactionResponse = Compose3DSTransactionResponse()
    var manualPaymentRequest: ManualPaymentRequest = ManualPaymentRequest()
    func openWebView(compose3DSTransactionResponse: Compose3DSTransactionResponse, manualPaymentRequest: ManualPaymentRequest) {
        self.compose3DSTransactionResponse = compose3DSTransactionResponse
        self.manualPaymentRequest = manualPaymentRequest

        selectedCell = 4
        
        self.TableViews.reloadData()
    }
    
   
    
    
    func tryAgin() {
        if MainScanViewController.paymentData.PaymentMethod == 0  || MainScanViewController.paymentData.PaymentMethod == 2{
            selectedCell = 1
        }
        if MainScanViewController.paymentData.PaymentMethod == 1 {
            selectedCell = 2
        }
        

          self.TableViews.reloadData()
    }
    
    func completeRequest(transactionStatusResponse: TransactionStatusResponse) {
        delegate?.finishSdkPayment(transactionStatusResponse)
        if self.navigationController != nil {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }else{
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
 
    var transactionStatusResponse = TransactionStatusResponse ()
    func SaveCard(transactionStatusResponse: TransactionStatusResponse) {
        self.transactionStatusResponse = transactionStatusResponse
        selectedCell = 3
        self.TableViews.reloadData()
        
        if transactionStatusResponse.Success {
            self.MethodTypeStackView.isHidden = true
        }
    }
    
    

    var delegate: PaymentDelegate?
   public static  var paymentData = PaymentData()


    

    
    

    
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
    
    
    
    @IBOutlet weak var MethodTypeStackView: UIStackView!
    var selectedCell = 1;
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopTimerTest()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.WalletView.layer.cornerRadius =  PaySkySDKColor.RaduisNumber
        self.CardView.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        self.CardView.dropShadow()
        self.WalletView.dropShadow()
        self.HeaderLabel.text =  NSLocalizedString("quick_payment_form",bundle :  self.bandle,comment: "")
        
        self.CardBtn.setTitle( NSLocalizedString("card",bundle :  self.bandle,comment: ""), for: .normal)
        self.WalletBtn.setTitle( NSLocalizedString("wallet",bundle :  self.bandle,comment: ""), for: .normal)

        
        self.MerchantLabel.text =  NSLocalizedString("merchant",bundle :  self.bandle,comment: "")
        
     
        
        let currncy =  cleanDollars(String(MainScanViewController.paymentData.amount / 100))
        
        self.AmountLabel.text =  NSLocalizedString("amount",bundle :  self.bandle,comment: "")

        self.AmountValue.text =   NSLocalizedString("egp",bundle :  self.bandle,comment: "") + " " + currncy
        self.MerchantId.text = String (MainScanViewController.paymentData.merchant_name)
        
        
        
        // Do any additional setup after loading the view.
        
        
        HeaderView.layer.cornerRadius = PaySkySDKColor.RaduisNumber 
        HeaderView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        
        
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(close(sender:)))
        
        
        self.CloseIcon.isUserInteractionEnabled = true
         self.CloseIcon.addGestureRecognizer(tap3)
        
      TableViews.register(UINib(nibName: "CardTableViewCell", bundle: nil), forCellReuseIdentifier: "CardTableViewCell")
        TableViews.register(UINib(nibName: "QRTableViewCell", bundle: nil), forCellReuseIdentifier: "QRTableViewCell")
        TableViews.register(UINib(nibName: "CompleteTableViewCell", bundle: nil), forCellReuseIdentifier: "CompleteTableViewCell")
        
                TableViews.register(UINib(nibName: "WebViewTableViewCell", bundle: nil), forCellReuseIdentifier: "WebViewTableViewCell")

        self.MethodTypeStackView.isHidden = true

        if MainScanViewController.paymentData.PaymentMethod == 0 || MainScanViewController.paymentData.PaymentMethod == 1{
            self.MethodTypeStackView.isHidden = true
        }else if MainScanViewController.paymentData.PaymentMethod == 2 {
            self.MethodTypeStackView.isHidden = false

        }
        if MainScanViewController.paymentData.PaymentMethod == 0 {
            selectedCell = 1
        }
        if MainScanViewController.paymentData.PaymentMethod == 1 {
            selectedCell = 2
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func close(sender: UITapGestureRecognizer? = nil) {
        
        delegate?.finishSdkPayment(transactionStatusResponse)

        
        if self.navigationController != nil {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }else{
            self.dismiss(animated: true, completion: nil)

        }
    }
    
    
    @IBAction func CardAction(_ sender: Any) {
   
        
        self.CardView.backgroundColor = PaySkySDKColor.mainBtnColor
        self.CardImage.image = #imageLiteral(resourceName: "card")
        self.CardBtn.setTitleColor(UIColor.white, for: UIControl.State())
        
        
        
        self.WalletView.backgroundColor = UIColor.white
        self.WalletImage.image = #imageLiteral(resourceName: "wallet")
        self.WalletBtn.setTitleColor(UIColor.black, for: UIControl.State())
        
        selectedCell = 1;
        self.TableViews.reloadData()
    }
    
    

    
    
    @IBAction func WalletAction(_ sender: Any) {
        
        self.WalletView.backgroundColor = PaySkySDKColor.mainBtnColor
        self.WalletImage.image =  #imageLiteral(resourceName: "selected_wallet")
        self.WalletBtn.setTitleColor(UIColor.white, for: UIControl.State())
        
        
        
        self.CardView.backgroundColor = UIColor.white
        self.CardImage.image = #imageLiteral(resourceName: "un_selected_card")
        self.CardBtn.setTitleColor(UIColor.black, for: UIControl.State())
     
        
        selectedCell = 2;
        self.TableViews.reloadData()
    }
    
 
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    var cell = BaseUITableViewCell();
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
   
        
        if selectedCell == 1 {
             cell = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCell") as! CardTableViewCell

        }else if selectedCell == 2 {
             cell = tableView.dequeueReusableCell(withIdentifier: "QRTableViewCell") as! QRTableViewCell

        }else if selectedCell == 3{
            cell = tableView.dequeueReusableCell(withIdentifier: "CompleteTableViewCell") as! CompleteTableViewCell
            cell.setData(transactionStatusResponse: self.transactionStatusResponse)

        }else if selectedCell == 4{
            cell = tableView.dequeueReusableCell(withIdentifier: "WebViewTableViewCell") as! WebViewTableViewCell
            cell.openWebView(compose3DSTransactionResponse: self.compose3DSTransactionResponse, manualPaymentRequest: self.manualPaymentRequest)
            
        }
        
        
        
        
        
        cell.delegateActions = self
      
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if selectedCell == 2 {
            startTimer ()

        }else{
            stopTimerTest()
        }
    }
    
  
    
    
    
    func stopTimerTest() {
        if  self.timerTest.isValid {
            self.timerTest.invalidate()
            
        }
    }
    
    func startTimer () {
        
        if !timerTest.isValid {
            timerTest = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(MainScanViewController.CheckRequestStatus), userInfo: nil, repeats: true)
        }
    }
    var timerTest : Timer = Timer()
    @objc func CheckRequestStatus()
    {
        if timerTest.isValid  {
            ApiManger.checkTransactionPaymentStatus(transactionId: MainScanViewController.paymentData.orderId) { (transactionStatus) in
                if transactionStatus.IsPaid {
                    self.stopTimerTest()
                    transactionStatus.FROMWHERE = "Tahweel"
                    self.transactionStatusResponse = transactionStatus
                    self.selectedCell = 3
                    self.TableViews.reloadData()
                    
                    self.MethodTypeStackView.isHidden = true
                    

                }
                
                
            }
            
        }
        
        
    }
    
}
