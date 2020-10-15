//
//  MainScanViewController.swift
//  PayButton
//
//  Created by AMR on 10/4/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit
import  MOLH
extension UITableView {

    func setBottomInset(to value: CGFloat) {
        let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)

        self.contentInset = edgeInset
        self.scrollIndicatorInsets = edgeInset
    }
}

class MainScanViewController: BasePaymentViewController , UITableViewDataSource, UITableViewDelegate ,ActionCellActionDelegate {
    let PaySkyTitle = "PAYSKY"
    let upgTitle = "UPG"
    @IBOutlet weak var imageLogo: UIImageView!
    let selectedTitle = "PAYSKY"
    @IBAction func ChangeLangAction(_ sender: Any) {
      

        
        
        
            
            UIView.appearance().semanticContentAttribute = MOLHLanguage.currentAppleLanguage() == "ar" ? .forceRightToLeft : .forceLeftToRight
            
            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
            if (MOLHLanguage.currentAppleLanguage()=="en"){
                UserDefaults.standard.set("en", forKey: "AppLanguage")
            }else{
                UserDefaults.standard.set("ar", forKey: "AppLanguage")
            }
            
            MOLH.reset()
            Bundle.swizzleLocalization()
        let st = UIStoryboard(name: "PayButtonBoard", bundle: nil)

               let vc :MainScanViewController = st.instantiateViewController(withIdentifier: "MainScanViewController") as! MainScanViewController
        vc.delegate = self.delegate

               vc.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.dismiss(animated: true, completion: {
            UIApplication.topViewController()?.present(vc, animated: true,completion: nil)
            vc.fromNav = self.fromNav
            })
             

    }
    
     var compose3DSTransactionResponse: TransactionStatusResponse = TransactionStatusResponse()
      var manualPaymentRequest: ManualPaymentRequest = ManualPaymentRequest()
    
    
    func openWebView(compose3DSTransactionResponse: TransactionStatusResponse, manualPaymentRequest: ManualPaymentRequest) {
        
        
        self.compose3DSTransactionResponse = compose3DSTransactionResponse
        self.manualPaymentRequest = manualPaymentRequest
        
        selectedCell = 4
        
        self.TableViews.reloadData()
    }
    
 
    
    
    func closeWebView( compose3DSTransactionResponse: TransactionStatusResponse) {
        
       
        UIApplication.topViewController()?.view.hideLoadingIndicator()

        transactionStatusResponse = compose3DSTransactionResponse
        transactionStatusResponse.FROMWHERE = "Card"

        self.SaveCard(transactionStatusResponse: compose3DSTransactionResponse)
        
        
        
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
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.isNavigationBarHidden = false

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
var UrlTypeRow = 0

    

    
    

    
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
    @IBOutlet weak var scroller: UIScrollView!
    var selectedCell = 1;
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopTimerTest()
    }
    
  @objc func keyboardWillShow(notification: NSNotification) {
      if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
          if self.view.frame.origin.y == 0 {
              self.view.frame.origin.y -= keyboardSize.height
          }
      }
  }

  @objc func keyboardWillHide(notification: NSNotification) {
      if self.view.frame.origin.y != 0 {
          self.view.frame.origin.y = 0
      }
  }
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedTitle == PaySkyTitle {
            imageLogo.image = UIImage(named:"power_by_paysky")
              }
              else {
                imageLogo.image = UIImage(named:"upg_orange_logo")
              }

        
        self.TableViews.isScrollEnabled = false
        self.TableViews.isPagingEnabled = false
//         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.WalletView.layer.cornerRadius =  PaySkySDKColor.RaduisNumber
        self.CardView.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        self.CardView.dropShadow()
        self.WalletView.dropShadow()
        self.HeaderLabel.text =  "quick_payment_form".localizedPaySky()
        
        self.CardBtn.setTitle( "card".localizedPaySky(), for: .normal)
        self.WalletBtn.setTitle( "wallet".localizedPaySky(), for: .normal)

        
        self.MerchantLabel.text =  "merchant".localizedPaySky()
        
     
        
        let currncy =  cleanDollars(String(MainScanViewController.paymentData.amount / 100))
        
        self.AmountLabel.text =  "amount".localizedPaySky()

        self.AmountValue.text =    "\(MainScanViewController.paymentData.currencyCode )"  .localizedPaySky()
           + " " + currncy
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
            self.navigationController?.popViewController(animated: true)
            
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

        }else if selectedCell == 4 {
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






extension Bundle {
    static func swizzleLocalization() {
        let orginalSelector = #selector(localizedString(forKey:value:table:))
        guard let orginalMethod = class_getInstanceMethod(self, orginalSelector) else { return }

        let mySelector = #selector(myLocaLizedString(forKey:value:table:))
        guard let myMethod = class_getInstanceMethod(self, mySelector) else { return }

        if class_addMethod(self, orginalSelector, method_getImplementation(myMethod), method_getTypeEncoding(myMethod)) {
            class_replaceMethod(self, mySelector, method_getImplementation(orginalMethod), method_getTypeEncoding(orginalMethod))
        } else {
            method_exchangeImplementations(orginalMethod, myMethod)
        }
    }

    @objc private func myLocaLizedString(forKey key: String,value: String?, table: String?) -> String {
        guard let bundlePath = Bundle.main.path(forResource: MOLHLanguage.currentAppleLanguage(), ofType: "lproj"),
            let bundle = Bundle(path: bundlePath) else {
                return Bundle.main.myLocaLizedString(forKey: key, value: value, table: table)
        }
        return bundle.myLocaLizedString(forKey: key, value: value, table: table)
    }
}
