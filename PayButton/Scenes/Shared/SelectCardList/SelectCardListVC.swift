//
//  SelectCardListVC.swift
//  PayButton
//
//  Created by PaySky105 on 19/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import UIKit
import MOLH

protocol SelectCardListViewProtocol: AnyObject {
    func didTapToggleButton(forCell selectedCell: CardListTblCell)
    func didTapCvvTextField(forCell selectedCell: CardListTblCell)
    func openWebView(withUrlPath path: String)
    func navigateToPaymentApprovedView(withTrxnReference reference: String, andMessage message: String)
    func navigateToPaymentRejectedView(withMessage text: String)
    func updateSavedCardList(withAllCardResponse: GetCustomerCardsResponse)
    func navigateToManageCardsView()
    func navigateToAddNewCardView(withCheckPaymentResponse response: PaymentMethodResponse)
    func startLoading()
    func endLoading()
}

class SelectCardListVC: UIViewController {
    
    @IBOutlet weak var closeCurrentPageBtn: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var merchantLbl: UILabel!
    @IBOutlet weak var merchantNameLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var amountValueLbl: UILabel!
    
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var changeLangBtn: UIButton!
    @IBOutlet weak var termsAndConditionsBtn: UIButton!
    
    @IBOutlet weak var cardListTbl: UITableView!
    @IBOutlet weak var cardListTblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var selectCardLbl: UILabel!
    @IBOutlet weak var manageCardsBtn: UIButton!
    @IBOutlet weak var addNewCardBtn: UIButton!

    var presenter: SelectCardListPresenter!
    
    weak var delegate: PayButtonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUIView()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.cardListTblHeight?.constant = self.cardListTbl.contentSize.height
    }
    
    private func setupUIView() {
        closeCurrentPageBtn.setTitle("", for: .normal)
        headerLbl.text = "quick_payment_form".localizedString()
        merchantLbl.text = "merchant".localizedString().uppercased()
        merchantNameLbl.text = MerchantDataManager.shared.merchant.merchantId
        amountLbl.text = "amount".localizedString().uppercased()
        amountValueLbl.text = "\(MerchantDataManager.shared.merchant.currencyCode)".localizedString()
        + " " + "\(MerchantDataManager.shared.merchant.amount)"
        
        proceedBtn.setTitle("proceed".localizedString(), for: .normal)
        backBtn.setTitle("back".localizedString(), for: .normal)
        changeLangBtn.setTitle("change_lang".localizedString(), for: .normal)
        termsAndConditionsBtn.setTitle("terms_conditions".localizedString(), for: .normal)
        
        cardListTbl.register(UINib(nibName: "CardListTblCell", bundle: nil),
                             forCellReuseIdentifier: "CardListTblCell")
        cardListTbl.dataSource = self
        cardListTbl.delegate = self
        cardListTbl.estimatedRowHeight = 100
        cardListTbl.rowHeight = UITableView.automaticDimension
        
        selectCardLbl.text = "select_card".localizedString()
        manageCardsBtn.setTitle("manage_cards".localizedString(), for: .normal)
        addNewCardBtn.setTitle("add_new_card".localizedString(), for: .normal)
    }
    
    @IBAction func manageCardsBtnPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func addNewCardBtnPressed(_ sender: UIButton) {
        let viewController = AddNewCardVC(nibName: "AddNewCardVC", bundle: nil)
        viewController.delegate = self.delegate
        
        let presenter = AddNewCardPresenter(view: viewController, paymentMethodData: presenter.getPaymentMethodData())
        viewController.presenter = presenter
        
        if UIApplication.topViewController()?.navigationController != nil {
            UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
        } else {
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(viewController, animated: true)
        }
    }
    
    @IBAction func proceedBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func dismissCurrentPageAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func changeLangBtnPressed(_ sender: UIButton) {
        UIView.appearance().semanticContentAttribute = MOLHLanguage.currentAppleLanguage() == "ar" ? .forceRightToLeft : .forceLeftToRight
        
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        if (MOLHLanguage.currentAppleLanguage()=="en") {
            UserDefaults.standard.set("en", forKey: "AppLanguage")
        }else{
            UserDefaults.standard.set("ar", forKey: "AppLanguage")
        }
        MOLH.reset()
        Bundle.swizzleLocalization()
        
        let viewController = SelectCardListVC(nibName: "SelectCardListVC", bundle: nil)
        viewController.delegate = self.delegate
        let newPresenter = SelectCardListPresenter(view: viewController, paymentMethodData:
                                                    presenter.getPaymentMethodData(),
                                                   customerCards: presenter.getCustomerCards())
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

extension SelectCardListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getCustomerCards().cardsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardListTblCell", for: indexPath) as! CardListTblCell
        cell.configure(presenter.getCustomerCards().cardsList?[indexPath.row])
        return cell
    }
}

extension SelectCardListVC: SelectCardListViewProtocol {
    func didTapToggleButton(forCell selectedCell: CardListTblCell) {
        print("didTapToggleButton")
    }
    
    func didTapDeleteIconButton(forCell selectedCell: CardListTblCell) {
        print("didTapDeleteIconButton")
    }
    
    func didTapCvvTextField(forCell selectedCell: CardListTblCell) {
        print("didTapCvvTextField")
    }
    
    func openWebView(withUrlPath path: String) {
        print("openWebView")
    }
    
    func navigateToPaymentApprovedView(withTrxnReference reference: String, andMessage message: String) {
        print("navigateToPaymentApprovedView")
    }
    
    func navigateToPaymentRejectedView(withMessage text: String) {
        print("navigateToPaymentRejectedView")
    }
    
    func updateSavedCardList(withAllCardResponse: GetCustomerCardsResponse) {
        print("updateSavedCardList")
    }
    
    func navigateToManageCardsView() {
        
    }
    
    func navigateToAddNewCardView(withCheckPaymentResponse response: PaymentMethodResponse) {
        let viewController = AddNewCardVC(nibName: "AddNewCardVC", bundle: nil)
        viewController.delegate = self.delegate
        
        let presenter = AddNewCardPresenter(view: viewController, paymentMethodData: response)
        viewController.presenter = presenter
        
        if UIApplication.topViewController()?.navigationController != nil {
            UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
        } else {
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(viewController, animated: true)
        }
    }
    
    func startLoading() {
        print("startLoading")
    }
    
    func endLoading() {
        print("endLoading")
    }
}
