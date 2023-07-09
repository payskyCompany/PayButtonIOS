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
    func showActivityIndicator(show: Bool)
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
    @IBOutlet var paymentWKWebView: WKWebView!

    @IBOutlet var changeLangBtn: UIButton!
    @IBOutlet var termsAndConditionsBtn: UIButton!

    let loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .mainColor
        spinner.hidesWhenStopped = true
        spinner.backgroundColor = .lightText
        spinner.layer.cornerRadius = 20
        spinner.layer.masksToBounds = true
        return spinner
    }()

    var presenter: PaymentProcessingPresenter!

    weak var delegate: PayButtonDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIView()
        setupWebView()
        addSpinnerView()
        presenter.viewDidLoad()
    }

    private func setupWebView() {
        paymentWKWebView.navigationDelegate = self
        paymentWKWebView.contentMode = .scaleAspectFill
        paymentWKWebView.scrollView.zoomScale = 2.0
    }

    private func addSpinnerView() {
        if let topControllerView = UIApplication.topViewController()?.view {
            topControllerView.addSubview(loadingSpinner)
            loadingSpinner.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
            loadingSpinner.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
            loadingSpinner.centerXAnchor.constraint(equalTo: topControllerView.centerXAnchor).isActive = true
            loadingSpinner.centerYAnchor.constraint(equalTo: topControllerView.centerYAnchor).isActive = true
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
        guard let url = webView.url?.absoluteString else {
            return
        }
        if url.contains(AppConstants.DOMAIN_URL) && url.contains("Success") {
            debugPrint("new page url = \(url)")
            webView.isHidden = true

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
        showActivityIndicator(show: false)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
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
        merchantNameLbl.text = MerchantDataManager.shared.merchant.merchantId
        amountLbl.text = "amount".localizedString().uppercased()
        amountValueLbl.text = "\(MerchantDataManager.shared.merchant.currencyCode)".localizedString()
            + " " + String(format: "%.2f", MerchantDataManager.shared.merchant.amount)

        changeLangBtn.setTitle("change_lang".localizedString(), for: .normal)
        termsAndConditionsBtn.setTitle("terms_conditions".localizedString(), for: .normal)

        enterCardDataLbl.text = "please_enter_card_data".localizedString()
    }
}

extension PaymentProcessingVC: PaymentProcessingView {
    func loadWebView(withURL url: URL) {
        paymentWKWebView.isHidden = false
        let myRequest = URLRequest(url: url)
        paymentWKWebView.load(myRequest)
    }

    func showActivityIndicator(show: Bool) {
        if show {
            loadingSpinner.startAnimating()
        } else {
            loadingSpinner.stopAnimating()
        }
    }

    func navigateToPaymentApprovedView(withTrxnResponse response: PayByCardReponse) {
        let viewController = PaymentApprovedVC(nibName: "PaymentApprovedVC", bundle: nil)
        viewController.delegate = delegate

        let presenter = PaymentApprovedPresenter(view: viewController, payByCardResponse: response)
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
