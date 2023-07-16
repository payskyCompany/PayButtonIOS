//
//  PaymentProcessingVC.swift
//  PayButton
//
//  Created by PaySky105 on 20/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import MOLH
import UIKit
import WebKit

protocol PaymentProcessingView: AnyObject {
    func loadWebView(withURL url: URL)
    func navigateToPaymentApprovedView(withTrxnResponse response: PayByCardReponse)
    func showErrorAlertView(withMessage errorMsg: String)
}

class PaymentProcessingVC: UIViewController, WKNavigationDelegate {
    @IBOutlet var closeCurrentPageBtn: UIButton!
    @IBOutlet var headerLbl: UILabel!
    @IBOutlet var merchantLbl: UILabel!
    @IBOutlet var merchantNameLbl: UILabel!
    @IBOutlet var amountLbl: UILabel!
    @IBOutlet var amountValueLbl: UILabel!

    @IBOutlet var enterCardDataLbl: UILabel!
    @IBOutlet var processingLbl: UILabel!
    @IBOutlet var paymentWKWebView: WKWebView!

    @IBOutlet var changeLangBtn: UIButton!
    @IBOutlet var termsAndConditionsBtn: UIButton!

    var presenter: PaymentProcessingPresenter!

    weak var delegate: PayButtonDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIView()
        setupWebView()
        presenter.viewDidLoad()
    }

    private func setupWebView() {
        paymentWKWebView.navigationDelegate = self
        paymentWKWebView.contentMode = .scaleAspectFill
        paymentWKWebView.scrollView.zoomScale = 2.0
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webView.showLoadingIndicator()
        
        guard let url = webView.url?.absoluteString else {
            return
        }
        if url.contains(AppConstants.DOMAIN_URL) && url.contains("Success") {
            debugPrint("new page url = \(url)")
            webView.hideLoadingIndicator()
            
            if webView.url?.queryDictionary?["Success"] == "True" {
                debugPrint(webView.url?.queryDictionary ?? "")
                var jsonObj: [String: Any] = [
                    "Message": webView.url?.queryDictionary?["Message"] as String? ?? "",
                    "ActionCode": webView.url?.queryDictionary?["ActionCode"] as String? ?? "",
                    "AuthCode": webView.url?.queryDictionary?["AuthCode"] as String? ?? "",
                    "MerchantReference": webView.url?.queryDictionary?["MerchantReference"] as String? ?? "",
                    "NetworkReference": webView.url?.queryDictionary?["NetworkReference"] as String? ?? "",
                    "ReceiptNumber": webView.url?.queryDictionary?["ReceiptNumber"] as String? ?? "",
                    "TokenCustomerId": MerchantDataManager.shared.merchant.customerId,
                ]
                jsonObj["SystemReference"] = Int(webView.url?.queryDictionary?["SystemReference"] ?? "0")
                if webView.url?.queryDictionary?["Success"] == "True" {
                    jsonObj["Success"] = true
                } else {
                    jsonObj["Success"] = false
                }
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj, options: []) {
                    do {
                        let response = try JSONDecoder().decode(PayByCardReponse.self, from: jsonData)
                        navigateToPaymentApprovedView(withTrxnResponse: response)
                    } catch let error {
                        showErrorAlertView(withMessage: error.localizedDescription)
                    }
                }
            } else if webView.url?.queryDictionary?["Success"] == "False" {
                showErrorAlertView(withMessage: webView.url?.queryDictionary?["Message"] ?? "")
            }
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isHidden = false
        webView.hideLoadingIndicator()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webView.hideLoadingIndicator()
    }

    @IBAction func dismissCurrentPageAction(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func changeLangBtnPressed(_ sender: UIButton) {
        UIView.appearance().semanticContentAttribute = MOLHLanguage.currentAppleLanguage() == "ar" ? .forceRightToLeft : .forceLeftToRight

        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        if MOLHLanguage.currentAppleLanguage() == "en" {
            UserDefaults.standard.set("en", forKey: "AppLanguage")
        } else {
            UserDefaults.standard.set("ar", forKey: "AppLanguage")
        }
        MOLH.reset()
        Bundle.swizzleLocalization()

        let viewController = PaymentProcessingVC(nibName: "PaymentProcessingVC", bundle: nil)
        viewController.delegate = delegate
        let newPresenter = PaymentProcessingPresenter(view: viewController,
                                                      paymentMethodData: presenter.getPaymentMethodData(),
                                                      urlPath: presenter.getUrlPath())

        viewController.presenter = newPresenter
        if UIApplication.topViewController()?.navigationController != nil {
            UIApplication.topViewController()?.dismiss(animated: true, completion: {
                UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
            })
        } else {
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.dismiss(animated: true, completion: {
                UIApplication.topViewController()?.present(viewController, animated: true)
            })
        }
    }

    @IBAction func termsAndConditionsBtnPressed(_ sender: UIButton) {
    }
}

extension PaymentProcessingVC {
    private func setupUIView() {
        closeCurrentPageBtn.setTitle("", for: .normal)
        headerLbl.text = "quick_payment_form".localizedString()
        merchantLbl.text = "merchant".localizedString().uppercased()
        merchantNameLbl.text = presenter.getPaymentMethodData().merchantName
        amountLbl.text = "amount".localizedString().uppercased()
        amountValueLbl.text = "\(MerchantDataManager.shared.merchant.currencyCode)".localizedString()
            + " " + String(format: "%.2f", MerchantDataManager.shared.merchant.amount)

        changeLangBtn.setTitle("change_lang".localizedString(), for: .normal)
        termsAndConditionsBtn.setTitle("terms_conditions".localizedString(), for: .normal)

        enterCardDataLbl.text = "processing_card_data".localizedString()
        processingLbl.text = "processing".localizedString()
    }
}

extension PaymentProcessingVC: PaymentProcessingView {
    func loadWebView(withURL url: URL) {
        let myRequest = URLRequest(url: url)
        paymentWKWebView.load(myRequest)
    }

    func navigateToPaymentApprovedView(withTrxnResponse response: PayByCardReponse) {
        let viewController = PaymentApprovedVC(nibName: "PaymentApprovedVC", bundle: nil)
        viewController.delegate = delegate

        let presenter = PaymentApprovedPresenter(view: viewController,
                                                 paymentMethodData: presenter.getPaymentMethodData(),
                                                 payByCardResponse: response)
        viewController.presenter = presenter

        if UIApplication.topViewController()?.navigationController != nil {
            UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
        } else {
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(viewController, animated: true)
        }
    }

    func showErrorAlertView(withMessage errorMsg: String) {
        UIApplication.topViewController()?.showAlert("error".localizedString(), message: errorMsg)
    }
}
